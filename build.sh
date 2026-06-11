#!/bin/bash
# Builds a universal SoundKnobs.app + release zip. Run: ./build.sh
set -euo pipefail
cd "$(dirname "$0")"

echo "==> Compiling universal binary (release)…"
swift build -c release --arch arm64 --arch x86_64

APP="build/SoundKnobs.app"
BIN=".build/apple/Products/Release/SoundKnobs"

echo "==> Assembling ${APP}…"
rm -rf build
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources"
cp "$BIN" "$APP/Contents/MacOS/SoundKnobs"
cp Resources/Info.plist "$APP/Contents/Info.plist"
cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"

echo "==> Signing (ad-hoc)…"
codesign --force --deep --sign - "$APP"

echo "==> Zipping for release…"
ditto -c -k --keepParent "$APP" "build/SoundKnobs.zip"

echo ""
echo "Done:"
echo "  App:         $APP"
echo "  Release zip: build/SoundKnobs.zip"
echo "Launch with:   open $APP"