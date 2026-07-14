@echo off
setlocal enabledelayedexpansion

REM ============================================================
REM  Start Nacos / Redis / Sentinel
REM  Integrity-Supervision-Platform-Backend
REM ============================================================

REM ---- Service paths (edit as needed) ----
set "NACOS_HOME=D:\enviroment\nacos-server-3.2.2\nacos"
set "REDIS_HOME=D:\enviroment\Redis-x64-5.0.14.1"
set "SENTINEL_JAR=D:\enviroment\sentinel\sentinel-dashboard-1.8.10.jar"

REM ---- Ports / params ----
set NACOS_MODE=standalone
set SENTINEL_PORT=8070
set SENTINEL_CSP=localhost:8070

echo ============================================================
echo  Integrity base services starting
echo  Nacos   : %NACOS_HOME%
echo  Redis   : %REDIS_HOME%
echo  Sentinel: %SENTINEL_JAR%  (port %SENTINEL_PORT%)
echo ============================================================
echo.

REM ---- Validate paths ----
set NACOS_OK=0
set REDIS_OK=0
set SENTINEL_OK=0

if exist "%NACOS_HOME%\bin\startup.cmd" set NACOS_OK=1
if exist "%REDIS_HOME%\redis-server.exe" set REDIS_OK=1
if exist "%SENTINEL_JAR%" set SENTINEL_OK=1

if %NACOS_OK% equ 0 echo [WARN] Nacos startup.cmd not found: %NACOS_HOME%\bin\startup.cmd
if %REDIS_OK% equ 0 echo [WARN] redis-server.exe not found: %REDIS_HOME%\redis-server.exe
if %SENTINEL_OK% equ 0 echo [WARN] Sentinel JAR not found: %SENTINEL_JAR%

REM ---- Check Windows Terminal ----
where wt.exe >nul 2>&1
if errorlevel 1 goto :fallback

REM ---- Build wt.exe arguments ----
set WT_ARGS=
if %NACOS_OK% equ 1 set WT_ARGS=!WT_ARGS! new-tab --title Nacos cmd /c "cd /d %NACOS_HOME%\bin && startup.cmd -m %NACOS_MODE%" ;
if %REDIS_OK% equ 1 set WT_ARGS=!WT_ARGS! new-tab --title Redis cmd /c "cd /d %REDIS_HOME% && redis-server.exe" ;
if %SENTINEL_OK% equ 1 set WT_ARGS=!WT_ARGS! new-tab --title Sentinel cmd /c "java -Dserver.port=%SENTINEL_PORT% -Dcsp.sentinel.dashboard.server=%SENTINEL_CSP% -Dproject.name=sentinel-dashboard -jar %SENTINEL_JAR%" ;

if "!WT_ARGS!"=="" (
    echo [ERROR] No service binaries found. Nothing to start.
    goto :end
)

echo [OK] Opening services in a single Windows Terminal window...
wt.exe !WT_ARGS!

echo.
echo ============================================================
echo  Services opened in Windows Terminal tabs.
echo  Nacos   : http://localhost:8848/nacos   (nacos / nacos)
echo  Sentinel: http://localhost:%SENTINEL_PORT%   (sentinel / sentinel)
echo ============================================================
goto :end

:fallback
echo [WARN] Windows Terminal (wt.exe) not found, falling back to separate windows.
echo.
if %NACOS_OK% equ 1 (
    echo [OK] Starting Nacos (standalone) ...
    start "Nacos" /D "%NACOS_HOME%\bin" cmd /c "startup.cmd -m %NACOS_MODE%"
)
if %REDIS_OK% equ 1 (
    echo [OK] Starting Redis ...
    start "Redis" /D "%REDIS_HOME%" cmd /c "redis-server.exe"
)
if %SENTINEL_OK% equ 1 (
    echo [OK] Starting Sentinel Dashboard (port %SENTINEL_PORT%) ...
    start "Sentinel" cmd /c "java -Dserver.port=%SENTINEL_PORT% -Dcsp.sentinel.dashboard.server=%SENTINEL_CSP% -Dproject.name=sentinel-dashboard -jar "%SENTINEL_JAR%""
)
echo.
echo ============================================================
echo  Services launched in separate windows.
echo  Nacos   : http://localhost:8848/nacos   (nacos / nacos)
echo  Sentinel: http://localhost:%SENTINEL_PORT%   (sentinel / sentinel)
echo ============================================================

:end
echo.
pause
endlocal
