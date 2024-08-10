# Copyright (c) 2024 Roger Brown.
# Licensed under the MIT License.

param(
	$ProgID = 'RhubarbGeekNz.RunningMan',
	$Method = 'GetMessage',
	$Hint = @(1, 2, 3, 4, 5)
)

$ErrorActionPreference = [System.Management.Automation.ActionPreference]::Stop

Add-Type -TypeDefinition @"
	using System;
	using System.Runtime.InteropServices;
	using System.Runtime.InteropServices.ComTypes;

	namespace RhubarbGeekNz.RunningMan
	{
		public class InterOp
		{
			[DllImport("ole32.dll", PreserveSig = false)]
			private static extern void CoSetProxyBlanket(
				IntPtr pProxy,
				uint dwAuthnSvc,
				uint dwAuthzSvc,
				[MarshalAs(UnmanagedType.LPWStr)] string pServerPrincName,
				uint dwAuthnLevel,
				uint dwImpLevel,
				IntPtr pAuthInfo,
				uint dwCapabilities);

  			[DllImport("oleaut32.dll", PreserveSig = false)]
  			private static extern void GetActiveObject(ref Guid rclsid, IntPtr pvReserved, [MarshalAs(UnmanagedType.IUnknown)] out Object ppunk);

			public static void SetSecurity(object proxy)
			{
				IntPtr dispatch = Marshal.GetIDispatchForObject(proxy);
				try
				{
					CoSetProxyBlanket(dispatch, uint.MaxValue, 0, null, 4, 3, IntPtr.Zero, 0);
				}
				finally
				{
					Marshal.Release(dispatch);
				}
			}

			public static object GetActiveObject(string progId)
			{
				object active;
				Guid guid = Type.GetTypeFromProgID(progId).GUID;
				GetActiveObject(ref guid, IntPtr.Zero, out active);
				return active;
			}
		}
	}
"@

$helloWorld = [RhubarbGeekNz.RunningMan.InterOp]::GetActiveObject($ProgID)

[RhubarbGeekNz.RunningMan.InterOp]::SetSecurity($helloWorld)

foreach ($h in $hint)
{
	$result = $helloWorld.$Method($h)

	"$h $result"
}
