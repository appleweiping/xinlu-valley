@echo off
set "ROOT=%~dp0"
start "AI Town Backend" cmd /c "cd /d %ROOT%backend && python -m uvicorn main:app --host 127.0.0.1 --port 8000"
