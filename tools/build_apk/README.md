# Build APK Tool

Tool tự động build APK và upload lên Google Drive.

## Tính năng

1. **Tự động bump version**: Chạy `bump_version.dart` để cập nhật `android.properties` trước khi build
2. **Build APK**: Build APK ở chế độ release (mặc định) hoặc debug
3. **Upload Google Drive**: Tự động upload APK lên Google Drive sau khi build thành công

## Cách sử dụng

### Build Release APK (mặc định)

```bash
dart tools/build_apk/build_apk.dart
```

### Build Debug APK

```bash
dart tools/build_apk/build_apk.dart --debug
```

## Cấu hình Google Drive

Để upload APK lên Google Drive, bạn cần cấu hình các biến môi trường sau:

### Option 1: Sử dụng OAuth2 với Auto-Refresh (Khuyến nghị)

1. Lấy refresh token từ Google OAuth2 Playground
2. Set biến môi trường:

```bash
# Windows PowerShell
$env:GOOGLE_DRIVE_FOLDER_ID="your-folder-id"
$env:GOOGLE_DRIVE_REFRESH_TOKEN="your-refresh-token"

# Windows CMD
set GOOGLE_DRIVE_FOLDER_ID=your-folder-id
set GOOGLE_DRIVE_REFRESH_TOKEN=your-refresh-token

# Linux/Mac
export GOOGLE_DRIVE_FOLDER_ID="your-folder-id"
export GOOGLE_DRIVE_REFRESH_TOKEN="your-refresh-token"
```

**Lưu ý**: Tool sẽ tự động refresh access token trước mỗi lần upload, không cần set `GOOGLE_DRIVE_ACCESS_TOKEN`.

### Option 2: Sử dụng OAuth2 Access Token (Thủ công)

1. Lấy OAuth2 access token từ Google OAuth2 Playground hoặc Google Cloud Console
2. Set biến môi trường:

```bash
# Windows PowerShell
$env:GOOGLE_DRIVE_FOLDER_ID="your-folder-id"
$env:GOOGLE_DRIVE_ACCESS_TOKEN="your-access-token"

# Windows CMD
set GOOGLE_DRIVE_FOLDER_ID=your-folder-id
set GOOGLE_DRIVE_ACCESS_TOKEN=your-access-token

# Linux/Mac
export GOOGLE_DRIVE_FOLDER_ID="your-folder-id"
export GOOGLE_DRIVE_ACCESS_TOKEN="your-access-token"
```

**Lưu ý**: Access token có thời hạn (thường 1 giờ), cần refresh thủ công khi hết hạn.

### Option 2: Sử dụng Service Account (Chưa implement)

```bash
export GOOGLE_DRIVE_FOLDER_ID="your-folder-id"
export GOOGLE_DRIVE_SERVICE_ACCOUNT_KEY="path/to/service-account-key.json"
```

## Lấy Google Drive Folder ID

1. Mở Google Drive và tạo folder (hoặc chọn folder có sẵn)
2. Mở folder đó
3. URL sẽ có dạng: `https://drive.google.com/drive/folders/1a2b3c4d5e6f7g8h9i0j`
4. Phần `1a2b3c4d5e6f7g8h9i0j` chính là Folder ID

## Lấy OAuth2 Refresh Token (Khuyến nghị)

### Google OAuth2 Playground

1. Truy cập: https://developers.google.com/oauthplayground/
2. Ở bên trái, tìm và chọn "Drive API v3"
3. Chọn scope: `https://www.googleapis.com/auth/drive.file`
4. Click "Authorize APIs"
5. Đăng nhập và cho phép quyền truy cập
6. Click "Exchange authorization code for tokens"
7. Copy **"Refresh token"** (không bao giờ hết hạn, trừ khi bị revoke)
8. Set biến môi trường `GOOGLE_DRIVE_REFRESH_TOKEN` với giá trị này

**Lưu ý**: Refresh token chỉ hiển thị lần đầu, hãy lưu lại ngay!

## Lấy OAuth2 Access Token (Thủ công)

### Cách 1: Google OAuth2 Playground

1. Truy cập: https://developers.google.com/oauthplayground/
2. Ở bên trái, tìm và chọn "Drive API v3"
3. Chọn scope: `https://www.googleapis.com/auth/drive.file`
4. Click "Authorize APIs"
5. Đăng nhập và cho phép quyền truy cập
6. Click "Exchange authorization code for tokens"
7. Copy "Access token" (có thời hạn 1 giờ)

### Cách 2: Google Cloud Console

1. Tạo OAuth2 credentials trong Google Cloud Console
2. Sử dụng OAuth2 flow để lấy access token
3. Hoặc sử dụng service account (cần implement thêm)

## Quy trình hoạt động

1. **Bump Version**: 
   - Chạy `tools/bump_version/bump_version.dart`
   - Tự động tăng `versionCode` và cập nhật `versionName` trong `android.properties`

2. **Build APK**:
   - Chạy `flutter build apk --release` hoặc `flutter build apk --debug`
   - APK được tạo tại:
     - Release: `build/app/outputs/flutter-apk/app-release.apk`
     - Debug: `build/app/outputs/flutter-apk/app-debug.apk`

3. **Upload Google Drive**:
   - Upload APK lên Google Drive folder đã cấu hình
   - Tự động set quyền "Anyone with link can view"
   - Trả về link Google Drive để chia sẻ

## Lưu ý

- Nếu không cấu hình Google Drive, tool vẫn sẽ build APK nhưng bỏ qua bước upload
- **Khuyến nghị**: Sử dụng `GOOGLE_DRIVE_REFRESH_TOKEN` thay vì `GOOGLE_DRIVE_ACCESS_TOKEN` để tool tự động refresh token
- Nếu sử dụng refresh token, tool sẽ tự động refresh access token trước mỗi lần upload
- Access token có thời hạn (thường 1 giờ), nếu dùng access token trực tiếp cần refresh thủ công khi hết hạn
- File APK sẽ được đặt tên theo tên file build (app-release.apk hoặc app-debug.apk)
- Tool sẽ tự động tạo link chia sẻ công khai cho file APK

## Troubleshooting

### Lỗi: "bump_version.dart not found"
- Đảm bảo bạn đang chạy tool từ thư mục root của project
- Kiểm tra file `tools/bump_version/bump_version.dart` có tồn tại

### Lỗi: "Flutter build failed"
- Kiểm tra Flutter đã được cài đặt và trong PATH
- Kiểm tra project có lỗi compile không
- Chạy `flutter clean` và thử lại

### Lỗi: "Upload failed"
- Kiểm tra access token còn hạn không
- Kiểm tra folder ID có đúng không
- Kiểm tra quyền truy cập Google Drive API
- Kiểm tra kết nối internet

### APK không được upload
- Kiểm tra biến môi trường `GOOGLE_DRIVE_FOLDER_ID` đã được set
- Kiểm tra biến môi trường `GOOGLE_DRIVE_REFRESH_TOKEN` hoặc `GOOGLE_DRIVE_ACCESS_TOKEN` đã được set
- Nếu không muốn upload, có thể bỏ qua bước này (tool vẫn build APK thành công)

### Lỗi: "Token refresh failed"
- Kiểm tra refresh token có đúng không
- Kiểm tra refresh token chưa bị revoke
- Thử lấy refresh token mới từ Google OAuth2 Playground
- Kiểm tra kết nối internet
