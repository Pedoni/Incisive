final class IncisiveException implements Exception {
  final String message;

  const IncisiveException(this.message);

  @override
  String toString() => message;
}
