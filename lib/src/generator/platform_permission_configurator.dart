import 'dart:io';
import 'package:path/path.dart' as p;

import '../models/project_config.dart';

/// Configures platform-specific permissions (Android, iOS, macOS)
/// for packages requiring native manifests, plists, entitlements, or Podfile flags.
class PlatformPermissionConfigurator {
  /// Creates a new [PlatformPermissionConfigurator].
  const PlatformPermissionConfigurator();

  /// Applies platform permissions to native project files in [targetDirectory].
  void applyPermissions(String targetDirectory, ProjectConfig config) {
    _configureAndroid(targetDirectory, config);
    _configureIos(targetDirectory, config);
    _configureMacOs(targetDirectory, config);
  }

  void _configureAndroid(String targetDirectory, ProjectConfig config) {
    final manifestFile = File(
      p.join(
        targetDirectory,
        'android',
        'app',
        'src',
        'main',
        'AndroidManifest.xml',
      ),
    );
    if (!manifestFile.existsSync()) return;

    final content = manifestFile.readAsStringSync();
    final updated = updateAndroidManifest(content, config);
    if (updated != content) {
      manifestFile.writeAsStringSync(updated);
    }
  }

  void _configureIos(String targetDirectory, ProjectConfig config) {
    final iosDir = p.join(targetDirectory, 'ios');
    if (!Directory(iosDir).existsSync()) return;

    final plistFile = File(p.join(iosDir, 'Runner', 'Info.plist'));
    if (plistFile.existsSync()) {
      final content = plistFile.readAsStringSync();
      final updated = updateIosInfoPlist(content, config);
      if (updated != content) {
        plistFile.writeAsStringSync(updated);
      }
    }

    if (config.hasPermissionHandler) {
      final podfile = File(p.join(iosDir, 'Podfile'));
      if (podfile.existsSync()) {
        final content = podfile.readAsStringSync();
        final updated = updateIosPodfile(content, config);
        if (updated != content) {
          podfile.writeAsStringSync(updated);
        }
      } else {
        podfile.writeAsStringSync(renderDefaultIosPodfile(config));
      }
    }
  }

  void _configureMacOs(String targetDirectory, ProjectConfig config) {
    final macosDir = p.join(targetDirectory, 'macos', 'Runner');
    if (!Directory(macosDir).existsSync()) return;

    for (final fileName in [
      'DebugProfile.entitlements',
      'Release.entitlements',
    ]) {
      final file = File(p.join(macosDir, fileName));
      if (file.existsSync()) {
        final content = file.readAsStringSync();
        final updated = updateMacOsEntitlements(content, config);
        if (updated != content) {
          file.writeAsStringSync(updated);
        }
      }
    }

    final plistFile = File(p.join(macosDir, 'Info.plist'));
    if (plistFile.existsSync()) {
      final content = plistFile.readAsStringSync();
      final updated = updateIosInfoPlist(content, config);
      if (updated != content) {
        plistFile.writeAsStringSync(updated);
      }
    }
  }

