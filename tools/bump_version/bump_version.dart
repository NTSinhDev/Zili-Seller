import 'dart:io';

/// Tool to automatically bump version in android.properties
/// 
/// Rules:
/// - versionCode: increments by 1
/// - versionName: format 1.0.x where x = versionCode / 10 (integer division)
/// - versionNameSuffix: versionCode % 10 (remainder)
/// 
/// Example:
/// - versionCode = 28
/// - versionName = 1.0.2 (28 / 10 = 2)
/// - versionNameSuffix = +8 (28 % 10 = 8)

void main() {
  final propertiesFile = File('android.properties');
  
  if (!propertiesFile.existsSync()) {
    print('❌ Error: android.properties not found!');
    print('   Please make sure you are running this script from the project root.');
    exit(1);
  }

  // Read current properties
  final lines = propertiesFile.readAsLinesSync();
  final properties = <String, String>{};
  
  int? currentVersionCode;
  String? currentVersionName;
  String? oldVersionNameSuffix;
  
  // Parse properties file to get current values
  for (final line in lines) {
    final trimmedLine = line.trim();
    
    // Parse key=value pairs
    if (trimmedLine.contains('=') && !trimmedLine.startsWith('#')) {
      final parts = trimmedLine.split('=');
      if (parts.length >= 2) {
        final key = parts[0].trim();
        final value = parts.sublist(1).join('=').trim();
        properties[key] = value;
        
        // Track versionCode and versionName
        if (key == 'app.versionCode') {
          currentVersionCode = int.tryParse(value);
        } else if (key == 'app.versionName') {
          currentVersionName = value;
        } else if (key == 'app.versionNameSuffix') {
          oldVersionNameSuffix = value;
        }
      }
    }
  }
  
  // Validate current versionCode
  if (currentVersionCode == null) {
    print('❌ Error: app.versionCode not found in android.properties!');
    exit(1);
  }
  
  // Calculate new version (always bump)
  final newVersionCode = currentVersionCode + 1;
  final versionNameX = newVersionCode ~/ 10; // Integer division
  final versionNameSuffix = newVersionCode % 10; // Remainder
  
  // Parse current versionName to get base (e.g., "1.0" from "1.0.1")
  String newVersionName;
  if (currentVersionName != null && currentVersionName.contains('.')) {
    final parts = currentVersionName.split('.');
    if (parts.length >= 2) {
      // Keep first two parts (e.g., "1.0") and replace the rest with calculated x
      newVersionName = '${parts[0]}.${parts[1]}.$versionNameX';
    } else {
      newVersionName = '1.0.$versionNameX';
    }
  } else {
    newVersionName = '1.0.$versionNameX';
  }
  
  final newVersionNameSuffix = '+$versionNameSuffix';
  
  // Write back to file, preserving format
  final output = StringBuffer();
  for (final line in lines) {
    final trimmedLine = line.trim();
    
    // Keep comments and empty lines as-is
    if (trimmedLine.isEmpty || trimmedLine.startsWith('#')) {
      output.writeln(line);
      continue;
    }
    
    // Update version-related properties
    if (trimmedLine.contains('=')) {
      final key = trimmedLine.split('=')[0].trim();
      
      if (key == 'app.versionCode') {
        output.writeln('app.versionCode=$newVersionCode');
      } else if (key == 'app.versionName') {
        output.writeln('app.versionName=$newVersionName');
      } else if (key == 'app.versionNameSuffix') {
        output.writeln('app.versionNameSuffix=$newVersionNameSuffix');
      } else {
        output.writeln(line);
      }
    } else {
      output.writeln(line);
    }
  }
  
  propertiesFile.writeAsStringSync(output.toString());
  
  // Print summary
  print('✅ Version bumped successfully!');
  print('');
  print('📊 Version Summary:');
  print('   versionCode:       $currentVersionCode → $newVersionCode');
  print('   versionName:       $currentVersionName → $newVersionName');
  print('   versionNameSuffix: $oldVersionNameSuffix → $newVersionNameSuffix');
  print('');
  print('📝 Updated android.properties');
}

