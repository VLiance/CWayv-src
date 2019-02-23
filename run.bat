@echo off
call  msbuild bin/Main-Debug.csproj
cd bin/bin

	cd Debug
  :: run debug
  :  Main-Debug.exe
  copy Main-Debug.exe ..\..\..\..\..\..\Cwc\Utils\CWayv\CWayv.exe
  copy  Main-Debug.pdb ..\..\..\..\..\..\Cwc\Utils\CWayv\Main-Debug.pdb
