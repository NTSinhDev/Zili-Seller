import 'dart:io';

/// Script tự động generate file assets.dart từ cấu trúc folder assets/
/// Mỗi folder level 1 sẽ tạo một class riêng (AssetIcons, AssetImages, AssetLogo, etc.)
/// 
/// Usage:
///   dart run tools/generate_assets.dart
///   hoặc
///   flutter pub run tools/generate_assets.dart

void main() {
  final assetsDir = Directory('assets');
  if (!assetsDir.existsSync()) {
    print('❌ Folder assets/ không tồn tại!');
    exit(1);
  }

  // Reset counters
  _fileCount = 0;
  _folderCount = 0;
  _newFilePaths.clear();

  // Đọc file assets.dart cũ (nếu có) để so sánh
  final oldFilePaths = _readExistingAssetsFile();

  final buffer = StringBuffer();
  buffer.writeln('/// File này được tự động generate bởi script generate_assets.dart');
  buffer.writeln('/// Chạy: dart run tools/generate_assets/generate_assets.dart');
  buffer.writeln('/// Hoặc: flutter pub run tools/generate_assets/generate_assets.dart');
  buffer.writeln('/// ');
  buffer.writeln('/// Để tự động generate sau mỗi lần pub get, thêm vào pubspec.yaml:');
  buffer.writeln('/// scripts:');
  buffer.writeln('///   post_get: dart run tools/generate_assets/generate_assets.dart');
  buffer.writeln('');

  // Scan level 1 folders and create classes
  final level1Items = assetsDir.listSync()
    ..sort((a, b) {
      if (a is Directory && b is File) return -1;
      if (a is File && b is Directory) return 1;
      return a.path.compareTo(b.path);
    });

  final classBuffers = <String, StringBuffer>{};

  for (final item in level1Items) {
    final name = item.path.split(Platform.pathSeparator).last;
    
    // Skip hidden files and folders
    if (name.startsWith('.')) continue;
    if (name.toLowerCase() == 'readme.md') continue;
    // Skip fonts folder (only used in pubspec.yaml)
    if (name.toLowerCase() == 'fonts') continue;

    if (item is Directory) {
      _folderCount++;
      final className = _toPascalCase(name);
      final classBuffer = StringBuffer();
      
      // Generate class for this folder
      _generateClassForFolder(classBuffer, item, 'assets/$name', name);
      
      classBuffers[className] = classBuffer;
    }
  }

  // Generate AppAssets class with instances
  buffer.writeln('class AppAssets {');
  buffer.writeln('  AppAssets._();');
  buffer.writeln('');
  buffer.writeln('  // Assets root path');
  buffer.writeln('  static const String assets = \'assets\';');
  buffer.writeln('');

  // Add instances for each folder class
  for (final entry in classBuffers.entries) {
    final className = entry.key;
    final instanceName = _getInstanceName(className);
    buffer.writeln('  // ${_capitalize(instanceName)} assets');
    buffer.writeln('  static final Asset$className ${instanceName} = Asset$className._();');
    buffer.writeln('');
  }

  buffer.writeln('}');
  buffer.writeln('');

  // Generate all folder classes
  for (final entry in classBuffers.entries) {
    buffer.write(entry.value);
    buffer.writeln('');
  }

  // Write to file
  final outputFile = File('lib/res/assets.dart');
  outputFile.writeAsStringSync(buffer.toString());
  
  // So sánh và thống kê
  final newFilePaths = _newFilePaths.toSet();
  final deletedFilePaths = oldFilePaths.difference(newFilePaths).toList()..sort();
  final addedFilePaths = newFilePaths.difference(oldFilePaths).toList()..sort();
  final unchangedCount = newFilePaths.intersection(oldFilePaths).length;
  
  print('✅ Đã generate thành công file lib/res/assets.dart');
  print('📁 Đã scan ${_fileCount} files và ${_folderCount} folders');
  print('📦 Đã tạo ${classBuffers.length} asset classes');
  print('');
  print('📊 Thống kê thay đổi:');
  print('   ➕ Thêm mới: ${addedFilePaths.length} files');
  if (addedFilePaths.isNotEmpty) {
    for (final path in addedFilePaths.take(5)) {
      print('      • $path');
    }
    if (addedFilePaths.length > 5) {
      print('      ... và ${addedFilePaths.length - 5} files khác');
    }
  }
  print('   ➖ Đã xóa: ${deletedFilePaths.length} files');
  if (deletedFilePaths.isNotEmpty) {
    for (final path in deletedFilePaths.take(5)) {
      print('      • $path');
    }
    if (deletedFilePaths.length > 5) {
      print('      ... và ${deletedFilePaths.length - 5} files khác');
    }
  }
  print('   ✓ Giữ nguyên: $unchangedCount files');
}

int _fileCount = 0;
int _folderCount = 0;
final Set<String> _newFilePaths = <String>{};

