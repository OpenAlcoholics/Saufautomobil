import 'package:sam/domain/model/user.dart';

enum CardState {
  Blank,
  Concrete,
  TimedActive,
  Usable,
}

class Card {
  /// The card ID
  final String id;

  /// The ID of the CardSpec this card was generated from.
  final String specId;

  /// The card text. It may contain {int} as a placeholder for a random number.
  final String textTemplate;

  /// Whether the card affects one person or the whole group.
  final bool isPersonal;

  /// Whether only one instance of this card may be active.
  final bool isUnique;

  final CardState state;

  final String? _text;

  String get text {
    if (state == CardState.Blank) {
      throw StateError("Blank cards don't have text");
    }
    return _text!;
  }

  final User? _user;

  User get user {
    if (state == CardState.Blank) {
      throw StateError("Blank cards don't have a user");
    }
    return _user!;
  }

  /// How often this can be used (e.g. three immunities in future rounds)
  final int uses;

  // TODO: rounds and turns are complicated

  /// How many rounds the card is active for.
  /// If uses > 1, the rounds are counted after each use.
  /// Use -1 for infinite duration.
  final int rounds;

  final String? note;

  Card.create({
    required this.id,
    required this.specId,
    required this.textTemplate,
    required this.isPersonal,
    required this.isUnique,
    required this.uses,
    required this.rounds,
  })   : this.state = CardState.Blank,
        this._text = null,
        this._user = null,
        this.note = null;

  Card._({
    required this.id,
    required this.specId,
    required this.textTemplate,
    required this.isPersonal,
    required this.isUnique,
    required this.uses,
    required this.rounds,
    required this.state,
    required this.note,
    required String? text,
    required User? user,
  })   : this._text = text,
        this._user = user;

  Card _copyWith({
    required int uses,
    required int rounds,
    required CardState state,
    required String? note,
    required String? text,
    required User? user,
  }) {
    return Card._(
      id: id,
      specId: specId,
      textTemplate: textTemplate,
      isPersonal: isPersonal,
      isUnique: isUnique,
      uses: uses,
      rounds: rounds,
      state: state,
      note: note,
      text: text,
      user: user,
    );
  }

  Card makeConcrete(User user, String text) {
    if (this.state != CardState.Blank) {
      throw StateError("Can't make card in state ${this.state} concrete");
    }
    final CardState state = uses > 0 ? CardState.Usable : CardState.Concrete;

    return _copyWith(
      uses: uses,
      rounds: rounds,
      state: state,
      note: note,
      text: text,
      user: user,
    );
  }

  Card setNote(String? note) {
    if (state == CardState.Blank) {
      throw StateError("Can't set note in state $state");
    }

    if (note != null && note.trim().isEmpty) {
      throw ArgumentError.value(note, "note", "Can't be blank");
    }

    return _copyWith(
      uses: uses,
      rounds: rounds,
      state: state,
      note: note,
      text: _text,
      user: _user,
    );
  }

  Card use() {
    if (this.state != CardState.Usable) {
      throw StateError("Can't use card in state ${this.state}");
    }
    final uses = this.uses - 1;
    final state = uses == 0 ? CardState.Concrete : CardState.Usable;
    return _copyWith(
      uses: uses,
      rounds: rounds,
      state: state,
      note: note,
      text: _text,
      user: _user,
    );
  }
}
