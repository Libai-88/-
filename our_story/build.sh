#!/bin/bash

# Our Story - Build Script
# This script will build the Flutter app after downloading dependencies

set -e

echo "============================================"
echo "  Our Story - Flutter App Build Script"
echo "============================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found!"
    echo ""
    echo "Please install Flutter SDK first:"
    echo "  1. Download from: https://flutter.dev/docs/get-started/install"
    echo "  2. Extract to a location (e.g., ~/flutter)"
    echo "  3. Add to PATH: export PATH=\"\$PATH:\$HOME/flutter/bin\""
    echo "  4. Run: flutter doctor"
    echo ""
    exit 1
fi

echo "✓ Flutter found: $(flutter --version | head -1)"
echo ""

# Navigate to project directory
cd "$(dirname "$0")"

# Get dependencies
echo "📦 Getting Flutter dependencies..."
flutter pub get

# Run analyze
echo ""
echo "🔍 Running Flutter analyze..."
flutter analyze

# Build APK
echo ""
echo "🔨 Building debug APK..."
flutter build apk --debug

echo ""
echo "============================================"
echo "  ✅ Build Complete!"
echo "============================================"
echo ""
echo "APK location: build/app/outputs/flutter-apk/app-debug.apk"
echo ""
