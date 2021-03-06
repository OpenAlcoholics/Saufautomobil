class CardSpec {
  /// The card spec ID
  final String id;

  /// The card text. It may contain {int} as a placeholder for a random number.
  final String text;

  /// How often this card should be used per game
  final int count;

  /// How often this can be used (e.g. three immunities in future rounds)
  final int uses;

  /// How many rounds the card is active for.
  /// If uses > 1, the rounds are counted after each use.
  /// Use -1 for infinite duration.
  final int rounds;

  /// Whether this card works remotely
  final bool isRemote;

  /// Whether the card affects one person or the whole group.
  final bool isPersonal;

  /// Whether only one instance of this card may be active.
  final bool isUnique;

  CardSpec({
    required this.id,
    required this.text,
    required this.count,
    required this.uses,
    required this.rounds,
    required this.isRemote,
    required this.isPersonal,
    required this.isUnique,
  });
}
