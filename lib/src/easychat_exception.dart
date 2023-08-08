class EasyChatException implements Exception {
  late final String code;
  late final String message;

  EasyChatException(this.code, this.message);

  @override
  String toString() {
    return "EasyChatException: $code: $message";
  }
}
