/// Generates camera and image picker service.
String renderImagePickerService() {
  return '''
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

/// Production-ready service providing camera capture and photo gallery picking.
class ImagePickerService {
  ImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// Captures a photo using the device camera.
  Future<File?> takePhoto({
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        preferredCameraDevice: preferredCameraDevice,
      );
      return xFile != null ? File(xFile.path) : null;
    } on Exception catch (e, stackTrace) {
      debugPrint('ImagePickerService.takePhoto failed: \$e\\n\$stackTrace');
      return null;
    }
  }

  /// Selects an image from the photo gallery.
  Future<File?> pickImageFromGallery({
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
  }) async {
    try {
      final xFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
      );
      return xFile != null ? File(xFile.path) : null;
    } on Exception catch (e, stackTrace) {
      debugPrint(
        'ImagePickerService.pickImageFromGallery failed: \$e\\n\$stackTrace',
      );
      return null;
    }
  }

  /// Selects multiple images from the photo gallery.
  Future<List<File>> pickMultiImage({
    int? imageQuality,
    double? maxWidth,
    double? maxHeight,
    int? limit,
  }) async {
    try {
      final xFiles = await _picker.pickMultiImage(
        imageQuality: imageQuality,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        limit: limit,
      );
      return xFiles.map((x) => File(x.path)).toList();
    } on Exception catch (e, stackTrace) {
      debugPrint('ImagePickerService.pickMultiImage failed: \$e\\n\$stackTrace');
      return [];
    }
  }

  /// Records a video using the device camera.
  Future<File?> recordVideo({
    Duration? maxDuration,
    CameraDevice preferredCameraDevice = CameraDevice.rear,
  }) async {
    try {
      final xFile = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: maxDuration,
        preferredCameraDevice: preferredCameraDevice,
      );
      return xFile != null ? File(xFile.path) : null;
    } on Exception catch (e, stackTrace) {
      debugPrint('ImagePickerService.recordVideo failed: \$e\\n\$stackTrace');
      return null;
    }
  }

  /// Selects a video from the media gallery.
  Future<File?> pickVideoFromGallery() async {
    try {
      final xFile = await _picker.pickVideo(
        source: ImageSource.gallery,
      );
      return xFile != null ? File(xFile.path) : null;
    } on Exception catch (e, stackTrace) {
      debugPrint(
        'ImagePickerService.pickVideoFromGallery failed: \$e\\n\$stackTrace',
      );
      return null;
    }
  }
}
''';
}

/// Generates cross-platform file and document picker service.
String renderFilePickerService() {
  return '''
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// Production-ready service providing native file and document selection.
class FilePickerService {
  FilePickerService({FilePicker? picker}) : _picker = picker ?? FilePicker.platform;

  final FilePicker _picker;

  /// Picks a single file from device storage.
  ///
  /// Set [type] to [FileType.custom] and specify [allowedExtensions]
  /// (e.g. `['pdf', 'docx']`) to restrict file types.
  Future<File?> pickFile({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await _picker.pickFiles(
        type: type,
        allowedExtensions: allowedExtensions,
      );
      final path = result?.files.single.path;
      return path != null ? File(path) : null;
    } on Exception catch (e, stackTrace) {
      debugPrint('FilePickerService.pickFile failed: \$e\\n\$stackTrace');
      return null;
    }
  }

  /// Picks multiple files from device storage.
  Future<List<File>> pickMultipleFiles({
    FileType type = FileType.any,
    List<String>? allowedExtensions,
  }) async {
    try {
      final result = await _picker.pickFiles(
        allowMultiple: true,
        type: type,
        allowedExtensions: allowedExtensions,
      );
      if (result == null) return [];
      return result.paths.whereType<String>().map(File.new).toList();
    } on Exception catch (e, stackTrace) {
      debugPrint('FilePickerService.pickMultipleFiles failed: \$e\\n\$stackTrace');
      return [];
    }
  }

  /// Convenience method to pick a PDF document.
  Future<File?> pickPdf() => pickFile(
        type: FileType.custom,
        allowedExtensions: const ['pdf'],
      );

  /// Picks a directory from device storage.
  Future<String?> pickDirectory() async {
    try {
      return await _picker.getDirectoryPath();
    } on Exception catch (e, stackTrace) {
      debugPrint('FilePickerService.pickDirectory failed: \$e\\n\$stackTrace');
      return null;
    }
  }
}
''';
}

/// Generates cross-platform location and GPS service using geolocator.
String renderLocationService() {
  return '''
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

/// Service providing device location, distance calculations, and permission checks.
class LocationService {
  const LocationService();

  /// Determines the current position of the device.
  ///
  /// Requests location permissions if not yet granted.
  Future<Position?> getCurrentPosition({
    LocationAccuracy desiredAccuracy = LocationAccuracy.high,
  }) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        debugPrint('Location services are disabled.');
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied');
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        debugPrint('Location permissions are permanently denied.');
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(accuracy: desiredAccuracy),
      );
    } on Exception catch (e, stackTrace) {
      debugPrint('LocationService.getCurrentPosition failed: \$e\\n\$stackTrace');
      return null;
    }
  }

  /// Calculates distance in meters between two geographical coordinates.
  double distanceBetween({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  /// Listens to location changes continuously.
  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 10,
  }) {
    return Geolocator.getPositionStream(
      locationSettings: LocationSettings(
        accuracy: accuracy,
        distanceFilter: distanceFilter,
      ),
    );
  }
}
''';
}
