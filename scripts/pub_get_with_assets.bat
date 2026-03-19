@echo off
REM Script để chạy flutter pub get và tự động generate assets.dart
echo Running flutter pub get...
call flutter pub get
if %errorlevel% neq 0 (
    echo ❌ flutter pub get failed!
    exit /b %errorlevel%
)

echo.
echo Generating assets.dart...
call dart run tools/generate_assets/generate_assets.dart
if %errorlevel% neq 0 (
    echo ❌ Generate assets failed!
    exit /b %errorlevel%
)

echo.
echo ✅ Done!

