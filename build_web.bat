@echo off
REM Build script for Tencent Cloud Chat SDK - Web Platform
REM This script builds the demo application for web deployment

echo.
echo Building Tencent Cloud Chat SDK for Web...
echo.

REM Check if Flutter is installed
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo Flutter is not installed. Please install Flutter first.
    echo Visit: https://flutter.dev/docs/get-started/install
    exit /b 1
)

REM Navigate to demo directory
cd /d "%~dp0imdemo"

echo Installing web dependencies...
cd web
if exist package.json (
    call npm install
) else (
    echo No package.json found in web directory
)
cd ..

echo.
echo Getting Flutter dependencies...
call flutter pub get

echo.
echo Building for web...
call flutter build web --release

echo.
echo Build completed successfully!
echo.
echo Build output location: %cd%\build\web
echo.
echo To test the web build locally, run:
echo   cd imdemo\build\web
echo   python -m http.server 8000
echo Then open http://localhost:8000 in your browser
