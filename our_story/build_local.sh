#!/bin/bash
# Local Build Script for our_story App
# Run this script on your local machine with internet access

echo "=========================================="
echo "Our Story App - Local Build Script"
echo "=========================================="

cd "$(dirname "$0")"

echo ""
echo "[1/5] Checking Flutter installation..."
flutter --version

echo ""
echo "[2/5] Getting dependencies..."
flutter pub get

echo ""
echo "[3/5] Running static analysis..."
flutter analyze

echo ""
echo "[4/5] Building debug APK..."
flutter build apk --debug

echo ""
echo "[5/5] Checking APK output..."
if [ -f "build/app/outputs/flutter-apk/app-debug.apk" ]; then
    echo "✅ APK built successfully!"
    ls -la build/app/outputs/flutter-apk/
else
    echo "❌ APK build failed. Check the output above."
fi

echo ""
echo "=========================================="
echo "Build process completed!"
echo "=========================================="
