#!/usr/bin/env pwsh

param([switch]$UnregServer)

trap
{
	throw $PSItem
}

$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

$ProcessArchitecture = $Env:PROCESSOR_ARCHITECTURE.ToLower()

switch ($ProcessArchitecture)
{
	'amd64' { $ProcessArchitecture = 'x64' }
}

$ProgramFiles = $Env:ProgramFiles

$CompanyDir = Join-Path -Path $ProgramFiles -ChildPath 'rhubarb-geek-nz'
$ProductDir = Join-Path -Path $CompanyDir -ChildPath 'RunningMan'
$InstallDir = Join-Path -Path $ProductDir -ChildPath $ProcessArchitecture
$ExeName = 'RhubarbGeekNzRunningMan.exe'
$ExePath = Join-Path -Path $InstallDir -ChildPath $ExeName

$CLSID = '{A8D9E8E8-EC86-4630-A623-579C9CB505A7}'
$LIBID = '{C95C0F6B-3EE3-48AE-8F78-432669B69C48}'
$LIBVER = '1.0'
$IID = '{7798193D-D609-4D4C-935D-1F04B261F346}'
$PROGID = 'RhubarbGeekNz.RunningMan'
$APPID = '{3A6D07ED-E03D-474A-AE6A-BF42293D17F2}'

if ($UnregServer)
{
	$List = Get-Service -Name 'RunningMan' -ErrorAction ([System.Management.Automation.ActionPreference]::Ignore)

	if ($List)
	{
		Remove-Service -Name 'RunningMan'
	}

	$ExePath, $InstallDir, $ProductDir | ForEach-Object {
		$FilePath = $_
		if (Test-Path $FilePath)
		{
			Remove-Item -LiteralPath $FilePath
		}
	}

	if (Test-Path $CompanyDir)
	{
		$children = Get-ChildItem -LiteralPath $CompanyDir

		if (-not $children)
		{
			Remove-Item -LiteralPath $CompanyDir
		}
	}

	foreach ($RegistryPath in 
		"HKLM:\SOFTWARE\Classes\$PROGID\CLSID",
		"HKLM:\SOFTWARE\Classes\$PROGID",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\0\win32",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\0\win64",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\0",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\FLAGS",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER\HELPDIR",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID\$LIBVER",
		"HKLM:\SOFTWARE\Classes\TypeLib\$LIBID",
		"HKLM:\SOFTWARE\Classes\Interface\$IID\ProxyStubClsid32",
		"HKLM:\SOFTWARE\Classes\Interface\$IID\ProxyStubClsid",
		"HKLM:\SOFTWARE\Classes\Interface\$IID\TypeLib",
		"HKLM:\SOFTWARE\Classes\Interface\$IID",
		"HKLM:\SOFTWARE\Classes\AppID\$APPID",
		"HKLM:\SOFTWARE\Classes\AppID\$ExeName"
	)
	{
		if (Test-Path $RegistryPath)
		{
			Remove-Item -Path $RegistryPath
		}
	}
}
else
{
	if (Test-Path $ExePath)
	{
		Write-Warning "$ExePath is already installed"
	}
	else
	{
		$SourceDir = Join-Path -Path $PSScriptRoot -ChildPath $ProcessArchitecture
		$SourceFile = Join-Path -Path $SourceDir -ChildPath $ExeName

		if (-not (Test-Path $SourceFile))
		{
			Write-Error "$SourceFile does not exist"
		}
		else
		{
			$CompanyDir, $ProductDir, $InstallDir | ForEach-Object {
				$FilePath = $_
				if (-not (Test-Path $FilePath))
				{
					$Null = New-Item -Path $FilePath -ItemType 'Directory'
				}
			}

			Copy-Item $SourceFile $ExePath
		}

		$RegistryPath = "HKLM:\SOFTWARE\Classes\$PROGID\CLSID"

		if (Test-Path $RegistryPath)
		{
			$null = Set-Item -Path $RegistryPath -Value $CLSID
		}
		else
		{
			$null = New-Item -Path $RegistryPath -Value $CLSID -Force
		}

		$RegistryPath = "HKLM:\SOFTWARE\Classes\Interface\$IID\ProxyStubClsid32"

		if (Test-Path $RegistryPath)
		{
			$null = Set-Item -Path $RegistryPath -Value '{00020424-0000-0000-C000-000000000046}'
		}
		else
		{
			$null = New-Item -Path $RegistryPath -Value '{00020424-0000-0000-C000-000000000046}' -Force
		}

		$RegistryPath = "HKLM:\SOFTWARE\Classes\Interface\$IID\TypeLib"

		if (Test-Path $RegistryPath)
		{
			$null = Set-Item -Path $RegistryPath -Value $LIBID
		}
		else
		{
			$null = New-Item -Path $RegistryPath -Value $LIBID -Force
		}

		$null = New-ItemProperty -Path $RegistryPath -Name 'Version' -Value $LIBVER -PropertyType 'String'

		$RegistryPath = "HKLM:\SOFTWARE\Classes\AppID\$APPID"

		if (-not (Test-Path $RegistryPath))
		{
			$null = New-Item -Path $RegistryPath
		}

		$null = New-ItemProperty -Path $RegistryPath -Name 'LocalService' -Value 'RunningMan' -PropertyType 'String'

		$RegistryPath = "HKLM:\SOFTWARE\Classes\AppID\$ExeName"

		if (-not (Test-Path $RegistryPath))
		{
			$null = New-Item -Path $RegistryPath
		}

		$null = New-ItemProperty -Path $RegistryPath -Name 'AppID' -Value $APPID -PropertyType 'String'

		Add-Type -TypeDefinition @"
			using System;
			using System.ComponentModel;
			using System.Runtime.InteropServices;

			namespace RhubarbGeekNz.RunningMan
			{
				public class InterOp
				{
					[DllImport("oleaut32.dll", CharSet = CharSet.Unicode, PreserveSig = false)]
					private static extern void LoadTypeLibEx(string szFile, uint regkind, out IntPtr pptlib);

					public static void RegisterTypeLib(string path)
					{
						IntPtr punk;
						LoadTypeLibEx(path, 1, out punk);
						Marshal.Release(punk);
					}
				}
			}
"@

		[RhubarbGeekNz.RunningMan.InterOp]::RegisterTypeLib($ExePath)

		$serviceDefinition = @{
			Name = 'RunningMan'
			BinaryPathName = $ExePath
			DisplayName = "Running Man"
			StartupType = "Manual"
			Description = "Provides Hello World COM object as RhubarbGeekNz.RunningMan"
		}

		$null = New-Service @serviceDefinition
	}
}
