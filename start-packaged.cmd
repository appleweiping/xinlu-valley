@echo off
setlocal
set "ROOT=%~dp0"
set "BACKEND_URL=http://127.0.0.1:8000/api/health"
set "GAME_EXE=%ROOT%dist\ai-town\AI Town.exe"

echo [AI Town] Starting packaged local play session...
echo.

if not exist "%GAME_EXE%" (
  echo [AI Town] Missing exported executable:
  echo   %GAME_EXE%
  echo.
  echo Run:
  echo   powershell -ExecutionPolicy Bypass -File tools\install-godot-templates.ps1
  echo   powershell -ExecutionPolicy Bypass -File tools\export-godot.ps1 -RunExport
  exit /b 1
)

powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $r = Invoke-WebRequest -UseBasicParsing -Uri '%BACKEND_URL%' -TimeoutSec 2; if ($r.StatusCode -ge 200 -and $r.StatusCode -lt 500) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
  echo [AI Town] Backend is not responding; starting project-local FastAPI bridge...
  start "AI Town Backend Packaged" cmd /c "cd /d %ROOT%backend && python -m uvicorn main:app --host 127.0.0.1 --port 8000"
  for /l %%i in (1,1,30) do (
    powershell -NoProfile -ExecutionPolicy Bypass -Command "try { $r = Invoke-WebRequest -UseBasicParsing -Uri '%BACKEND_URL%' -TimeoutSec 1; if ($r.StatusCode -ge 200 -and $r.StatusCode -lt 500) { exit 0 } else { exit 1 } } catch { exit 1 }" >nul 2>&1
    if not errorlevel 1 goto backend_ready
    timeout /t 1 /nobreak >nul
  )
  echo [AI Town] Backend did not become ready within 30 seconds.
  echo Leave any backend window open for logs, or run start-backend.cmd manually.
  exit /b 1
) else (
  echo [AI Town] Backend already responding at %BACKEND_URL%.
)

:backend_ready
echo [AI Town] Launching exported Godot game...
start "AI Town Packaged" "%GAME_EXE%"
echo.
echo ============================================
echo   AI Town packaged session started
echo   Game:    dist\ai-town\AI Town.exe
echo   Backend: http://127.0.0.1:8000
echo   API Docs: http://127.0.0.1:8000/docs
echo ============================================
echo.
echo This launcher does not stop or kill any running processes.
endlocal
