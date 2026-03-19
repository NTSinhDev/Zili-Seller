import 'dart:io';

/// Script tự động generate commit message dựa trên các thay đổi hiện tại
/// 
/// Usage:
///   dart run scripts/generate_commit_message.dart

void main() async {
  // Lấy danh sách files đã thay đổi
  final changedFiles = await _getChangedFiles();
  
  if (changedFiles.isEmpty) {
    print('❌ Không có thay đổi nào để commit!');
    exit(1);
  }

  // Phân tích thay đổi
  final analysis = _analyzeChanges(changedFiles);
  
  // Generate commit message với title và body
  final commitData = _generateCommitMessage(analysis, changedFiles);
  
  // Output format: TITLE\nBODY
  // Script sẽ parse để tách title và body
  print('TITLE:${commitData['title']}');
  if (commitData['body'] != null && (commitData['body'] as String).isNotEmpty) {
    print('BODY:${commitData['body']}');
  }
}

Future<List<String>> _getChangedFiles() async {
  final result = await Process.run(
    'git',
    ['diff', '--cached', '--name-only'],
    runInShell: true,
  );
  
  if (result.exitCode != 0) {
    // Nếu không có staged files, lấy unstaged files
    final unstagedResult = await Process.run(
      'git',
      ['diff', '--name-only'],
      runInShell: true,
    );
    
    if (unstagedResult.exitCode != 0) {
      return [];
    }
    
    return unstagedResult.stdout.toString().split('\n')
        .where((line) => line.trim().isNotEmpty)
        .toList();
  }
  
  return result.stdout.toString().split('\n')
      .where((line) => line.trim().isNotEmpty)
      .toList();
}

Map<String, dynamic> _analyzeChanges(List<String> files) {
  final analysis = <String, dynamic>{
    'type': 'chore',
    'scope': '',
    'hasBreakingChange': false,
    'files': {
      'dart': <String>[],
      'yaml': <String>[],
      'json': <String>[],
      'md': <String>[],
      'assets': <String>[],
      'config': <String>[],
      'other': <String>[],
    },
    'folders': <String>{},
    'newFiles': <String>[],
    'modifiedFiles': <String>[],
    'deletedFiles': <String>[],
  };

  for (final file in files) {
    final path = file.trim();
    if (path.isEmpty) continue;

    // Xác định loại file
    if (path.endsWith('.dart')) {
      analysis['files']['dart'].add(path);
    } else if (path.endsWith('.yaml') || path.endsWith('.yml')) {
      analysis['files']['yaml'].add(path);
    } else if (path.endsWith('.json')) {
      analysis['files']['json'].add(path);
    } else if (path.endsWith('.md')) {
      analysis['files']['md'].add(path);
    } else if (path.startsWith('assets/')) {
      analysis['files']['assets'].add(path);
    } else if (path.startsWith('.') || 
               path.contains('config') || 
               path.contains('gradle') ||
               path.contains('pubspec')) {
      analysis['files']['config'].add(path);
    } else {
      analysis['files']['other'].add(path);
    }

    // Xác định folder
    final parts = path.split('/');
    if (parts.length > 1) {
      analysis['folders'].add(parts[0]);
    }

    // Phân loại thay đổi (cần check git status)
    if (path.contains('lib/')) {
      // Có thể là feature, fix, hoặc refactor
    }
  }

  // Xác định type dựa trên files
  final dartFiles = analysis['files']['dart'] as List<String>;
  final assetFiles = analysis['files']['assets'] as List<String>;
  final configFiles = analysis['files']['config'] as List<String>;
  final mdFiles = analysis['files']['md'] as List<String>;

  if (dartFiles.isNotEmpty) {
    // Phân tích Dart files để xác định type
    final hasNewFeature = dartFiles.any((f) => 
        f.contains('views/') || f.contains('screens/') || f.contains('widgets/'));
    final hasFix = dartFiles.any((f) => 
        f.contains('fix') || f.contains('bug') || f.contains('error'));
    final hasRefactor = dartFiles.any((f) => 
        f.contains('refactor') || f.contains('service') || f.contains('repository'));
    final hasTest = dartFiles.any((f) => f.contains('test/'));

    if (hasNewFeature) {
      analysis['type'] = 'feat';
    } else if (hasFix) {
      analysis['type'] = 'fix';
    } else if (hasRefactor) {
      analysis['type'] = 'refactor';
    } else if (hasTest) {
      analysis['type'] = 'test';
    } else {
      analysis['type'] = 'chore';
    }

    // Xác định scope
    if (dartFiles.any((f) => f.contains('bloc/'))) {
      analysis['scope'] = 'state';
    } else if (dartFiles.any((f) => f.contains('views/'))) {
      analysis['scope'] = 'ui';
    } else if (dartFiles.any((f) => f.contains('services/'))) {
      analysis['scope'] = 'service';
    } else if (dartFiles.any((f) => f.contains('data/'))) {
      analysis['scope'] = 'data';
    }
  } else if (assetFiles.isNotEmpty) {
    analysis['type'] = 'chore';
    analysis['scope'] = 'assets';
  } else if (configFiles.isNotEmpty) {
    analysis['type'] = 'chore';
    analysis['scope'] = 'config';
  } else if (mdFiles.isNotEmpty) {
    analysis['type'] = 'docs';
    analysis['scope'] = 'docs';
  }

  // Check breaking changes
  if (dartFiles.any((f) => f.contains('di/')) || 
      configFiles.isNotEmpty ||
      analysis['folders'].contains('services')) {
    analysis['hasBreakingChange'] = true;
  }

  return analysis;
}

