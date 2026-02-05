#!/bin/bash

# Build script for Tencent Cloud Chat SDK - Web Platform
# This script builds the demo application for web deployment

set -e

echo "🚀 Building Tencent Cloud Chat SDK for Web..."
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Navigate to demo directory
cd "$(dirname "$0")/imdemo"

echo "📦 Installing web dependencies..."
cd web
if [ -f "package.json" ]; then
    npm install
else
    echo "⚠️  No package.json found in web directory"
fi
cd ..

echo ""
echo "🔧 Getting Flutter dependencies..."
flutter pub get

echo ""
echo "🌐 Building for web..."
flutter build web --release

echo ""
echo "✅ Build completed successfully!"
echo ""
echo "📁 Build output location: $(pwd)/build/web"
echo ""
echo "To test the web build locally, run:"
echo "  cd imdemo/build/web"
echo "  python3 -m http.server 8000"
echo "Then open http://localhost:8000 in your browser"
