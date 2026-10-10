@echo off
title Shadow AI Detector - Platform Launcher
echo ========================================================
echo       SHADOW DETECTOR - Security ^& Compliance Platform
echo ========================================================
echo.

:: 1. Check/Start MySQL Server
echo [1/3] Checking MySQL Server 8.4 on port 3306...
netstat -ano | findstr :3306 >nul
if %errorlevel% neq 0 (
    echo Starting MySQL Server in background...
    start /b "" "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" --datadir="C:\ProgramData\MySQL\MySQL Server 8.4\data" --port=3306
    timeout /t 3 >nul
) else (
    echo MySQL Server is already running on port 3306.
)

:: 2. Free and Start FastAPI Backend
echo [2/3] Checking port 8000...
for /f "tokens=5" %%a in ('netstat -aon ^| findstr :8000 ^| findstr LISTENING 2^>nul') do (
    echo Terminating stale process on port 8000 (PID %%a)...
    taskkill /f /pid %%a >nul 2>&1
)
echo Starting FastAPI Backend on http://127.0.0.1:8000...
start "Shadow Detector API (Port 8000)" cmd /k "cd /d "%~dp0" && python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --app-dir backend --reload"

:: 3. Start React + Vite Frontend
echo [3/3] Starting Frontend Console on http://localhost:5173...
start "Shadow Detector UI (Port 5173)" cmd /k "cd /d "%~dp0frontend" && npm.cmd run dev"

timeout /t 2 >nul
echo.
echo All services launched! Opening web console...
start http://localhost:5173/
echo.
echo Press any key to exit this launcher window (services keep running).
pause >nul
