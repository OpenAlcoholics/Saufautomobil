class Task {
  /// ID of this task
  final String id;

  /// ID identifying the taskSpec this task came from.
  final String originId;

  /// The task text.
  final String text;

  /// How often this can be used (e.g. three immunities in future rounds)
  final int uses;

  /// How long this task is active (-1 for indefinitely)
  final int rounds;

  /// Whether only one task from the originId can be active.
  final bool isUnique;

  Task({
    this.id,
    this.originId,
    this.text,
    this.uses,
    this.rounds,
    this.isUnique,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return text;
  }
}
