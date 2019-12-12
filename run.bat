@echo off
call  msbuild bin/Main-Debug.csproj
cd bin/bin

	cd Debug
  :: run debug
  :  Main-Debug.exe
  ::  copy Main-Debug.exe ..\..\..\..\_Cwc\Utils\CWayv\CWayv.exe
  ::  copy  Main-Debug.pdb ..\..\..\..\_Cwc\Utils\CWayv\Main-Debug.pdb
  copy Main-Debug.exe ..\..\..\..\_Cwc\Lib\VLiance\GZE\GZE-999\bin\CWayv.exe
  copy  Main-Debug.pdb ..\..\..\..\_Cwc\Lib\VLiance\GZE\GZE-999\bin\Main-Debug.pdb
  