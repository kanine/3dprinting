@echo off
setlocal

powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0Strip-PrusaSlicerFooter.ps1" "%~1"

endlocal
