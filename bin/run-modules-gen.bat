@echo off
cd /d "%~dp0"
cd ..\integrity-modules\integrity-gen\target
if not exist integrity-modules-gen.jar (
    echo [ERR] integrity-modules-gen.jar not found. Run package first.
    pause & exit /b 1
)
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m
echo [OK] Starting integrity-modules-gen ...
java -Dfile.encoding=UTF-8 %JAVA_OPTS% -jar integrity-modules-gen.jar
pause