  /// Injects required `<uses-permission>` and `<queries>` tags into AndroidManifest.xml.
  String updateAndroidManifest(String content, ProjectConfig config) {
    var result = content;
    final permissionsToAdd = <String>[];

    // 1. Networking (dio, http, or cached_network_image)
    if (config.networking != Networking.none || config.hasCachedNetworkImage) {
      _addIfMissing(
        permissionsToAdd,
        result,
        '<uses-permission android:name="android.permission.INTERNET" />',
      );
      _addIfMissing(
        permissionsToAdd,
        result,
        '<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />',
      );
    }

    // 2. Camera & Photos & Video
    if (config.hasImagePicker) {
      _addIfMissing(
        permissionsToAdd,
        result,
        '<uses-permission android:name="android.permission.CAMERA" />',
      );
      _addIfMissing(
        permissionsToAdd,
        result,
        '<uses-permission android:name="android.permission.RECORD_AUDIO" />',
      );
      _addIfMissing(
        permissionsToAdd,
        result,
        '<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />',
      );
      _addIfMissing(
        permissionsToAdd,
        result,
        '<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />',
      );
      _addIfMissing(
        permissionsToAdd,
        result,
        '<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />',
      );
    }

    // 3. File Picker
    if (config.hasFilePicker) {
      _addIfMissing(
        permissionsToAdd,
        result,
        '<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" android:maxSdkVersion="32" />',
      );
    }

    // 4. Notifications (permission_handler)
    if (config.hasPermissionHandler) {
      _addIfMissing(
        permissionsToAdd,
        result,
        '<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />',
      );
    }

    // Inject permissions before <application
    if (permissionsToAdd.isNotEmpty) {
      final appIndex = result.indexOf('<application');
      if (appIndex != -1) {
        final buffer = StringBuffer()..write(result.substring(0, appIndex));
        for (final perm in permissionsToAdd) {
          buffer.writeln('    $perm');
        }
        buffer.write(result.substring(appIndex));
        result = buffer.toString();
      } else {
        final manifestEndIndex = result.indexOf('>');
        if (manifestEndIndex != -1) {
          final buffer = StringBuffer()
            ..writeln(result.substring(0, manifestEndIndex + 1));
          for (final perm in permissionsToAdd) {
            buffer.writeln('    $perm');
          }
          buffer.write(result.substring(manifestEndIndex + 1));
          result = buffer.toString();
        }
      }
    }

    // 5. URL Launcher Queries (Android 11+ Package Visibility)
    if (config.utilities.contains(UtilityPackage.urlLauncher)) {
      result = _injectUrlLauncherQueries(result);
    }

    return result;
  }

  String _injectUrlLauncherQueries(String content) {
    const urlLauncherIntents = [
      '<intent>\n            <action android:name="android.intent.action.VIEW" />\n            <data android:scheme="https" />\n        </intent>',
      '<intent>\n            <action android:name="android.intent.action.VIEW" />\n            <data android:scheme="http" />\n        </intent>',
      '<intent>\n            <action android:name="android.intent.action.DIAL" />\n            <data android:scheme="tel" />\n        </intent>',
      '<intent>\n            <action android:name="android.intent.action.SENDTO" />\n            <data android:scheme="mailto" />\n        </intent>',
      '<intent>\n            <action android:name="android.intent.action.SENDTO" />\n            <data android:scheme="sms" />\n        </intent>',
    ];

    final missingIntents = <String>[];
    for (final intent in urlLauncherIntents) {
      final schemeMatch = RegExp(
        r'android:scheme="([^"]+)"',
      ).firstMatch(intent);
      if (schemeMatch != null) {
        final scheme = schemeMatch.group(1)!;
        if (!content.contains('android:scheme="$scheme"')) {
          missingIntents.add(intent);
        }
      }
    }

    if (missingIntents.isEmpty) return content;

    final queriesCloseIndex = content.lastIndexOf('</queries>');
    if (queriesCloseIndex != -1) {
      final buffer = StringBuffer()
        ..write(content.substring(0, queriesCloseIndex));
      for (final intent in missingIntents) {
        buffer.writeln('        $intent');
      }
      buffer.write(content.substring(queriesCloseIndex));
      return buffer.toString();
    }

    // If no <queries> block exists, insert one before </manifest>
    final manifestCloseIndex = content.lastIndexOf('</manifest>');
    if (manifestCloseIndex != -1) {
      final buffer = StringBuffer()
        ..write(content.substring(0, manifestCloseIndex))
        ..writeln('    <queries>');
      for (final intent in missingIntents) {
        buffer.writeln('        $intent');
      }
      buffer
        ..writeln('    </queries>')
        ..write(content.substring(manifestCloseIndex));
      return buffer.toString();
    }

    return content;
  }

