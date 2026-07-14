@echo off
cd /d "%~dp0"
cd ..\integrity-modules\integrity-system\target
if not exist integrity-modules-system.jar (
    echo [ERR] integrity-modules-system.jar not found. Run package first.
    pause & exit /b 1
)
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m
echo [OK] Starting integrity-modules-system (port 9201) ...
java -Dfile.encoding=UTF-8 %JAVA_OPTS% -jar integrity-modules-system.jar
pause