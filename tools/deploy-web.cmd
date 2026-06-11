@echo off
rem Deploy the prebuilt web client to Vercel project "newroad-valley".
rem vite build wipes web\dist (including .vercel), so we must re-link
rem before every deploy ??forgetting this creates a stray "dist" project.
setlocal
cd /d "%~dp0..\web"

call npm run build || exit /b 1

cd dist
call npx --yes vercel link --yes --project newroad-valley || exit /b 1
call npx --yes vercel deploy --prod --yes
endlocal
