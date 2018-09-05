@echo off
cd bin/bin
if "%1"=="debug" (
  :: run debug
  :  Main-Debug.exe
  copy Main-Debug.exe ..\..\..\..\..\Cwc\Utils\CWayv\CWayv.exe
  copy  Main-Debug.pdb ..\..\..\..\..\Cwc\Utils\CWayv\Main-Debug.pdb
) else (
  :: run release
  :  Main.exe 
  copy Main.exe ..\..\..\..\..\Cwc\Utils\CWayv\CWayv.exe
)
pause
