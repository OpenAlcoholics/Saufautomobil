class CardSpecDto {
  final String text;
  final int count;
  final int uses;
  final int rounds;
  final bool personal;
  final bool remote;
  final bool unique;
  final int id;

  CardSpecDto({
    required this.text,
    required this.count,
    required this.uses,
    required this.rounds,
    required this.personal,
    required this.remote,
    required this.unique,
    required this.id,
  });
}

abstract class CardSpecService {
  Future<List<CardSpecDto>> call();
}

class CardSpecServiceException implements Exception {
  final String message;

  CardSpecServiceException(this.message);
}
