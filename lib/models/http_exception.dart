class HttpException implements Exception {
  final String message;

  HttpException({required this.message});

  @override
  String toString() => message;
}
