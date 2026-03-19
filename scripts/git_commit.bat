@echo off
setlocal enabledelayedexpansion
REM Script để stage và commit changes
REM Usage: git_commit.bat "commit message"

if "%~1"=="" (
    echo ❌ Vui lòng nhập commit message!
    echo Usage: git_commit.bat "commit message"
    exit /b 1
)

REM Lấy toàn bộ tham số làm commit message
set "COMMIT_MSG=%~1"
shift
:loop
if not "%~1"=="" (
    set "COMMIT_MSG=!COMMIT_MSG! %~1"
    shift
    goto :loop
)

echo Staging all changes...
call git add -A
if %errorlevel% neq 0 (
    echo ❌ git add failed!
    exit /b %errorlevel%
)

echo.
echo Committing with message: %COMMIT_MSG%
call git commit -m "%COMMIT_MSG%"
if %errorlevel% neq 0 (
    echo ❌ git commit failed!
    exit /b %errorlevel%
)

echo.
echo ✅ Commit thành công!

