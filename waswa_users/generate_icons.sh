#!/bin/bash

echo "🚀 Flutter Launcher Icons Generator"
echo "=================================="
echo ""

# Check available image files
echo "📁 Available image files:"
if [ -f "assets/images/img.jpeg" ]; then
    echo "   ✓ assets/images/img.jpeg (JPEG - 127KB)"
fi
if [ -f "assets/images/file.svg" ]; then
    echo "   ✓ assets/images/file.svg (SVG - 989KB)"
fi
echo ""

# Check if flutter_launcher_icons is installed
if ! flutter pub deps | grep -q "flutter_launcher_icons"; then
    echo "📦 Installing flutter_launcher_icons..."
    flutter pub get
fi

echo "🔄 Generating launcher icons..."
echo "   - Using: assets/images/img.jpeg (JPEG format)"
echo "   - Platforms: Android, iOS, Web, Windows, macOS"
echo ""

# Generate icons for all platforms
dart run flutter_launcher_icons:main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Launcher icons generated successfully!"
    echo ""
    echo "📱 Icons have been generated for:"
    echo "   - Android: android/app/src/main/res/"
    echo "   - iOS: ios/Runner/Assets.xcassets/AppIcon.appiconset/"
    echo "   - Web: web/icons/"
    echo "   - Windows: windows/runner/resources/"
    echo "   - macOS: macos/Runner/Assets.xcassets/AppIcon.appiconset/"
    echo ""
    echo "💡 Tips:"
    echo "   - JPEG format provides better cross-platform compatibility"
    echo "   - SVG format is scalable but has limited platform support"
    echo "   - To use SVG instead, edit pubspec.yaml and uncomment svg_path"
    echo "   - To regenerate icons, run this script again after updating your image file"
    echo ""
    echo "🎯 Next steps:"
    echo "   1. Clean and rebuild your app: flutter clean && flutter pub get"
    echo "   2. Test on your target platforms"
    echo "   3. Icons will appear after app reinstall"
else
    echo ""
    echo "❌ Error generating launcher icons!"
    echo "   Check the error messages above and ensure your image file is valid."
fi