Map<String, String> _generateCommitMessage(Map<String, dynamic> analysis, List<String> files) {
  final type = analysis['type'] as String;
  final scope = analysis['scope'] as String;
  final hasBreakingChange = analysis['hasBreakingChange'] as bool;
  
  // Tạo description dựa trên files
  String description = _generateDescription(analysis, files);
  
  // Format: type(scope): description
  String title = scope.isNotEmpty 
      ? '$type($scope): $description'
      : '$type: $description';
  
  // Thêm ! nếu có breaking change
  if (hasBreakingChange) {
    title = title.replaceFirst('$type(', '${type}!(');
    if (scope.isEmpty) {
      title = title.replaceFirst('$type:', '${type}!:');
    }
  }
  
  // Tạo body chi tiết
  String body = _generateBody(analysis, files);
  
  return {
    'title': title,
    'body': body,
  };
}

String _generateDescription(Map<String, dynamic> analysis, List<String> files) {
  final dartFiles = analysis['files']['dart'] as List<String>;
  final assetFiles = analysis['files']['assets'] as List<String>;
  final configFiles = analysis['files']['config'] as List<String>;
  final mdFiles = analysis['files']['md'] as List<String>;

  // Ưu tiên mô tả dựa trên loại thay đổi chính
  if (dartFiles.isNotEmpty) {
    // Phân tích các module chính
    final modules = <String>{};
    for (final file in dartFiles) {
      if (file.contains('bloc/')) {
        final parts = file.split('/');
        if (parts.length > 2) {
          modules.add(parts[2]); // bloc/{module}/
        }
      } else if (file.contains('views/')) {
        final parts = file.split('/');
        if (parts.length > 2) {
          modules.add(parts[2]); // views/{module}/
        }
      } else if (file.contains('services/')) {
        modules.add('service');
      } else if (file.contains('data/repositories/')) {
        modules.add('repository');
      }
    }

    if (modules.isNotEmpty) {
      final moduleList = modules.toList()..sort();
      if (moduleList.length == 1) {
        return 'update ${moduleList[0]} module';
      } else if (moduleList.length <= 3) {
        return 'update ${moduleList.join(", ")} modules';
      } else {
        return 'update multiple modules';
      }
    }

    // Fallback
    if (dartFiles.length == 1) {
      final fileName = dartFiles[0].split('/').last.replaceAll('.dart', '');
      return 'update $fileName';
    } else {
      return 'update ${dartFiles.length} files';
    }
  } else if (assetFiles.isNotEmpty) {
    return 'update assets';
  } else if (configFiles.isNotEmpty) {
    return 'update configuration';
  } else if (mdFiles.isNotEmpty) {
    return 'update documentation';
  } else {
    return 'update ${files.length} files';
  }
}

