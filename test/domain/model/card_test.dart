import 'package:sam/domain/model/card.dart';
import 'package:sam/domain/model/user.dart';
import 'package:test/test.dart';

void main() {
  group('Initially', () {
    final card = _createCard();

    test('has Blank state', () => expect(card.state, CardState.blank));
    test('has no text', () => expect(() => card.text, throwsStateError));
    test('has no user', () => expect(() => card.user, throwsStateError));
    test(
      "can't have notes",
      () => expect(() => card.setNote('Note'), throwsStateError),
    );
    test(
      "can't be used",
      () => expect(() => card.use(), throwsStateError),
    );
  });

  test(
    'can be made concrete',
    () {
      final card = _createCard();
      final user = _createUser();
      expect(() => card.makeConcrete(user, 'Drink 10!'), returnsNormally);
      expect(card.state, CardState.blank);
    },
  );

  group('Concrete', () {
    late Card card;
    late User user;

    setUp(() {
      user = _createUser();
      card = _createCard().makeConcrete(user, 'Drink 10!');
    });

    test(
      'has Concrete state',
      () => expect(card.state, CardState.concrete),
    );
    test(
      'has user',
      () => expect(card.user, user),
    );
    test(
      'has text',
      () => expect(card.text, 'Drink 10!'),
    );
    test('has no note', () => expect(card.note, isNull));
    test('can set note', () {
      const noteText = 'Test';
      final newCard = card.setNote(noteText);
      expect(card.note, isNull);
      expect(newCard.note, equals(noteText));
    });
    test("can't set invalid note", () {
      expect(() => card.setNote(''), throwsArgumentError);
      expect(() => card.setNote(' '), throwsArgumentError);
    });
    test("can't be used", () => expect(() => card.use(), throwsStateError));
  });

  group('Usable', () {
    late Card card;
    late User user;

    setUp(() {
      user = _createUser();
      card = _createCard(uses: 2).makeConcrete(user, 'Drink 10!');
    });

    test(
      'has Usable state',
      () => expect(card.state, CardState.usable),
    );
    test(
      'has user',
      () => expect(card.user, user),
    );
    test(
      'has text',
      () => expect(card.text, 'Drink 10!'),
    );

    test('can be used', () {
      final usedCard = card.use();
      expect(card.uses, 2);
      expect(usedCard.uses, 1);
      expect(usedCard.state, CardState.usable);
    });

    test('can be used up', () {
      final usedCard = card.use().use();
      expect(card.uses, 2);
      expect(card.state, CardState.usable);

      expect(usedCard.uses, 0);
      expect(usedCard.state, CardState.concrete);
      expect(() => usedCard.use(), throwsStateError);
    });

    test('has no note', () => expect(card.note, isNull));
    test('can set note', () {
      const noteText = 'Test';
      final newCard = card.setNote(noteText);
      expect(card.note, isNull);
      expect(newCard.note, equals(noteText));
    });
    test("can't set invalid note", () {
      expect(() => card.setNote(''), throwsArgumentError);
      expect(() => card.setNote(' '), throwsArgumentError);
    });
  });
}

User _createUser() {
  return User.create(name: 'user-name');
}

Card _createCard({
  String id = 'test-id',
  String specId = 'test-spec-id',
  String textTemplate = 'Drink {int}!',
  bool isPersonal = true,
  bool isUnique = false,
  int uses = 0,
  int rounds = 0,
}) {
  return Card.create(
    id: id,
    specId: specId,
    textTemplate: textTemplate,
    isPersonal: isPersonal,
    isUnique: isUnique,
    uses: uses,
    rounds: rounds,
  );
}
