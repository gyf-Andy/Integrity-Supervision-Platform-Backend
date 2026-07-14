@echo off
cd /d "%~dp0"
cd ..\integrity-modules\integrity-file\target
if not exist integrity-modules-file.jar (
    echo [ERR] integrity-modules-file.jar not found. Run package first.
    pause & exit /b 1
)
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m
echo [OK] Starting integrity-modules-file ...
java -Dfile.encoding=UTF-8 %JAVA_OPTS% -jar integrity-modules-file.jar
pause