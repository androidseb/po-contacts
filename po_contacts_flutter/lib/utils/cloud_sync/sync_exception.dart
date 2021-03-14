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
  final String? message;

  SyncException(this.type, {this.message});

  String toUIMessageString() {
    final StringBuffer res = StringBuffer();
    switch (type) {
      case SyncExceptionType.AUTHENTICATION:
        res.write('Authentication: something went wrong with the authentication.');
        break;
      case SyncExceptionType.FILE_PARSING_ERROR:
        res.write(
            'File parsing error: something went wrong with reading some files. Possible causes are corrupted files or wrong encryption key.');
        break;
      case SyncExceptionType.NETWORK:
        res.write('Network: some network error happened.');
        break;
      case SyncExceptionType.SERVER:
        res.write('Server: the server responded with an error.');
        break;
      case SyncExceptionType.CONCURRENCY:
        res.write('Concurrency: another device was syncing at the same time.');
        break;
      case SyncExceptionType.CANCELED:
        res.write('Canceled: user canceled.');
        break;
      case SyncExceptionType.OTHER:
        res.write('Other: some unknown error happened.');
        break;
    }
    if (message != null) {
      res.write('\n');
      res.write(message);
    }
    return res.toString();
  }
}
