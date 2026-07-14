@echo off
cd /d "%~dp0"
cd ..\integrity-auth\target
if not exist integrity-auth.jar (
    echo [ERR] integrity-auth.jar not found. Run package first.
    pause & exit /b 1
)
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m
echo [OK] Starting integrity-auth (port 9200) ...
java -Dfile.encoding=UTF-8 %JAVA_OPTS% -jar integrity-auth.jar
pause