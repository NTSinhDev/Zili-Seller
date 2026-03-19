@echo off
setlocal enabledelayedexpansion
REM Script để tự động generate commit message, commit và push
REM Usage: git_commit_push_auto.bat

echo Generating commit message from changes...
set COMMIT_TITLE=
set COMMIT_BODY=

REM Parse output từ script
for /f "tokens=1,* delims=:" %%a in ('dart run scripts/generate_commit_message.dart') do (
    if "%%a"=="TITLE" (
        set "COMMIT_TITLE=%%b"
    ) else if "%%a"=="BODY" (
        set "COMMIT_BODY=%%b"
    )
)

if %errorlevel% neq 0 (
    echo ❌ Không thể generate commit message!
    exit /b %errorlevel%
)

if "!COMMIT_TITLE!"=="" (
    echo ❌ Không thể tạo commit title!
    exit /b 1
)

echo.
echo Generated commit title: !COMMIT_TITLE!
if not "!COMMIT_BODY!"=="" (
    echo Generated commit body:
    echo !COMMIT_BODY!
)
echo.

echo Staging all changes...
call git add -A
if %errorlevel% neq 0 (
    echo ❌ git add failed!
    exit /b %errorlevel%
)

echo.
echo Committing with auto-generated message...
if "!COMMIT_BODY!"=="" (
    REM Chỉ có title
    call git commit -m "!COMMIT_TITLE!"
) else (
    REM Có cả title và body
    call git commit -m "!COMMIT_TITLE!" -m "!COMMIT_BODY!"
)
if %errorlevel% neq 0 (
    echo ❌ git commit failed!
    exit /b %errorlevel%
)

echo.
echo Pushing to remote...
call git push
if %errorlevel% neq 0 (
    echo ❌ git push failed!
    exit /b %errorlevel%
)

echo.
echo ✅ Commit và push thành công!
echo Title: !COMMIT_TITLE!

