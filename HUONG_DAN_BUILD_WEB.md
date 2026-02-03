# Hướng dẫn Build Web cho Tencent Cloud Chat SDK

Hướng dẫn này giải thích cách build Tencent Cloud Chat SDK cho web.

## Yêu cầu

Trước khi build cho web, đảm bảo bạn đã cài đặt:

1. **Flutter SDK** - Phiên bản 3.0.0 trở lên
   - Cài đặt từ: https://flutter.dev/docs/get-started/install
   - Kiểm tra cài đặt: `flutter --version`

2. **Node.js và npm** - Cho các dependencies web
   - Cài đặt từ: https://nodejs.org/
   - Kiểm tra cài đặt: `node --version` và `npm --version`

3. **Trình duyệt web** - Chrome, Firefox, Safari, hoặc Edge để test

## Bắt đầu nhanh

### Sử dụng Script Build

#### Trên Linux/macOS:
```bash
./build_web.sh
```

#### Trên Windows:
```cmd
build_web.bat
```

### Quy trình Build thủ công

Nếu bạn muốn build thủ công, làm theo các bước sau:

#### 1. Cài đặt Web Dependencies

Di chuyển đến thư mục web của demo và cài đặt các package npm:

```bash
cd imdemo/web
npm install
cd ..
```

Lệnh này sẽ cài đặt các package cần thiết:
- `@tencentcloud/chat` - Tencent Cloud Chat JavaScript SDK
- `tim-upload-plugin` - Plugin upload file cho TIM

#### 2. Lấy Flutter Dependencies

```bash
flutter pub get
```

#### 3. Build cho Web

```bash
flutter build web --release
```

Để build development với debugging:
```bash
flutter build web --profile
```

## Test Web Build

### Cách 1: Sử dụng Python HTTP Server

```bash
cd imdemo/build/web
python3 -m http.server 8000
```

Sau đó mở http://localhost:8000 trong trình duyệt.

### Cách 2: Sử dụng Node.js http-server

```bash
npm install -g http-server
cd imdemo/build/web
http-server -p 8000
```

Sau đó mở http://localhost:8000 trong trình duyệt.

### Cách 3: Sử dụng Flutter Run

Để phát triển với hot reload:

```bash
cd imdemo
flutter run -d chrome
```

## Kết quả Build

Sau khi build, các file ứng dụng web sẽ nằm trong:
```
imdemo/build/web/
```

Thư mục này chứa:
- `index.html` - File HTML chính
- `main.dart.js` - Code Dart đã được compile
- `flutter.js` - Flutter web engine
- `assets/` - Assets của ứng dụng
- `canvaskit/` - CanvasKit rendering engine

## Deploy

### Deploy lên Web Server

1. Copy nội dung của `imdemo/build/web/` lên web server của bạn
2. Cấu hình web server để serve các file
3. Đảm bảo CORS được cấu hình đúng nếu cần

### Deploy lên GitHub Pages

```bash
cd imdemo
flutter build web --base-href "/tên-repo-của-bạn/"
# Copy nội dung build/web sang nhánh gh-pages
```

### Deploy lên Firebase Hosting

```bash
cd imdemo
flutter build web
firebase init hosting
firebase deploy
```

## Cấu hình Web

### Hỗ trợ Trình duyệt

SDK hỗ trợ:
- Chrome (khuyến nghị)
- Firefox
- Safari
- Edge

### JavaScript Dependencies bắt buộc

Phiên bản web yêu cầu các thư viện JavaScript sau (đã được cấu hình trong `imdemo/web/index.html`):

```html
<script src="./node_modules/tim-upload-plugin/index.js"></script>
<script src="./node_modules/@tencentcloud/chat/index.js"></script>
```

## Khắc phục sự cố

### Lỗi "Flutter not found"
- Đảm bảo Flutter đã được cài đặt và thêm vào PATH
- Chạy `flutter doctor` để kiểm tra cài đặt

### Lỗi "npm not found"
- Cài đặt Node.js từ https://nodejs.org/
- Khởi động lại terminal sau khi cài đặt

### Lỗi Build
- Chạy `flutter clean` và thử lại
- Kiểm tra `flutter doctor` để tìm vấn đề
- Đảm bảo tất cả dependencies được cập nhật với `flutter pub upgrade`

### Không tìm thấy Web Dependencies
- Đảm bảo bạn đã chạy `npm install` trong thư mục `imdemo/web`
- Kiểm tra xem thư mục `node_modules` có tồn tại trong `imdemo/web` không

## Tài liệu bổ sung

- [Flutter Web Documentation](https://flutter.dev/web)
- [Tencent Cloud Chat SDK Documentation](https://cloud.tencent.com/document/product/269)
- [Flutter Web Deployment Guide](https://flutter.dev/docs/deployment/web)

## Hỗ trợ

Nếu có vấn đề hoặc câu hỏi:
- Telegram: https://t.me/+1doS9AUBmndhNGNl
- WhatsApp: https://chat.whatsapp.com/Gfbxk7rQBqc8Rz4pzzP27A
- QQ Group: 788910197
