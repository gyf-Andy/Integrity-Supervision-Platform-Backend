@echo off
cd /d "%~dp0"
cd ..
echo [INFO] Running mvn clean ...
call mvn clean
pause