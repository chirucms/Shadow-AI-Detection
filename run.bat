@echo off
title Shadow AI Detector
cls
echo ========================================================
echo       SHADOW DETECTOR - Security ^& Compliance Platform
echo ========================================================
echo.

:: 1. Ensure MySQL Server 8.4 is running
echo [1/3] Checking MySQL Server on port 3306...
netstat -ano | findstr :3306 | findstr LISTENING >nul
if %errorlevel% neq 0 (
    echo Starting MySQL Server in background...
    start /b "" "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" --datadir="C:\ProgramData\MySQL\MySQL Server 8.4\data" --port=3306
    timeout /t 3 >nul
) else (
    echo MySQL Server is already active.
)

:: 2. Ensure Port 8000 is clean and start FastAPI Backend
echo [2/3] Checking Backend on port 8000...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8000 ^| findstr LISTENING 2^>nul') do (
    echo Freeing port 8000 (PID %%a)...
    taskkill /f /pid %%a >nul 2>&1
)
echo Starting FastAPI Backend...
start "Shadow Detector API (Port 8000)" cmd /k "cd /d "%~dp0" && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --app-dir backend --reload"

:: 3. Ensure Port 5173 and start React Frontend
echo [3/3] Starting Frontend Console on port 5173...
start "Shadow Detector UI (Port 5173)" cmd /k "cd /d "%~dp0frontend" && npm.cmd run dev"

timeout /t 3 >nul
echo.
echo ========================================================
echo All services running! Opening browser...
echo URL: http://localhost:5173
echo ========================================================
start http://localhost:5173/

echo.
echo You can keep this window open or close it (servers run in their own windows).
pause
