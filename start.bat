@echo off
echo ===================================================
echo     Starting Shadow AI Detector Platform...
echo ===================================================
echo.

:: Start Backend in a new terminal window
echo [1/2] Starting Backend (FastAPI)...
start "Shadow Detector - Backend" cmd /k "cd backend && python -m uvicorn app.main:app --reload"

:: Start Frontend in a new terminal window
echo [2/2] Starting Frontend (React/Vite)...
start "Shadow Detector - Frontend" cmd /k "cd frontend && npm.cmd run dev"

echo.
echo ===================================================
echo   Project is starting! 
echo   - Backend will run on http://127.0.0.1:8000
echo   - Frontend will run on http://localhost:5173
echo ===================================================
echo.
pause
