import 'dart:convert';
import 'dart:io';

/// Tool to build APK and upload to Google Drive
/// 
/// Usage:
///   dart tools/build_apk/build_apk.dart           # Build release APK
///   dart tools/build_apk/build_apk.dart --debug   # Build debug APK
/// 
/// Steps:
/// 1. Run bump_version.dart to update android.properties
/// 2. Build APK (release or debug mode)
/// 3. Upload APK to Google Drive

void main(List<String> args) async {
  final isDebug = args.contains('--debug');
  final buildMode = isDebug ? 'debug' : 'release';
  
  print('🚀 Starting APK build process...');
  print('📦 Build mode: $buildMode');
  print('');
  
  try {
    // Step 1: Run bump_version.dart
    print('📝 Step 1: Bumping version...');
    await _runBumpVersion();
    print('✅ Version bumped successfully!\n');
    
    // Step 2: Build APK
    print('🔨 Step 2: Building APK ($buildMode mode)...');
    final apkPath = await _buildApk(isDebug: isDebug);
    print('✅ APK built successfully: $apkPath\n');
    
    // Step 3: Upload to Google Drive
    print('☁️  Step 3: Uploading to Google Drive...');
    final driveUrl = await _uploadToGoogleDrive(apkPath);
    if (driveUrl != null) {
      print('✅ Uploaded successfully!');
      print('🔗 Google Drive URL: $driveUrl');
    } else {
      print('⚠️  Upload skipped or failed (check configuration)');
    }
    
    print('');
    print('🎉 Build process completed!');
    
  } catch (e, stackTrace) {
    print('');
    print('❌ Error occurred: $e');
    print('Stack trace: $stackTrace');
    exit(1);
  }
}

/// Run bump_version.dart tool
Future<void> _runBumpVersion() async {
  final bumpVersionScript = File('tools/bump_version/bump_version.dart');
  
  if (!bumpVersionScript.existsSync()) {
    throw Exception('bump_version.dart not found at ${bumpVersionScript.path}');
  }
  
  final process = await Process.start(
    'dart',
    [bumpVersionScript.path],
    runInShell: true,
  );
  
  // Stream output
  process.stdout.transform(const SystemEncoding().decoder).listen((data) {
    stdout.write(data);
  });
  
  process.stderr.transform(const SystemEncoding().decoder).listen((data) {
    stderr.write(data);
  });
  
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception('bump_version.dart failed with exit code $exitCode');
  }
}

/// Build APK using Flutter
Future<String> _buildApk({required bool isDebug}) async {
  final buildMode = isDebug ? '--debug' : '--release';
  final outputDir = isDebug 
      ? 'build/app/outputs/flutter-apk/app-debug.apk'
      : 'build/app/outputs/flutter-apk/app-release.apk';
  
  print('   Running: flutter build apk $buildMode');
  
  final process = await Process.start(
    'flutter',
    ['build', 'apk', buildMode],
    runInShell: true,
  );
  
  // Stream output
  process.stdout.transform(const SystemEncoding().decoder).listen((data) {
    stdout.write(data);
  });
  
  process.stderr.transform(const SystemEncoding().decoder).listen((data) {
    stderr.write(data);
  });
  
  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    throw Exception('Flutter build failed with exit code $exitCode');
  }
  
  final apkFile = File(outputDir);
  if (!apkFile.existsSync()) {
    throw Exception('APK file not found at ${apkFile.path}');
  }
  
  return apkFile.absolute.path;
}

