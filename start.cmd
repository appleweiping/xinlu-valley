@echo off
echo [Pixel AI Town] Starting...
echo.

start "AI Town Backend" cmd /c "cd /d D:\ai-town\backend && python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload"
timeout /t 3 /nobreak >nul

start "AI Town Frontend" cmd /c "cd /d D:\ai-town\frontend && npm run dev"

echo.
echo ============================================
echo   Pixel AI Town is running!
echo   Frontend: http://localhost:5173
echo   Backend:  http://localhost:8000
echo   API Docs: http://localhost:8000/docs
echo ============================================
echo.
echo Press any key to stop all services...
pause >nul

taskkill /FI "WINDOWTITLE eq AI Town Backend*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq AI Town Frontend*" /F >nul 2>&1
echo [Pixel AI Town] Stopped.
