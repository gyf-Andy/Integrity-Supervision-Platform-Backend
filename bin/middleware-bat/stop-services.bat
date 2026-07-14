@echo off
setlocal enabledelayedexpansion

echo ============================================================
echo  Stopping Nacos / Redis / Sentinel
echo ============================================================

REM ---- Nacos (java process with nacos in command line) ----
echo [INFO] Stopping Nacos ...
taskkill /F /FI "WINDOWTITLE eq Nacos*" /T >nul 2>&1
for /f "tokens=2 delims==" %%i in ('wmic process where "CommandLine like '%%nacos%%' and Name='java.exe'" get ProcessId /value ^| find "ProcessId"') do (
    if not "%%i"=="" taskkill /F /PID %%i >nul 2>&1
)

REM ---- Redis ----
echo [INFO] Stopping Redis ...
taskkill /F /IM redis-server.exe /T >nul 2>&1

REM ---- Sentinel Dashboard ----
echo [INFO] Stopping Sentinel ...
for /f "tokens=2 delims==" %%i in ('wmic process where "CommandLine like '%%sentinel-dashboard%%' and Name='java.exe'" get ProcessId /value ^| find "ProcessId"') do (
    if not "%%i"=="" taskkill /F /PID %%i >nul 2>&1
)

echo.
echo [DONE] Stop attempt finished.
echo ============================================================
pause
endlocal