/// Upload APK to Google Drive
/// 
/// Requires environment variables:
/// - GOOGLE_DRIVE_FOLDER_ID: Google Drive folder ID to upload to
/// - GOOGLE_DRIVE_ACCESS_TOKEN: OAuth2 access token (optional, can use service account)
/// - GOOGLE_DRIVE_REFRESH_TOKEN: OAuth2 refresh token (optional, will auto-refresh if provided)
/// 
/// Or use service account:
/// - GOOGLE_DRIVE_SERVICE_ACCOUNT_KEY: Path to service account JSON key file
Future<String?> _uploadToGoogleDrive(String apkPath) async {
  // Check if Google Drive is configured
  final folderId = Platform.environment['GOOGLE_DRIVE_FOLDER_ID'];
  var accessToken = Platform.environment['GOOGLE_DRIVE_ACCESS_TOKEN'];
  final refreshToken = Platform.environment['GOOGLE_DRIVE_REFRESH_TOKEN'];
  final serviceAccountKey = Platform.environment['GOOGLE_DRIVE_SERVICE_ACCOUNT_KEY'];
  
  if (folderId == null || folderId.isEmpty) {
    print('   ⚠️  GOOGLE_DRIVE_FOLDER_ID not set, skipping upload');
    return null;
  }
  
  // Try to refresh token if refresh_token is provided
  if (refreshToken != null && refreshToken.isNotEmpty) {
    print('   🔄 Refreshing access token...');
    try {
      final newAccessToken = await _refreshAccessToken(refreshToken);
      if (newAccessToken != null) {
        accessToken = newAccessToken;
        // Update environment variable for current process
        Platform.environment['GOOGLE_DRIVE_ACCESS_TOKEN'] = newAccessToken;
        print('   ✅ Access token refreshed successfully');
      } else {
        print('   ⚠️  Failed to refresh token, using existing access token if available');
      }
    } catch (e) {
      print('   ⚠️  Token refresh failed: $e');
      print('   💡 Continuing with existing access token if available');
    }
  }
  
  if (accessToken == null && serviceAccountKey == null) {
    print('   ⚠️  No Google Drive credentials found, skipping upload');
    print('   💡 Set GOOGLE_DRIVE_ACCESS_TOKEN or GOOGLE_DRIVE_SERVICE_ACCOUNT_KEY');
    return null;
  }
  
  try {
    // Use simple HTTP upload with access token
    if (accessToken != null) {
      return await _uploadWithAccessToken(apkPath, folderId, accessToken);
    }
    
    // Use service account (requires googleapis package)
    if (serviceAccountKey != null) {
      return await _uploadWithServiceAccount(apkPath, folderId, serviceAccountKey);
    }
    
    return null;
  } catch (e) {
    print('   ❌ Upload failed: $e');
    return null;
  }
}

/// Upload using OAuth2 access token
Future<String> _uploadWithAccessToken(
  String apkPath,
  String folderId,
  String accessToken,
) async {
  final apkFile = File(apkPath);
  final fileName = apkFile.path.split(Platform.pathSeparator).last;
  final fileSize = await apkFile.length();
  
  print('   📤 Uploading $fileName (${_formatFileSize(fileSize)})...');
  
  // Create file metadata
  final metadata = {
    'name': fileName,
    'parents': [folderId],
  };
  
  final httpClient = HttpClient();
  
  try {
    final boundary = '----WebKitFormBoundary${DateTime.now().millisecondsSinceEpoch}';
    final request = await httpClient.postUrl(
      Uri.parse('https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart'),
    );
    
    request.headers.set('Authorization', 'Bearer $accessToken');
    request.headers.set('Content-Type', 'multipart/related; boundary=$boundary');
    
    // Read file as bytes
    final fileBytes = await apkFile.readAsBytes();
    
    // Build multipart body
    final metadataJson = jsonEncode(metadata);
    
    // Combine all parts into single list
    final bodyParts = <List<int>>[
      // Metadata part
      utf8.encode('--$boundary\r\n'),
      utf8.encode('Content-Type: application/json; charset=UTF-8\r\n\r\n'),
      utf8.encode(metadataJson),
      utf8.encode('\r\n'),
      // File part
      utf8.encode('--$boundary\r\n'),
      utf8.encode('Content-Type: application/vnd.android.package-archive\r\n\r\n'),
      fileBytes,
      utf8.encode('\r\n--$boundary--\r\n'),
    ];
    
    // Calculate total length
    final totalLength = bodyParts.fold<int>(
      0,
      (sum, part) => sum + part.length,
    );
    
    request.contentLength = totalLength;
    
    // Create stream from parts
    final bodyStream = Stream<List<int>>.fromIterable(bodyParts);
    await request.addStream(bodyStream);
    
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      // Parse response to get file ID
      final responseJson = jsonDecode(responseBody) as Map<String, dynamic>;
      final fileId = responseJson['id'] as String?;
      
      if (fileId != null) {
        // Make file shareable (optional)
        await _makeFileShareable(fileId, accessToken);
        
        return 'https://drive.google.com/file/d/$fileId/view';
      } else {
        throw Exception('File ID not found in response');
      }
    } else {
      throw Exception('Upload failed: ${response.statusCode} - $responseBody');
    }
  } finally {
    httpClient.close();
  }
}

