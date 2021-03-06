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

  CardState _state;

  CardState get state => _state;

  String? _text;

  String get text {
    if (state == CardState.Blank) {
      throw StateError("Blank cards don't have text");
    }
    return _text!;
  }

  User? _user;

  User get user {
    if (state == CardState.Blank) {
      throw StateError("Blank cards don't have a user");
    }
    return _user!;
  }

  /// How often this can be used (e.g. three immunities in future rounds)
  int _uses;

  int get uses => _uses;

  // TODO: rounds and turns are complicated

  /// How many rounds the card is active for.
  /// If uses > 1, the rounds are counted after each use.
  /// Use -1 for infinite duration.
  final int _rounds;

  String? _note;

  String? get note => _note;

  Card({
    required this.id,
    required this.specId,
    required this.textTemplate,
    required this.isPersonal,
    required this.isUnique,
    required int uses,
    required int rounds,
  })   : this._uses = uses,
        this._rounds = rounds,
        this._state = CardState.Blank;

  void makeConcrete(User user, String text) {
    if (state != CardState.Blank) {
      throw StateError("Can't make card in state $state concrete");
    }
    _text = text;
    _user = user;
    _state = CardState.Concrete;
    if (uses > 0) {
      _state = CardState.Usable;
    }
  }

  void setNote(String? note) {
    if (state == CardState.Blank) {
      throw StateError("Can't set note in state $state");
    }

    if (note != null && note.trim().isEmpty) {
      throw ArgumentError.value(note, "note", "Can't be blank");
    }
    _note = note;
  }

  void use() {
    if (state != CardState.Usable) {
      throw StateError("Can't use card in state $state");
    }
    _uses -= 1;
    if (_uses == 0) {
      _state = CardState.Concrete;
    }
  }
}