  /// Injects keys into iOS or macOS Info.plist.
  String updateIosInfoPlist(String content, ProjectConfig config) {
    final entriesToAdd = <String>[];

    // Image Picker & Camera
    if (config.hasImagePicker || config.hasPermissionHandler) {
      if (!content.contains('NSCameraUsageDescription')) {
        entriesToAdd.add(
          '	<key>NSCameraUsageDescription</key>\n'
          '	<string>Used to take photos and record videos directly within the app.</string>',
        );
      }
      if (!content.contains('NSPhotoLibraryUsageDescription')) {
        entriesToAdd.add(
          '	<key>NSPhotoLibraryUsageDescription</key>\n'
          '	<string>Used to select photos and videos from your photo library.</string>',
        );
      }
      if (!content.contains('NSMicrophoneUsageDescription')) {
        entriesToAdd.add(
          '	<key>NSMicrophoneUsageDescription</key>\n'
          '	<string>Used to record audio when capturing videos within the app.</string>',
        );
      }
    }

    // File Picker
    if (config.hasFilePicker) {
      if (!content.contains('NSPhotoLibraryUsageDescription') &&
          !entriesToAdd.any(
            (e) => e.contains('NSPhotoLibraryUsageDescription'),
          )) {
        entriesToAdd.add(
          '	<key>NSPhotoLibraryUsageDescription</key>\n'
          '	<string>Used to select documents and media files.</string>',
        );
      }
      if (!content.contains('UIFileSharingEnabled')) {
        entriesToAdd.add(
          '	<key>UIFileSharingEnabled</key>\n'
          '	<true/>',
        );
      }
      if (!content.contains('LSSupportsOpeningDocumentsInPlace')) {
        entriesToAdd.add(
          '	<key>LSSupportsOpeningDocumentsInPlace</key>\n'
          '	<true/>',
        );
      }
    }

    // URL Launcher (LSApplicationQueriesSchemes)
    if (config.utilities.contains(UtilityPackage.urlLauncher)) {
      if (!content.contains('LSApplicationQueriesSchemes')) {
        entriesToAdd.add(
          '	<key>LSApplicationQueriesSchemes</key>\n'
          '	<array>\n'
          '		<string>https</string>\n'
          '		<string>http</string>\n'
          '		<string>tel</string>\n'
          '		<string>mailto</string>\n'
          '		<string>sms</string>\n'
          '	</array>',
        );
      }
    }

    if (entriesToAdd.isEmpty) return content;

    final dictEndIndex = content.lastIndexOf('</dict>');
    if (dictEndIndex != -1) {
      final buffer = StringBuffer()..write(content.substring(0, dictEndIndex));
      for (final entry in entriesToAdd) {
        buffer.writeln(entry);
      }
      buffer.write(content.substring(dictEndIndex));
      return buffer.toString();
    }

    return content;
  }

  /// Injects security keys into macOS .entitlements.
  String updateMacOsEntitlements(String content, ProjectConfig config) {
    final entriesToAdd = <String>[];

    // File Picker
    if (config.hasFilePicker) {
      if (!content.contains(
        'com.apple.security.files.user-selected.read-write',
      )) {
        entriesToAdd.add(
          '	<key>com.apple.security.files.user-selected.read-write</key>\n'
          '	<true/>',
        );
      }
      if (!content.contains('com.apple.security.files.bookmarks.app-scope')) {
        entriesToAdd.add(
          '	<key>com.apple.security.files.bookmarks.app-scope</key>\n'
          '	<true/>',
        );
      }
    }

    // Camera & Microphone
    if (config.hasImagePicker || config.hasPermissionHandler) {
      if (!content.contains('com.apple.security.device.camera')) {
        entriesToAdd.add(
          '	<key>com.apple.security.device.camera</key>\n'
          '	<true/>',
        );
      }
      if (!content.contains('com.apple.security.device.microphone')) {
        entriesToAdd.add(
          '	<key>com.apple.security.device.microphone</key>\n'
          '	<true/>',
        );
      }
    }

    // Networking & Cached Network Image
    if (config.networking != Networking.none || config.hasCachedNetworkImage) {
      if (!content.contains('com.apple.security.network.client')) {
        entriesToAdd.add(
          '	<key>com.apple.security.network.client</key>\n'
          '	<true/>',
        );
      }
    }

    // Flutter Secure Storage (macOS Keychain Access)
    if (config.utilities.contains(UtilityPackage.flutterSecureStorage)) {
      if (!content.contains('keychain-access-groups')) {
        entriesToAdd.add(
          '	<key>keychain-access-groups</key>\n'
          '	<array/>',
        );
      }
    }

    if (entriesToAdd.isEmpty) return content;

    final dictEndIndex = content.lastIndexOf('</dict>');
    if (dictEndIndex != -1) {
      final buffer = StringBuffer()..write(content.substring(0, dictEndIndex));
      for (final entry in entriesToAdd) {
        buffer.writeln(entry);
      }
      buffer.write(content.substring(dictEndIndex));
      return buffer.toString();
    }

    return content;
  }

