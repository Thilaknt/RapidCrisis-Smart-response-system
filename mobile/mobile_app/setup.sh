#!/bin/bash
# Setup script for Rapid Response App

echo "🚨 Rapid Response Emergency App - Setup"
echo "======================================="
echo ""

# Check Flutter
echo "✓ Checking Flutter..."
flutter --version

# Check Dart  
echo "✓ Checking Dart..."
dart --version

echo ""
echo "📦 Installing dependencies..."
flutter pub get

echo ""
echo "🔧 Building runner (for Hive/Freezed if needed)..."
flutter pub run build_runner build --delete-conflicting-outputs 2>/dev/null || true

echo ""
echo "✅ Setup complete!"
echo ""
echo "Ready to run:"
echo "  flutter run              # Run on connected device/emulator"
echo "  flutter run -v           # Run with verbose logging"
echo ""
echo "Documentation:"
echo "  - QUICK_START.md         # Fast setup guide"
echo "  - IMPLEMENTATION_GUIDE.md # Full architecture details"
echo ""
