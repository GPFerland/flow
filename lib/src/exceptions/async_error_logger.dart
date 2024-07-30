import 'package:flow/src/exceptions/app_exception.dart';
import 'package:flow/src/exceptions/error_logger.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Error logger class to keep track of all AsyncError states that are set
/// by the controllers in the app
class AsyncErrorLogger extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    final errorLogger = container.read(errorLoggerProvider);
    final error = _findError(newValue);
    if (error != null) {
      if (error.error is AppException) {
        errorLogger.logAppException(error.error as AppException);
      } else {
        errorLogger.logError(error.error, error.stackTrace);
      }
    }
  }

  AsyncError<dynamic>? _findError(Object? value) {
    if (value is AsyncError) {
      return value;
    } else {
      return null;
    }
  }
}