  /// Updates existing iOS Podfile to configure preprocessor definitions for permission_handler.
  String updateIosPodfile(String content, ProjectConfig config) {
    if (!config.hasPermissionHandler) return content;
    if (content.contains('PERMISSION_CAMERA=1')) return content;

    const permissionFlags = '''
        target.build_configurations.each do |config|
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
            '\$(inherited)',
            'PERMISSION_CAMERA=1',
            'PERMISSION_PHOTOS=1',
            'PERMISSION_MICROPHONE=1',
            'PERMISSION_NOTIFICATIONS=1',
          ]
        end''';

    if (content.contains('flutter_additional_ios_build_settings(target)')) {
      return content.replaceFirst(
        'flutter_additional_ios_build_settings(target)',
        'flutter_additional_ios_build_settings(target)\n$permissionFlags',
      );
    }

    return content;
  }

  /// Renders default iOS Podfile with permission_handler build settings preconfigured.
  String renderDefaultIosPodfile(ProjectConfig config) {
    return '''
platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

project 'Runner', {
  'Debug' => :debug,
  'Profile' => :release,
  'Release' => :release,
}

def flutter_root
  generated_xcode_build_settings_path = File.expand_path(File.join('..', 'Flutter', 'Generated.xcconfig'), __FILE__)
  unless File.exist?(generated_xcode_build_settings_path)
    raise "#{generated_xcode_build_settings_path} must exist. If you're running pod install manually, make sure flutter pub get has executed first"
  end

  File.foreach(generated_xcode_build_settings_path) do |line|
    matches = line.match(/FLUTTER_ROOT\\=(.*)/)
    return matches[1].strip if matches
  end
  raise "FLUTTER_ROOT not found in #{generated_xcode_build_settings_path}. Try deleting Generated.xcconfig, then run flutter pub get"
end

require File.expand_path(File.join('packages', 'flutter_tools', 'bin', 'podhelper'), flutter_root)

flutter_ios_podfile_setup

target 'Runner' do
  use_frameworks!
  use_modular_headers!

  flutter_install_all_ios_pods File.dirname(File.realpath(__FILE__))
  target 'RunnerTests' do
    inherit! :search_paths
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
    target.build_configurations.each do |config|
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '\$(inherited)',
        'PERMISSION_CAMERA=1',
        'PERMISSION_PHOTOS=1',
        'PERMISSION_MICROPHONE=1',
        'PERMISSION_NOTIFICATIONS=1',
      ]
    end
  end
end
''';
  }

  void _addIfMissing(List<String> list, String content, String tag) {
    final nameMatch = RegExp(r'android:name="([^"]+)"').firstMatch(tag);
    if (nameMatch != null) {
      final permName = nameMatch.group(1)!;
      if (content.contains(permName) || list.any((p) => p.contains(permName))) {
        return;
      }
    }
    list.add(tag);
  }
}