/// Make file shareable (anyone with link can view)
Future<void> _makeFileShareable(String fileId, String accessToken) async {
  final httpClient = HttpClient();
  
  try {
    final request = await httpClient.patchUrl(
      Uri.parse('https://www.googleapis.com/drive/v3/files/$fileId/permissions'),
    );
    
    request.headers.set('Authorization', 'Bearer $accessToken');
    request.headers.set('Content-Type', 'application/json');
    
    final permission = {
      'role': 'reader',
      'type': 'anyone',
    };
    
    request.write(jsonEncode(permission));
    await request.close();
  } catch (e) {
    // Ignore permission errors, file will still be uploaded
    print('   ⚠️  Could not make file shareable: $e');
  } finally {
    httpClient.close();
  }
}

/// Upload using service account (requires googleapis package)
Future<String> _uploadWithServiceAccount(
  String apkPath,
  String folderId,
  String serviceAccountKeyPath,
) async {
  // This requires googleapis package
  // For now, return a placeholder implementation
  print('   ⚠️  Service account upload not yet implemented');
  print('   💡 Please use GOOGLE_DRIVE_ACCESS_TOKEN instead');
  throw UnimplementedError('Service account upload requires googleapis package');
}

/// Refresh OAuth2 access token using refresh token
/// 
/// Uses Google OAuth Playground refresh endpoint
/// Returns new access token or null if failed
Future<String?> _refreshAccessToken(String refreshToken) async {
  final httpClient = HttpClient();
  
  try {
    final request = await httpClient.postUrl(
      Uri.parse('https://developers.google.com/oauthplayground/refreshAccessToken'),
    );
    
    request.headers.set('Content-Type', 'application/json');
    request.headers.set('accept', 'application/json, text/javascript, */*; q=0.01');
    request.headers.set('user-agent', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36');
    request.headers.set('origin', 'https://developers.google.com');
    request.headers.set('referer', 'https://developers.google.com/oauthplayground/');
    request.headers.set('x-requested-with', 'XMLHttpRequest');
    
    final requestBody = {
      'token_uri': 'https://oauth2.googleapis.com/token',
      'refresh_token': refreshToken,
    };
    
    request.write(jsonEncode(requestBody));
    final response = await request.close();
    final responseBody = await response.transform(utf8.decoder).join();
    
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final responseJson = jsonDecode(responseBody) as Map<String, dynamic>;
      
      // Try to get access_token from response
      // Response format may vary, check common fields
      final accessToken = responseJson['access_token'] as String?;
      
      if (accessToken != null && accessToken.isNotEmpty) {
        return accessToken;
      } else {
        // If response doesn't have access_token directly, might be in different format
        print('   ⚠️  Unexpected response format: $responseBody');
        return null;
      }
    } else {
      print('   ⚠️  Refresh token request failed: ${response.statusCode} - $responseBody');
      return null;
    }
  } catch (e) {
    print('   ⚠️  Error refreshing token: $e');
    return null;
  } finally {
    httpClient.close();
  }
}

/// Format file size for display
String _formatFileSize(int bytes) {
  if (bytes < 1024) return '$bytes B';
  if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
  if (bytes < 1024 * 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
  return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
}
