import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

class LoggerUtility {
  LoggerUtility._();

  // TODO: check or improve
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 1,
      // Number of method calls to show
      errorMethodCount: 5,
      // Stacktrace lines for errors
      lineLength: 200,
      // Width of log lines
      colors: true,
      // Colored output
      printEmojis: true, // Emojis for log levels
    ),
    filter: _LogFilter(), // Disable logs in release mode
  );

  /// Debug logs (used for dev info)
  static void d(
    String tag,
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.d('[$tag] $message', error: error, stackTrace: stackTrace);
  }

  /// Info logs (important but not errors)
  static void i(
    String tag,
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.i('[$tag] $message', error: error, stackTrace: stackTrace);
  }

  /// Warning logs
  static void w(
    String tag,
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.w('[$tag] $message', error: error, stackTrace: stackTrace);
  }

  /// Error logs
  static void e(
    String tag,
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.e('[$tag] $message', error: error, stackTrace: stackTrace);
  }

  /// Verbose logs (for deep debugging)
  static void v(
    String tag,
    dynamic message, [
    dynamic error,
    StackTrace? stackTrace,
  ]) {
    _logger.log(
      Level.trace,
      "[$tag] $message",
      error: error,
      stackTrace: stackTrace,
    );
  }
}

class _LogFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) {
    // return true if logs in release mode will be allowed
    return kDebugMode || kProfileMode;
  }
}
