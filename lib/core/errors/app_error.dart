import 'package:pump/core/enums/app_error_code.dart';

class AppError {
  final String message;
  final AppErrorCode? code;

  AppError({required this.message, this.code});

  @override
  String toString() {
    return 'AppError{message: $message, code: $code}';
  }
}
