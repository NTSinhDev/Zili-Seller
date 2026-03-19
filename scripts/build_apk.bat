@echo off
REM Build APK script for Windows
REM Usage: build_apk.bat [--debug]

dart tools/build_apk/build_apk.dart %*
