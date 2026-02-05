# Web Build Guide for Tencent Cloud Chat SDK

This guide explains how to build the Tencent Cloud Chat SDK for web deployment.

## Prerequisites

Before building for web, ensure you have:

1. **Flutter SDK** - Version 3.0.0 or later
   - Install from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter --version`

2. **Node.js and npm** - For web dependencies
   - Install from: https://nodejs.org/
   - Verify installation: `node --version` and `npm --version`

3. **Web browser** - Chrome, Firefox, Safari, or Edge for testing

## Quick Start

### Using Build Scripts

#### On Linux/macOS:
```bash
./build_web.sh
```

#### On Windows:
```cmd
build_web.bat
```

### Manual Build Process

If you prefer to build manually, follow these steps:

#### 1. Install Web Dependencies

Navigate to the demo web folder and install npm packages:

```bash
cd imdemo/web
npm install
cd ..
```

This installs required packages:
- `@tencentcloud/chat` - Tencent Cloud Chat JavaScript SDK
- `tim-upload-plugin` - File upload plugin for TIM

#### 2. Get Flutter Dependencies

```bash
flutter pub get
```

#### 3. Build for Web

```bash
flutter build web --release
```

For development builds with debugging enabled:
```bash
flutter build web --profile
```

## Testing the Web Build

### Option 1: Using Python HTTP Server

```bash
cd imdemo/build/web
python3 -m http.server 8000
```

Then open http://localhost:8000 in your browser.

### Option 2: Using Node.js http-server

```bash
npm install -g http-server
cd imdemo/build/web
http-server -p 8000
```

Then open http://localhost:8000 in your browser.

### Option 3: Using Flutter Run

For development and hot reload:

```bash
cd imdemo
flutter run -d chrome
```

## Build Output

After building, the web application files will be in:
```
imdemo/build/web/
```

This directory contains:
- `index.html` - Main HTML file
- `main.dart.js` - Compiled Dart code
- `flutter.js` - Flutter web engine
- `assets/` - Application assets
- `canvaskit/` - CanvasKit rendering engine

## Deployment

### Deploying to a Web Server

1. Copy the contents of `imdemo/build/web/` to your web server
2. Configure your web server to serve the files
3. Ensure CORS is properly configured if needed

### Deploying to GitHub Pages

```bash
cd imdemo
flutter build web --base-href "/your-repo-name/"
# Copy build/web contents to gh-pages branch
```

### Deploying to Firebase Hosting

```bash
cd imdemo
flutter build web
firebase init hosting
firebase deploy
```

## Web-Specific Configuration

### Browser Support

The SDK supports:
- Chrome (recommended)
- Firefox
- Safari
- Edge

### Required JavaScript Dependencies

The web version requires the following JavaScript libraries (already configured in `imdemo/web/index.html`):

```html
<script src="./node_modules/tim-upload-plugin/index.js"></script>
<script src="./node_modules/@tencentcloud/chat/index.js"></script>
```

### CORS Configuration

If you encounter CORS errors:
1. Ensure your backend API has proper CORS headers
2. Configure your web server to allow cross-origin requests
3. Check Tencent Cloud Chat SDK CORS settings in console

## Troubleshooting

### "Flutter not found" Error
- Ensure Flutter is installed and added to your PATH
- Run `flutter doctor` to check your setup

### "npm not found" Error
- Install Node.js from https://nodejs.org/
- Restart your terminal after installation

### Build Errors
- Run `flutter clean` and try again
- Check `flutter doctor` for any issues
- Ensure all dependencies are up to date with `flutter pub upgrade`

### Web Dependencies Not Found
- Make sure you've run `npm install` in the `imdemo/web` directory
- Check that `node_modules` folder exists in `imdemo/web`

### Browser Compatibility Issues
- Use Chrome for best compatibility during development
- Test in multiple browsers before production deployment
- Enable browser console to see detailed error messages

## Advanced Configuration

### Custom Build Options

Build with custom renderer:
```bash
flutter build web --web-renderer canvaskit  # Better performance
flutter build web --web-renderer html       # Better compatibility
```

Build with custom base URL:
```bash
flutter build web --base-href "/my-app/"
```

Build with source maps for debugging:
```bash
flutter build web --source-maps
```

### Environment Variables

You can pass environment variables during build:
```bash
flutter build web --dart-define=API_KEY=your_key
```

## Additional Resources

- [Flutter Web Documentation](https://flutter.dev/web)
- [Tencent Cloud Chat SDK Documentation](https://cloud.tencent.com/document/product/269)
- [Flutter Web Deployment Guide](https://flutter.dev/docs/deployment/web)

## Support

For issues or questions:
- Telegram: https://t.me/+1doS9AUBmndhNGNl
- WhatsApp: https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A
- QQ Group: 788910197