/// Đọc file assets.dart hiện tại và trả về danh sách các file paths
Set<String> _readExistingAssetsFile() {
  final assetsFile = File('lib/res/assets.dart');
  if (!assetsFile.existsSync()) {
    return <String>{};
  }

  final content = assetsFile.readAsStringSync();
  final filePaths = <String>{};
  
  // Tìm tất cả các dòng có dạng: static const String xxx = 'assets/...';
  final regex = RegExp(r"static const String \w+ = '([^']+)';");
  final matches = regex.allMatches(content);
  
  for (final match in matches) {
    final path = match.group(1);
    if (path != null && path.startsWith('assets/')) {
      // Lấy tất cả paths (cả file và folder), sau đó sẽ filter
      // Chỉ lấy những path có extension (là file, không phải folder)
      if (path.contains('.') && !path.endsWith('/')) {
        // Kiểm tra xem có phải là file không (có extension)
        final parts = path.split('/');
        final fileName = parts.last;
        if (fileName.contains('.') && fileName.split('.').length > 1) {
          filePaths.add(path);
        }
      }
    }
  }
  
  return filePaths;
}

void _generateClassForFolder(StringBuffer buffer, Directory dir, String path, String folderName) {
  final className = _toPascalCase(folderName);
  final basePath = path;
  
  buffer.writeln('class Asset$className {');
  buffer.writeln('  Asset$className._();');
  buffer.writeln('');
  buffer.writeln('  // Base path');
  buffer.writeln('  static const String path = \'$basePath\';');
  buffer.writeln('');

  // Process files and subfolders
  _generateAssetsForClass(buffer, dir, basePath, folderName);

  buffer.writeln('}');
}

void _generateAssetsForClass(StringBuffer buffer, Directory dir, String path, String category) {
  final items = dir.listSync()
    ..sort((a, b) {
      if (a is Directory && b is File) return -1;
      if (a is File && b is Directory) return 1;
      return a.path.compareTo(b.path);
    });

  String? currentSubCategory;
  final usedNames = <String>{};

  for (final item in items) {
    final name = item.path.split(Platform.pathSeparator).last;
    
    // Skip hidden files and folders
    if (name.startsWith('.')) continue;
    if (name.toLowerCase() == 'readme.md') continue;
    // Skip fonts folder (only used in pubspec.yaml)
    if (name.toLowerCase() == 'fonts') continue;

    if (item is Directory) {
      _folderCount++;
      final folderPath = '$path/$name';
      final folderName = _toCamelCase(name);
      
      // Add subcategory comment
      if (currentSubCategory != name) {
        if (currentSubCategory != null) buffer.writeln('');
        buffer.writeln('  // ${_capitalize(name)}');
        currentSubCategory = name;
      }
      
      // Add folder constant
      var constName = folderName;
      var counter = 1;
      while (usedNames.contains(constName)) {
        constName = '${folderName}${counter}';
        counter++;
      }
      usedNames.add(constName);
      
      buffer.writeln('  static const String $constName = \'$folderPath\';');
      
      // Recursively process subdirectory
      _generateAssetsForClass(buffer, item, folderPath, name);
    } else if (item is File) {
      _fileCount++;
      final fileName = name.split('.').first;
      final extension = name.split('.').last.toLowerCase();
      final filePath = '$path/$name';
      
      // Lưu file path để so sánh
      _newFilePaths.add(filePath);
      
      // Add subcategory comment if needed
      final parentFolder = path.split('/').last;
      if (currentSubCategory != parentFolder) {
        if (currentSubCategory != null) buffer.writeln('');
        buffer.writeln('  // ${_capitalize(parentFolder)}');
        currentSubCategory = parentFolder;
      }
      
      // Generate constant name - include parent folder if in subfolder
      final pathParts = path.split('/').where((p) => p != 'assets' && p.isNotEmpty).toList();
      String constName;
      
      if (pathParts.length > 1) {
        // In subfolder: use subfolder name + file name
        final subFolder = pathParts[pathParts.length - 1];
        constName = '${_toCamelCase(subFolder)}${_toCamelCase(fileName, capitalize: true)}${_capitalize(extension)}';
      } else {
        // In root folder: use file name only
        constName = '${_toCamelCase(fileName)}${_capitalize(extension)}';
      }
      
      // Ensure unique name
      var finalName = constName;
      var counter = 1;
      while (usedNames.contains(finalName)) {
        finalName = '${constName}${counter}';
        counter++;
      }
      usedNames.add(finalName);
      
      buffer.writeln('  static const String $finalName = \'$filePath\';');
    }
  }
}

String _toCamelCase(String input, {bool capitalize = false}) {
  final parts = input
      .split(RegExp(r'[_\s-]+'))
      .where((part) => part.isNotEmpty)
      .map((part) => part.toLowerCase())
      .toList();
  
  if (parts.isEmpty) return input;
  
  final first = capitalize 
      ? parts[0][0].toUpperCase() + parts[0].substring(1)
      : parts[0];
  
  final rest = parts.skip(1).map((part) => 
      part[0].toUpperCase() + part.substring(1)
  ).join('');
  
  return first + rest;
}

String _toPascalCase(String input) {
  return _toCamelCase(input, capitalize: true);
}

String _capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1).toLowerCase();
}

String _getInstanceName(String className) {
  // Convert AssetIcons -> icons, AssetImages -> images
  if (className.startsWith('Asset')) {
    final name = className.substring(5); // Remove "Asset" prefix
    return name[0].toLowerCase() + name.substring(1);
  }
  return className[0].toLowerCase() + className.substring(1);
}
