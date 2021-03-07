import 'package:sam/domain/model/user.dart';
import 'package:sam/infrastructure/persistence/sql_user_repository.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:test/test.dart';

import '../../test_infrastructure.dart';

Future<void> main() async {
  late Database database;
  late SqlUserRepository repo;
  setUp(() async {
    final getIt = await configureDependencies();
    database = getIt<Database>();
    repo = getIt<SqlUserRepository>();
  });
  tearDown(() async {
    await database.close();
  });

  test("insert works", () async {
    final user = _createUser();
    await expectLater(repo.insertUser(user), completes);
    final dbUser = await repo.findUser(user.id);
    expect(user, dbUser);
  });
  test("getUsers is empty", () => expect(repo.getUsers(), completion(isEmpty)));
  // TODO: add more tests
}

User _createUser({
  String name = "test-name",
  String? id,
  bool isActive: true,
}) {
  return User.create(
    name: name,
    id: id,
    isActive: isActive,
  );
}
