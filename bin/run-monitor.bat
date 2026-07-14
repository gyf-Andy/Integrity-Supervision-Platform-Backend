@echo off
cd /d "%~dp0"
cd ..\integrity-visual\integrity-monitor\target
if not exist integrity-visual-monitor.jar (
    echo [ERR] integrity-visual-monitor.jar not found. Run package first.
    pause & exit /b 1
)
set JAVA_OPTS=-Xms512m -Xmx1024m -XX:MetaspaceSize=128m -XX:MaxMetaspaceSize=512m
echo [OK] Starting integrity-visual-monitor ...
java -Dfile.encoding=UTF-8 %JAVA_OPTS% -jar integrity-visual-monitor.jar
pause