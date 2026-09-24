import '../../l10n/app_localizations.dart';
import 'app_exception.dart';

String localizedAppException(AppLocalizations l10n, AppException error) {
  switch (error.message) {
    case 'allowPhotoAccess':
      return l10n.allowPhotoAccess;
    case 'allowCameraAccess':
      return l10n.allowCameraAccess;
    case 'emptyImage':
    case 'The selected image is empty.':
      return l10n.emptyImage;
    case 'This image is too large. Please choose a smaller file.':
      return l10n.fileTooLarge;
    case 'Please select a JPG, PNG, or WEBP image.':
    case 'The selected image could not be found.':
      return l10n.unsupportedImageBody;
    case 'Please enter a valid image URL.':
      return l10n.invalidUrl;
    case 'Please check your connection and try again.':
      return l10n.noInternetBody;
    case 'Search service is temporarily unavailable.':
      return l10n.serviceUnavailableTitle;
    case 'Search limit reached.':
      return l10n.rateLimitTitle;
    case 'Please select an image first.':
      return l10n.searchUsingImage;
    default:
      switch (error.code) {
        case AppErrorCode.network:
          return l10n.noInternetBody;
        case AppErrorCode.rateLimit:
          return l10n.rateLimitBody;
        case AppErrorCode.invalidImage:
          return l10n.unsupportedImageBody;
        case AppErrorCode.unavailable:
          return l10n.serviceUnavailableBody;
        default:
          return error.message.isEmpty ? l10n.searchFailedBody : error.message;
      }
  }
}
