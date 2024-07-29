REM Copyright (c) 2024 Roger Brown.
REM Licensed under the MIT License.

Set helloWorld = GetObject(,"RhubarbGeekNz.RunningMan")

For i = 1 to 5
	WScript.Echo helloWorld.GetMessage(i)
Next
