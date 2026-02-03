# Web Build Quick Reference

## Build Commands

### Quick Build (Recommended)
```bash
# Linux/macOS
./build_web.sh

# Windows
build_web.bat

# Using Make
make build-web
```

### Manual Build Steps
```bash
# 1. Install web dependencies
cd imdemo/web
npm install
cd ..

# 2. Get Flutter dependencies
flutter pub get

# 3. Build for web
flutter build web --release
```

## Test Locally

```bash
# Method 1: Python
cd imdemo/build/web
python3 -m http.server 8000

# Method 2: Node.js
npm install -g http-server
cd imdemo/build/web
http-server -p 8000

# Method 3: Flutter
cd imdemo
flutter run -d chrome
```

Then open: http://localhost:8000

## Build Output

Location: `imdemo/build/web/`

Contains:
- `index.html` - Main entry point
- `main.dart.js` - Compiled Dart code
- `flutter.js` - Flutter engine
- `assets/` - App resources
- `canvaskit/` - Rendering engine

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Flutter not found | Install Flutter and add to PATH |
| npm not found | Install Node.js from nodejs.org |
| Build errors | Run `flutter clean` then rebuild |
| Missing dependencies | Run `npm install` in imdemo/web |

## Documentation

- Full English Guide: [WEB_BUILD_GUIDE.md](WEB_BUILD_GUIDE.md)
- Hướng dẫn Tiếng Việt: [HUONG_DAN_BUILD_WEB.md](HUONG_DAN_BUILD_WEB.md)

## Support

- Telegram: https://t.me/+1doS9AUBmndhNGNl
- WhatsApp: https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A
- QQ: 788910197
