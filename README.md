# rhubarb-geek-nz/RunningMan

Demonstration of a COM object in the Running Object Table in a service.

The object is registered while the service is running. There is no class factory.

The service runs as the local system user. It uses `CoImpersonateClient` within the message handler.

The ProgID is registered so the CLSID can be looked up in the ROT.

The AppID is tied to the LocalService so that the object can be made available to any client.

The program name is needed to be registered as an AppID in order for the DCOM security to permit access to the object.

The TypeLib and proxy-stub are registered so that the dual-dispatch can be published.

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AppID\RhubarbGeekNzRunningMan.exe]
"AppID"="{3A6D07ED-E03D-474A-AE6A-BF42293D17F2}"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\AppID\{3A6D07ED-E03D-474A-AE6A-BF42293D17F2}]
"LocalService"="RunningMan"

[HKEY_LOCAL_MACHINE\SOFTWARE\Classes\RhubarbGeekNz.RunningMan\CLSID]
@="{A8D9E8E8-EC86-4630-A623-579C9CB505A7}"
```

[dispsvc.idl](dispsvc/dispsvc.idl) defines the dual-interface for a simple local server.

[dispsvc.c](dispsvc/dispsvc.c) implements the interface in the service.

[dispapp.cpp](dispapp/dispapp.cpp) finds the instance from the ROT and uses it to get a message to display.

[dispnet.cs](dispnet/dispnet.cs) use .NET to access the ROT and request a message.

[package.ps1](package.ps1) is used to automate the building of multiple architectures.

[dispps1.ps1](dispps1/dispps1.ps1) PowerShell script that finds the object and gets a message.
