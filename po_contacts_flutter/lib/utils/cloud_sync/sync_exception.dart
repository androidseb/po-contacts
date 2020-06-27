enum SyncExceptionType {
  AUTHENTICATION,
  FILE_PARSING_ERROR,
  NETWORK,
  SERVER,
  CONCURRENCY,
  CANCELED,
  OTHER,
}

class SyncException implements Exception {
  final SyncExceptionType type;
  final String message;

  SyncException(this.type, {this.message});
}
