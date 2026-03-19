#!/bin/bash
# Script để chạy flutter pub get và tự động generate assets.dart

echo "Running flutter pub get..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ flutter pub get failed!"
    exit 1
fi

echo ""
echo "Generating assets.dart..."
dart run tools/generate_assets/generate_assets.dart

if [ $? -ne 0 ]; then
    echo "❌ Generate assets failed!"
    exit 1
fi

echo ""
echo "✅ Done!"

