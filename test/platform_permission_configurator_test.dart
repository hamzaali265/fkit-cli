import 'package:fkit_cli/fkit_cli.dart';
import 'package:test/test.dart';

void main() {
  const configurator = PlatformPermissionConfigurator();

  group('PlatformPermissionConfigurator', () {
    const sampleAndroidManifest = '''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <application
        android:label="test_app"
        android:name="\${applicationName}">
    </application>
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
    </queries>
</manifest>''';

    const sampleIosInfoPlist = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleName</key>
	<string>test_app</string>
</dict>
</plist>''';

    const sampleMacOsEntitlements = '''
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
</dict>
</plist>''';

    test(
      'updates AndroidManifest with networking, camera, and picker permissions',
      () {
        final config = ProjectConfig(
          projectName: 'pickers_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/pickers_app',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.bloc,
          routing: Routing.goRouter,
          networking: Networking.dio,
          storage: Storage.none,
          features: {},
          utilities: {UtilityPackage.imagePicker, UtilityPackage.filePicker},
        );

        final updated = configurator.updateAndroidManifest(
          sampleAndroidManifest,
          config,
        );

        expect(updated, contains('android.permission.INTERNET'));
        expect(updated, contains('android.permission.ACCESS_NETWORK_STATE'));
        expect(updated, contains('android.permission.CAMERA'));
        expect(updated, contains('android.permission.RECORD_AUDIO'));
        expect(updated, contains('android.permission.READ_MEDIA_IMAGES'));
        expect(updated, contains('android.permission.READ_MEDIA_VIDEO'));
        expect(updated, contains('android.permission.READ_EXTERNAL_STORAGE'));
        expect(
          updated.indexOf('android.permission.CAMERA'),
          lessThan(updated.indexOf('<application')),
        );
      },
    );

    test('avoids duplicating permissions in AndroidManifest', () {
      const manifestWithInternet = '''
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET" />
    <application
        android:label="test_app">
    </application>
</manifest>''';

      final config = ProjectConfig(
        projectName: 'net_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/net_app',
        architecture: ArchitecturePattern.simpleMvc,
        stateManagement: StateManagement.none,
        routing: Routing.standard,
        networking: Networking.dio,
        storage: Storage.none,
        features: {},
      );

      final updated = configurator.updateAndroidManifest(
        manifestWithInternet,
        config,
      );

      final matches = RegExp('android.permission.INTERNET').allMatches(updated);
      expect(matches.length, equals(1));
    });

    test('injects url_launcher queries into AndroidManifest', () {
      final config = ProjectConfig(
        projectName: 'launcher_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/launcher_app',
        architecture: ArchitecturePattern.featureFirst,
        stateManagement: StateManagement.bloc,
        routing: Routing.goRouter,
        networking: Networking.none,
        storage: Storage.none,
        features: {},
        utilities: {UtilityPackage.urlLauncher},
      );

      final updated = configurator.updateAndroidManifest(
        sampleAndroidManifest,
        config,
      );

      expect(updated, contains('android:scheme="https"'));
      expect(updated, contains('android:scheme="http"'));
      expect(updated, contains('android:scheme="tel"'));
      expect(updated, contains('android:scheme="mailto"'));
      expect(updated, contains('android:scheme="sms"'));
    });

    test(
      'injects POST_NOTIFICATIONS for permission_handler in AndroidManifest',
      () {
        final config = ProjectConfig(
          projectName: 'perm_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/perm_app',
          architecture: ArchitecturePattern.mvvm,
          stateManagement: StateManagement.riverpod,
          routing: Routing.standard,
          networking: Networking.none,
          storage: Storage.none,
          features: {},
          utilities: {UtilityPackage.permissionHandler},
        );

        final updated = configurator.updateAndroidManifest(
          sampleAndroidManifest,
          config,
        );

        expect(updated, contains('android.permission.POST_NOTIFICATIONS'));
      },
    );

    test(
      'adds INTERNET permission for cached_network_image even when networking is none',
      () {
        final config = ProjectConfig(
          projectName: 'image_only_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/image_only_app',
          architecture: ArchitecturePattern.simpleMvc,
          stateManagement: StateManagement.none,
          routing: Routing.standard,
          networking: Networking.none,
          storage: Storage.none,
          features: {},
          utilities: {UtilityPackage.cachedNetworkImage},
        );

        final updatedManifest = configurator.updateAndroidManifest(
          sampleAndroidManifest,
          config,
        );
        final updatedEntitlements = configurator.updateMacOsEntitlements(
          sampleMacOsEntitlements,
          config,
        );

        expect(updatedManifest, contains('android.permission.INTERNET'));
        expect(
          updatedManifest,
          contains('android.permission.ACCESS_NETWORK_STATE'),
        );
        expect(
          updatedEntitlements,
          contains('com.apple.security.network.client'),
        );
      },
    );

    test(
      'updates iOS Info.plist with image_picker, file_picker, and url_launcher',
      () {
        final config = ProjectConfig(
          projectName: 'ios_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/ios_app',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.bloc,
          routing: Routing.goRouter,
          networking: Networking.dio,
          storage: Storage.none,
          features: {},
          utilities: {
            UtilityPackage.imagePicker,
            UtilityPackage.filePicker,
            UtilityPackage.urlLauncher,
          },
        );

        final updated = configurator.updateIosInfoPlist(
          sampleIosInfoPlist,
          config,
        );

        expect(updated, contains('<key>NSCameraUsageDescription</key>'));
        expect(updated, contains('<key>NSPhotoLibraryUsageDescription</key>'));
        expect(updated, contains('<key>NSMicrophoneUsageDescription</key>'));
        expect(updated, contains('<key>UIFileSharingEnabled</key>'));
        expect(
          updated,
          contains('<key>LSSupportsOpeningDocumentsInPlace</key>'),
        );
        expect(updated, contains('<key>LSApplicationQueriesSchemes</key>'));
        expect(updated, contains('<string>https</string>'));
        expect(updated, contains('<string>tel</string>'));
      },
    );

    test(
      'updates macOS entitlements with file picker, camera, secure storage, and network',
      () {
        final config = ProjectConfig(
          projectName: 'desktop_app',
          orgName: 'com.example',
          targetDirectory: '/tmp/desktop_app',
          architecture: ArchitecturePattern.featureFirst,
          stateManagement: StateManagement.bloc,
          routing: Routing.goRouter,
          networking: Networking.dio,
          storage: Storage.none,
          features: {},
          utilities: {
            UtilityPackage.imagePicker,
            UtilityPackage.filePicker,
            UtilityPackage.flutterSecureStorage,
          },
        );

        final updated = configurator.updateMacOsEntitlements(
          sampleMacOsEntitlements,
          config,
        );

        expect(
          updated,
          contains('com.apple.security.files.user-selected.read-write'),
        );
        expect(
          updated,
          contains('com.apple.security.files.bookmarks.app-scope'),
        );
        expect(updated, contains('com.apple.security.device.camera'));
        expect(updated, contains('com.apple.security.device.microphone'));
        expect(updated, contains('com.apple.security.network.client'));
        expect(updated, contains('keychain-access-groups'));
      },
    );

    test('configures iOS Podfile build settings for permission_handler', () {
      final config = ProjectConfig(
        projectName: 'pod_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/pod_app',
        architecture: ArchitecturePattern.featureFirst,
        stateManagement: StateManagement.bloc,
        routing: Routing.goRouter,
        networking: Networking.none,
        storage: Storage.none,
        features: {},
        utilities: {UtilityPackage.permissionHandler},
      );

      const samplePodfile = '''
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
  end
end''';

      final updated = configurator.updateIosPodfile(samplePodfile, config);
      expect(updated, contains('PERMISSION_CAMERA=1'));
      expect(updated, contains('PERMISSION_PHOTOS=1'));
      expect(updated, contains('PERMISSION_NOTIFICATIONS=1'));

      final defaultPodfile = configurator.renderDefaultIosPodfile(config);
      expect(defaultPodfile, contains('PERMISSION_CAMERA=1'));
      expect(defaultPodfile, contains('flutter_install_all_ios_pods'));
    });

    test('configures geolocator and webview permissions across platforms', () {
      final config = ProjectConfig(
        projectName: 'geo_web_app',
        orgName: 'com.example',
        targetDirectory: '/tmp/geo_web_app',
        architecture: ArchitecturePattern.featureFirst,
        stateManagement: StateManagement.bloc,
        routing: Routing.goRouter,
        networking: Networking.none,
        storage: Storage.none,
        features: const {},
        utilities: {UtilityPackage.geolocator, UtilityPackage.webviewFlutter},
      );

      final androidManifest = configurator.updateAndroidManifest(
        sampleAndroidManifest,
        config,
      );
      expect(
        androidManifest,
        contains('android.permission.ACCESS_FINE_LOCATION'),
      );
      expect(
        androidManifest,
        contains('android.permission.ACCESS_COARSE_LOCATION'),
      );
      expect(androidManifest, contains('android.permission.INTERNET'));

      final iosPlist = configurator.updateIosInfoPlist(
        sampleIosInfoPlist,
        config,
      );
      expect(iosPlist, contains('NSLocationWhenInUseUsageDescription'));
      expect(
        iosPlist,
        contains('NSLocationAlwaysAndWhenInUseUsageDescription'),
      );

      final macosEntitlements = configurator.updateMacOsEntitlements(
        sampleMacOsEntitlements,
        config,
      );
      expect(
        macosEntitlements,
        contains('com.apple.security.personal-information.location'),
      );
      expect(macosEntitlements, contains('com.apple.security.network.client'));
    });
  });
}
