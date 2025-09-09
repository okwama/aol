#!/bin/bash

echo "🚀 Setting up JLW Foundation Flutter App"
echo "========================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first:"
    echo "   https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"

# Check Flutter version
FLUTTER_VERSION=$(flutter --version | grep -o "Flutter [0-9]\+\.[0-9]\+\.[0-9]\+" | head -1)
echo "📱 $FLUTTER_VERSION detected"

# Get dependencies
echo "📦 Installing dependencies..."
flutter pub get

if [ $? -eq 0 ]; then
    echo "✅ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

# Check for connected devices
echo "🔍 Checking for connected devices..."
flutter devices

echo ""
echo "🎉 Setup complete!"
echo ""
echo "To run the app:"
echo "   flutter run"
echo ""
echo "Demo credentials:"
echo "   Email: user1@kitale.com"
echo "   Password: 123"
echo "   ID: Kitale123456"
echo ""
echo "For more information, see README.md" 