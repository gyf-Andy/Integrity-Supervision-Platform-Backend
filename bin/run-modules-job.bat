@echo off
cd /d "%~dp0"
cd ..\integrity-modules\integrity-job\target
if not exist integrity-modules-job.jar (
    echo [ERR] integrity-modules-job.jar not found. Run package first.
    pause & exit /b 1
)
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m
echo [OK] Starting integrity-modules-job ...
java -Dfile.encoding=UTF-8 %JAVA_OPTS% -jar integrity-modules-job.jar
pause