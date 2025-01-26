class AppExceptions implements Exception {
  final String message;
  final String? code;

  AppExceptions(this.message, {this.code});

  @override
  String toString() {
    return 'AppExceptions{message: $message, code: $code}';
  }
}
