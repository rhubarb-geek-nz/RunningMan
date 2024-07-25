# rhubarb-geek-nz/RunningMan

Demonstration of a COM object in the running object table in a service.

[dispsvc.idl](dispsvc/dispsvc.idl) defines the dual-interface for a simple local server.

[dispsvc.c](dispsvc/dispsvc.c) implements the interface in the service.

[dispapp.cpp](dispapp/dispapp.cpp) finds the instance from the ROT and uses it to get a message to display.

[dispnet.cs](dispnet/dispnet.cs) use .NET to access the ROT and invoke Hello World.

[package.ps1](package.ps1) is used to automate the building of multiple architectures.

[dispps1.ps1](dispps1/dispps1.ps1) PowerShell finds object and invokes Hello World