String _generateBody(Map<String, dynamic> analysis, List<String> files) {
  final dartFiles = analysis['files']['dart'] as List<String>;
  final assetFiles = analysis['files']['assets'] as List<String>;
  final configFiles = analysis['files']['config'] as List<String>;
  final mdFiles = analysis['files']['md'] as List<String>;
  final newFiles = analysis['newFiles'] as List<String>;
  final modifiedFiles = analysis['modifiedFiles'] as List<String>;
  final deletedFiles = analysis['deletedFiles'] as List<String>;
  
  final bodyLines = <String>[];
  
  // Thống kê tổng quan
  if (newFiles.isNotEmpty || modifiedFiles.isNotEmpty || deletedFiles.isNotEmpty) {
    final stats = <String>[];
    if (newFiles.isNotEmpty) stats.add('${newFiles.length} new');
    if (modifiedFiles.isNotEmpty) stats.add('${modifiedFiles.length} modified');
    if (deletedFiles.isNotEmpty) stats.add('${deletedFiles.length} deleted');
    bodyLines.add('- Changes: ${stats.join(", ")} file(s)');
    bodyLines.add('');
  }
  
  // Chi tiết về Dart files
  if (dartFiles.isNotEmpty) {
    bodyLines.add('- Dart files (${dartFiles.length}):');
    
    // Nhóm theo module
    final modules = <String, List<String>>{};
    final otherFiles = <String>[];
    
    for (final file in dartFiles) {
      if (file.contains('bloc/')) {
        final parts = file.split('/');
        if (parts.length > 2) {
          final module = parts[2];
          modules.putIfAbsent('bloc/$module', () => []).add(file);
        } else {
          otherFiles.add(file);
        }
      } else if (file.contains('views/')) {
        final parts = file.split('/');
        if (parts.length > 2) {
          final module = parts[2];
          modules.putIfAbsent('views/$module', () => []).add(file);
        } else {
          otherFiles.add(file);
        }
      } else if (file.contains('services/')) {
        modules.putIfAbsent('services', () => []).add(file);
      } else if (file.contains('data/repositories/')) {
        modules.putIfAbsent('repositories', () => []).add(file);
      } else if (file.contains('data/middlewares/')) {
        modules.putIfAbsent('middlewares', () => []).add(file);
      } else if (file.contains('data/models/')) {
        modules.putIfAbsent('models', () => []).add(file);
      } else if (file.contains('core/')) {
        modules.putIfAbsent('core', () => []).add(file);
      } else {
        otherFiles.add(file);
      }
    }
    
    // Liệt kê theo module
    final sortedModules = modules.keys.toList()..sort();
    for (final module in sortedModules) {
      final moduleFiles = modules[module]!;
      if (moduleFiles.length <= 3) {
        bodyLines.add('  • $module: ${moduleFiles.map((f) => f.split('/').last).join(", ")}');
      } else {
        bodyLines.add('  • $module: ${moduleFiles.length} files');
      }
    }
    
    if (otherFiles.isNotEmpty && otherFiles.length <= 5) {
      for (final file in otherFiles) {
        bodyLines.add('  • ${file.split('/').last}');
      }
    } else if (otherFiles.isNotEmpty) {
      bodyLines.add('  • Other: ${otherFiles.length} files');
    }
    
    bodyLines.add('');
  }
  
  // Chi tiết về assets
  if (assetFiles.isNotEmpty) {
    bodyLines.add('- Assets (${assetFiles.length}):');
    final assetTypes = <String, int>{};
    for (final file in assetFiles) {
      final parts = file.split('/');
      if (parts.length > 1) {
        final type = parts[1]; // assets/{type}/
        assetTypes[type] = (assetTypes[type] ?? 0) + 1;
      }
    }
    for (final entry in assetTypes.entries) {
      bodyLines.add('  • ${entry.key}: ${entry.value} file(s)');
    }
    bodyLines.add('');
  }
  
  // Chi tiết về config files
  if (configFiles.isNotEmpty) {
    bodyLines.add('- Config files:');
    for (final file in configFiles.take(5)) {
      bodyLines.add('  • ${file.split('/').last}');
    }
    if (configFiles.length > 5) {
      bodyLines.add('  • ... and ${configFiles.length - 5} more');
    }
    bodyLines.add('');
  }
  
  // Chi tiết về docs
  if (mdFiles.isNotEmpty) {
    bodyLines.add('- Documentation:');
    for (final file in mdFiles) {
      bodyLines.add('  • ${file.split('/').last}');
    }
    bodyLines.add('');
  }
  
  return bodyLines.join('\n').trim();
}

