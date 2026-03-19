# JUST RUN:
```bash
dart run tools/bump_version/bump_version.dart
```

# Bump Version Tool

Tool tự động tăng version trong file `local.properties` cho Android build configuration.

## 📋 Mô tả

Tool này tự động cập nhật các trường version trong file `local.properties` theo công thức:
- **versionCode**: Tăng 1 đơn vị mỗi lần chạy
- **versionName**: Format `X.Y.Z` với `Z = versionCode / 10` (phép chia nguyên)
- **versionNameSuffix**: Format `+N` với `N = versionCode % 10` (phần dư)

## 🚀 Cách sử dụng

### Cách 1: Sử dụng script wrapper (Khuyến nghị)

#### Windows:
```bash
scripts\bump_version.bat
```

#### Linux/Mac:
```bash
chmod +x scripts/bump_version.sh  # Chỉ cần chạy 1 lần
./scripts/bump_version.sh
```

### Cách 2: Chạy trực tiếp với Dart

Từ thư mục root của project:
```bash
dart run tools/bump_version/bump_version.dart
```

## 📐 Logic tính toán

### Công thức:

1. **versionCode**: `newVersionCode = currentVersionCode + 1`

2. **versionName**: 
   - Giữ nguyên 2 phần đầu (ví dụ: `1.0` từ `1.0.1`)
   - Phần thứ 3 = `versionCode / 10` (phép chia nguyên)
   - Kết quả: `X.Y.Z` với `Z = versionCode / 10`

3. **versionNameSuffix**: 
   - Format: `+N` với `N = versionCode % 10` (phần dư)

### Ví dụ:

#### Ví dụ 1: versionCode = 4
- **versionCode**: `4 → 5`
- **versionName**: `1.0.0` (5 / 10 = 0)
- **versionNameSuffix**: `+5` (5 % 10 = 5)
- **Kết quả**: `1.0.0+5`

#### Ví dụ 2: versionCode = 28
- **versionCode**: `28 → 29`
- **versionName**: `1.0.2` (29 / 10 = 2)
- **versionNameSuffix**: `+9` (29 % 10 = 9)
- **Kết quả**: `1.0.2+9`

#### Ví dụ 3: versionCode = 30
- **versionCode**: `30 → 31`
- **versionName**: `1.0.3` (31 / 10 = 3)
- **versionNameSuffix**: `+1` (31 % 10 = 1)
- **Kết quả**: `1.0.3+1`

#### Ví dụ 4: versionCode = 99
- **versionCode**: `99 → 100`
- **versionName**: `1.0.10` (100 / 10 = 10)
- **versionNameSuffix**: `+0` (100 % 10 = 0)
- **Kết quả**: `1.0.10+0`

## 📝 Output mẫu

```
✅ Version bumped successfully!

📊 Version Summary:
   versionCode:       4 → 5
   versionName:       1.0.0 → 1.0.0
   versionNameSuffix: +4 → +5

📝 Updated local.properties
```

## ⚙️ Cấu trúc file local.properties

Tool yêu cầu file `local.properties` ở root của project với format:

```properties
# Version Information
app.versionCode=4
app.versionName=1.0.0
app.versionNameSuffix=+4
```

## 🔧 Tính năng

- ✅ Tự động tăng versionCode
- ✅ Tự động tính toán versionName và versionNameSuffix
- ✅ Giữ nguyên format file (comments, empty lines)
- ✅ Validation: Kiểm tra file tồn tại và versionCode hợp lệ
- ✅ Hiển thị summary trước/sau khi update

## ⚠️ Lưu ý

1. **Chạy từ thư mục root**: Tool phải được chạy từ thư mục root của project (nơi có file `local.properties`)

2. **Thay đổi phần đầu versionName**: Nếu muốn thay đổi phần đầu của `versionName` (ví dụ từ `1.0` sang `1.1` hoặc `2.0`), bạn cần sửa tay trong `local.properties` trước khi chạy tool:
   ```properties
   app.versionName=1.1.0  # Sửa tay từ 1.0.0
   ```
   Sau đó chạy tool, phần thứ 3 sẽ được tính toán tự động.

3. **Backup**: Tool sẽ ghi đè file `local.properties`. Nên commit changes trước khi chạy hoặc backup file nếu cần.

4. **Format versionNameSuffix**: Tool luôn sử dụng format `+N`. Nếu bạn muốn format khác, cần sửa code.

## 🔄 Workflow đề xuất

1. **Sửa tay versionName** (nếu cần thay đổi major/minor version):
   ```properties
   app.versionName=1.1.0  # Thay đổi từ 1.0.x sang 1.1.x
   ```

2. **Chạy tool** để tự động tăng version:
   ```bash
   scripts\bump_version.bat
   ```

3. **Build app** với version mới:
   ```bash
   flutter build apk --release
   ```

4. **Commit changes**:
   ```bash
   git add local.properties
   git commit -m "chore: bump version to X.Y.Z"
   ```

## 🐛 Xử lý lỗi

### Lỗi: `local.properties not found`
- **Nguyên nhân**: Chạy tool không đúng thư mục
- **Giải pháp**: Đảm bảo chạy từ thư mục root của project

### Lỗi: `app.versionCode not found`
- **Nguyên nhân**: File `local.properties` không có trường `app.versionCode`
- **Giải pháp**: Thêm `app.versionCode=1` vào file `local.properties`

## 📚 Liên quan

- File cấu hình: `local.properties` (root của project)
- Build config: `android/app/build.gradle.kts` (load từ `local.properties`)
- Script wrappers: `scripts/bump_version.bat` và `scripts/bump_version.sh`

## 📄 License

Tool này là một phần của project và tuân theo license của project.

