import 'dart:io';

import '../constants/app_constants.dart';
import '../errors/app_exception.dart';

class ImageValidator {
  ImageValidator._();

  static AppException? validateFile(File file) {
    if (!file.existsSync()) {
      return const AppException(
        code: AppErrorCode.invalidImage,
        message: 'The selected image could not be found.',
      );
    }

    final length = file.lengthSync();
    if (length <= 0) {
      return const AppException(
        code: AppErrorCode.invalidImage,
        message: 'The selected image is empty.',
      );
    }
    if (length > AppConstants.maxImageBytes) {
      return const AppException(
        code: AppErrorCode.invalidImage,
        message: 'This image is too large. Please choose a smaller file.',
      );
    }

    final ext = file.path.split('.').last.toLowerCase();
    if (!AppConstants.supportedImageExtensions.contains(ext)) {
      return const AppException(
        code: AppErrorCode.invalidImage,
        message: 'Please select a JPG, PNG, or WEBP image.',
      );
    }
    return null;
  }

  static bool isSupportedExtension(String path) {
    final ext = path.split('.').last.toLowerCase();
    return AppConstants.supportedImageExtensions.contains(ext);
  }
}
