//TODO make all enums upper case
enum SyncExceptionType {
  authentication,
  network,
  server,
  concurrency,
  canceled,
  other,
}

class SyncException implements Exception {
  final SyncExceptionType type;
  final String message;

  SyncException(this.type, {this.message});
}
