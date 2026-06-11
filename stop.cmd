@echo off
taskkill /FI "WINDOWTITLE eq AI Town Backend*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq AI Town Godot*" /F >nul 2>&1
echo [Agent Town] Project backend/Godot windows stopped.
