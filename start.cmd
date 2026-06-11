@echo off
set "ROOT=%~dp0"
echo [Agent Town] Starting backend + Godot client...
echo.

start "AI Town Backend" cmd /c "cd /d %ROOT%backend && python -m uvicorn main:app --host 127.0.0.1 --port 8000"
timeout /t 3 /nobreak >nul

start "AI Town Godot" "%ROOT%tools\godot\Godot_v4.6.3-stable_win64.exe" --path "%ROOT%godot"

echo.
echo ============================================
echo   Agent Town Godot is running!
echo   Godot:   tools\godot\Godot_v4.6.3-stable_win64.exe
echo   Backend:  http://localhost:8000
echo   API Docs: http://localhost:8000/docs
echo ============================================
echo.
echo Press any key to stop only this project's backend/Godot windows...
pause >nul

taskkill /FI "WINDOWTITLE eq AI Town Backend*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq AI Town Godot*" /F >nul 2>&1
echo [Agent Town] Stopped.
