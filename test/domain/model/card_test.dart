import 'package:sam/domain/model/card.dart';
import 'package:sam/domain/model/user.dart';
import 'package:test/test.dart';

void main() {
  group("Initially", () {
    final card = _createCard();

    test("has Blank state", () => expect(card.state, CardState.Blank));
    test("has no text", () => expect(() => card.text, throwsStateError));
    test("has no user", () => expect(() => card.user, throwsStateError));
    test(
      "can't have notes",
      () => expect(() => card.setNote("Note"), throwsStateError),
    );
    test(
      "can't be used",
      () => expect(() => card.use(), throwsStateError),
    );
  });

  test(
    "can be made concrete",
    () {
      final card = _createCard();
      final user = _createUser();
      expect(() => card.makeConcrete(user, "Drink 10!"), returnsNormally);
      expect(card.state, CardState.Blank);
    },
  );

  group("Concrete", () {
    late Card card;
    late User user;

    setUp(() {
      user = _createUser();
      card = _createCard().makeConcrete(user, "Drink 10!");
    });

    test(
      "has Concrete state",
      () => expect(card.state, CardState.Concrete),
    );
    test(
      "has user",
      () => expect(card.user, user),
    );
    test(
      "has text",
      () => expect(card.text, "Drink 10!"),
    );
    test("has no note", () => expect(card.note, isNull));
    test("can set note", () {
      final noteText = "Test";
      final newCard = card.setNote(noteText);
      expect(card.note, isNull);
      expect(newCard.note, equals(noteText));
    });
    test("can't set invalid note", () {
      expect(() => card.setNote(""), throwsArgumentError);
      expect(() => card.setNote(" "), throwsArgumentError);
    });
    test("can't be used", () => expect(() => card.use(), throwsStateError));
  });

  group("Usable", () {
    late Card card;
    late User user;

    setUp(() {
      user = _createUser();
      card = _createCard(uses: 2).makeConcrete(user, "Drink 10!");
    });

    test(
      "has Usable state",
      () => expect(card.state, CardState.Usable),
    );
    test(
      "has user",
      () => expect(card.user, user),
    );
    test(
      "has text",
      () => expect(card.text, "Drink 10!"),
    );

    test("can be used", () {
      final usedCard = card.use();
      expect(card.uses, 2);
      expect(usedCard.uses, 1);
      expect(usedCard.state, CardState.Usable);
    });

    test("can be used up", () {
      final usedCard = card.use().use();
      expect(card.uses, 2);
      expect(card.state, CardState.Usable);

      expect(usedCard.uses, 0);
      expect(usedCard.state, CardState.Concrete);
      expect(() => usedCard.use(), throwsStateError);
    });

    test("has no note", () => expect(card.note, isNull));
    test("can set note", () {
      final noteText = "Test";
      final newCard = card.setNote(noteText);
      expect(card.note, isNull);
      expect(newCard.note, equals(noteText));
    });
    test("can't set invalid note", () {
      expect(() => card.setNote(""), throwsArgumentError);
      expect(() => card.setNote(" "), throwsArgumentError);
    });
  });
}

User _createUser() {
  return User(name: "user-name");
}

Card _createCard({
  id: "test-id",
  specId: "test-spec-id",
  textTemplate: "Drink {int}!",
  isPersonal: true,
  isUnique: false,
  uses: 0,
  rounds: 0,
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
