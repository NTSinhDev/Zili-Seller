#!/bin/bash
# Build APK script for Linux/Mac
# Usage: ./build_apk.sh [--debug]

dart tools/build_apk/build_apk.dart "$@"
