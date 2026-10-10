# PowerShell Native Service Starter for Shadow AI Detector
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host "      SHADOW DETECTOR - Security & Compliance Platform" -ForegroundColor Cyan
Write-Host "========================================================" -ForegroundColor Cyan
Write-Host ""

$root = $PSScriptRoot

# 1. MySQL Server
Write-Host "[1/3] Checking MySQL Server on port 3306..." -ForegroundColor Yellow
$mysqlConn = Get-NetTCPConnection -LocalPort 3306 -ErrorAction SilentlyContinue
if (-not $mysqlConn) {
    Write-Host "Starting MySQL Server in background..." -ForegroundColor Green
    Start-Process -FilePath "C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqld.exe" `
        -ArgumentList '--datadir="C:\ProgramData\MySQL\MySQL Server 8.4\data" --port=3306' `
        -WindowStyle Hidden
    Start-Sleep -Seconds 3
} else {
    Write-Host "MySQL Server is already running on port 3306." -ForegroundColor Green
}

# 2. FastAPI Backend
Write-Host "[2/3] Checking FastAPI Backend on port 8000..." -ForegroundColor Yellow
$backConn = Get-NetTCPConnection -LocalPort 8000 -ErrorAction SilentlyContinue
if ($backConn) {
    Write-Host "Port 8000 is occupied. Clearing stale process..." -ForegroundColor Yellow
    Stop-Process -Id $backConn.OwningProcess -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 1
}
Write-Host "Starting FastAPI Backend..." -ForegroundColor Green
Start-Process powershell -ArgumentList "-NoExit -Command Set-Location '$root'; python -m uvicorn app.main:app --host 127.0.0.1 --port 8000 --app-dir backend --reload"

# 3. React Frontend
Write-Host "[3/3] Starting Frontend Console on port 5173..." -ForegroundColor Yellow
Start-Process powershell -ArgumentList "-NoExit -Command Set-Location '$root\frontend'; npm.cmd run dev"

Start-Sleep -Seconds 3
Write-Host ""
Write-Host "All services launched successfully!" -ForegroundColor Green
Write-Host "Opening web console in browser..." -ForegroundColor Cyan
Start-Process "http://localhost:5173/"
