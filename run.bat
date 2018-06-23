@echo off
cd bin/bin
if "%1"=="debug" (
  :: run debug
  :  Main-Debug.exe
  copy Main-Debug.exe ..\..\..\..\..\Cwc\Tools\CWayv\CWayv.exe
  copy  Main-Debug.pdb ..\..\..\..\..\Cwc\Tools\CWayv\Main-Debug.pdb
) else (
  :: run release
  :  Main.exe 
  copy Main.exe ..\..\..\..\..\Cwc\Tools\CWayv\CWayv.exe
)
pause
