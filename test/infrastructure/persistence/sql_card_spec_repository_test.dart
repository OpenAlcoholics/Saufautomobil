import 'package:sam/domain/model/card_spec.dart';
import 'package:sam/domain/persistence/card_spec_repository.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../test_infrastructure.dart';

void main() {
  late Database database;
  late CardSpecRepository repo;
  setUp(() async {
    final getIt = await configureDependencies();
    database = getIt<Database>();
    repo = getIt<CardSpecRepository>();
  });
  tearDown(() async {
    await database.close();
  });

  group('Empty table', () {
    test(
      'getSpecs is empty',
      () => expect(repo.getSpecs(), completion(isEmpty)),
    );
    test('insert works', () async {
      final specs = Set.of(Iterable.generate(11, (_) => _createSpec()));
      await expectLater(repo.replaceSpecs(specs), completes);
      expect(repo.getSpecs(), completion(specs));
    });
  });

  group('With existing', () {
    final insertedSpec = _createSpec();
    setUp(() async {
      await repo.replaceSpecs([insertedSpec]);
    });

    test('clear clears', () async {
      await expectLater(repo.clearSpecs(), completes);
      expect(repo.getSpecs(), completion(<CardSpec>{}));
    });

    test('replace removes old specs', () async {
      final spec = _createSpec();
      await expectLater(repo.replaceSpecs([spec]), completes);
      expect(repo.getSpecs(), completion({spec}));
    });

    test('replace with the same spec works', () async {
      final alteredSpec = _createSpec(
        id: insertedSpec.id,
        text: 'new-text',
      );
      await expectLater(repo.replaceSpecs({alteredSpec}), completes);
      expect(repo.getSpecs(), completion({alteredSpec}));
    });
  });
}

CardSpec _createSpec({
  String? id,
  String text = 'test-text',
  int count = 1,
  int uses = 2,
  int rounds = 3,
  bool isRemote = true,
  bool isPersonal = true,
  bool isUnique = true,
}) {
  return CardSpec(
    id: id ?? const Uuid().v4(),
    text: text,
    count: count,
    uses: uses,
    rounds: rounds,
    isRemote: isRemote,
    isPersonal: isPersonal,
    isUnique: isUnique,
  );
}
