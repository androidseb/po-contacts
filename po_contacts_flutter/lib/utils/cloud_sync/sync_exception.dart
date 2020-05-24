enum SyncExceptionType {
  AUTHENTICATION,
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
