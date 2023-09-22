@echo off
set "directory=%~1"
cd /d "%directory%"
start /B "" WeaselDeployer.exe /sync