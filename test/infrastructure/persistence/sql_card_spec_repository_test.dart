import 'package:sam/domain/model/card_spec.dart';
import 'package:sam/domain/persistence/card_spec_repository.dart';
import 'package:sam/infrastructure/persistence/sql_card_spec_repository.dart';
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
    repo = getIt<SqlCardSpecRepository>();
  });
  tearDown(() async {
    await database.close();
  });

  group("Empty table", () {
    test(
      "getSpecs is empty",
      () => expect(repo.getSpecs(), completion(isEmpty)),
    );
    test("insert works", () async {
      final specs = Set.of(Iterable.generate(11, (_) => _createSpec()));
      await expectLater(repo.replaceSpecs(specs), completes);
      expect(repo.getSpecs(), completion(specs));
    });
    // TODO: add more tests
  });
}

CardSpec _createSpec({
  String text = "test-text",
  int count = 1,
  int uses = 2,
  int rounds = 3,
  bool isRemote = true,
  bool isPersonal = true,
  bool isUnique = true,
}) {
  return CardSpec(
    id: Uuid().v4(),
    text: text,
    count: count,
    uses: uses,
    rounds: rounds,
    isRemote: isRemote,
    isPersonal: isPersonal,
    isUnique: isUnique,
  );
}
