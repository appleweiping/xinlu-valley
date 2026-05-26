@echo off
taskkill /FI "WINDOWTITLE eq AI Town Backend*" /F >nul 2>&1
taskkill /FI "WINDOWTITLE eq AI Town Frontend*" /F >nul 2>&1
echo [Pixel AI Town] All services stopped.
