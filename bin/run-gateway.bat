@echo off
cd /d "%~dp0"
cd ..\integrity-gateway\target
if not exist integrity-gateway.jar (
    echo [ERR] integrity-gateway.jar not found. Run package first.
    pause & exit /b 1
)
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m
echo [OK] Starting integrity-gateway (port 8080) ...
java -Dfile.encoding=UTF-8 %JAVA_OPTS% -jar integrity-gateway.jar
pause