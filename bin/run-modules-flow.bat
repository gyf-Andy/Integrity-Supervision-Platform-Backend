@echo off
cd /d "%~dp0"
cd ..\integrity-modules\integrity-flow\target
if not exist integrity-flow.jar (
    echo [ERR] integrity-flow.jar not found. Run package first.
    pause & exit /b 1
)
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m
echo [OK] Starting integrity-flow ...
java -Dfile.encoding=UTF-8 %JAVA_OPTS% -jar integrity-flow.jar
pause