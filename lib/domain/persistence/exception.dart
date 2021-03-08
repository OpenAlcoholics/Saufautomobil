abstract class PersistenceException implements Exception {
  final String? message;

  const PersistenceException([this.message]);
}

class DuplicateException extends PersistenceException {
  DuplicateException([String? message]) : super(message);
}

class NotFoundException extends PersistenceException {
  NotFoundException([String? message]) : super(message);
}

class UnexpectedPersistenceException extends PersistenceException {
  UnexpectedPersistenceException([String? message]) : super(message);
}
