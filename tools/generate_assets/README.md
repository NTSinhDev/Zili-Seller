# Tools

## generate_assets.dart

Script tự động generate file `lib/res/assets.dart` từ cấu trúc folder `assets/`.

### Cách sử dụng:

#### Cách 1: Chạy trực tiếp
```bash
dart run tools/generate_assets/generate_assets.dart
```

#### Cách 2: Sử dụng script helper
**Windows:**
```bash
scripts\pub_get_with_assets.bat
```

**Linux/Mac:**
```bash
chmod +x scripts/pub_get_with_assets.sh
./scripts/pub_get_with_assets.sh
```

#### Cách 3: Tích hợp với VS Code/Cursor tasks

Thêm vào `.vscode/tasks.json`:
```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Generate Assets",
      "type": "shell",
      "command": "dart run tools/generate_assets/generate_assets.dart",
      "group": "build",
      "presentation": {
        "reveal": "silent"
      },
      "problemMatcher": []
    },
    {
      "label": "Pub Get + Generate Assets",
      "type": "shell",
      "command": "flutter pub get && dart run tools/generate_assets/generate_assets.dart",
      "group": "build",
      "problemMatcher": []
    }
  ]
}
```

### Tự động chạy sau pub get:

#### Option 1: Sử dụng script helper
Thay vì chạy `flutter pub get`, chạy:
- Windows: `scripts\pub_get_with_assets.bat`
- Linux/Mac: `./scripts/pub_get_with_assets.sh`

#### Option 2: Git hooks (khuyến nghị)
Tạo file `.git/hooks/post-merge`:
```bash
#!/bin/bash
dart run tools/generate_assets/generate_assets.dart
```

#### Option 3: VS Code/Cursor extension
Có thể tạo extension hoặc sử dụng task runner để tự động chạy sau pub get.

### Cấu trúc file được generate:

File `lib/res/assets.dart` sẽ có cấu trúc:
```dart
class AppAssets {
  AppAssets._();
  
  static const String assets = 'assets';
  
  // Logo assets
  static const String logo = 'assets/logo';
  static const String logoPng = 'assets/logo/logo.png';
  // ...
}
```

### Lưu ý:
- Script sẽ tự động bỏ qua file `.gitignore`, file ẩn (bắt đầu bằng `.`), và file `README.md`
- Tên constant được convert sang camelCase tự động
- Folder được tổ chức theo cấu trúc thư mục

