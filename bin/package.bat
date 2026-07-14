@echo off
cd /d "%~dp0"
cd ..
echo [INFO] Running mvn clean package -DskipTests ...
call mvn clean package -Dmaven.test.skip=true -q
echo [DONE] Package completed.
pause