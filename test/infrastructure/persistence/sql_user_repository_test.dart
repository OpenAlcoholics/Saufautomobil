import 'package:sam/domain/model/user.dart';
import 'package:sam/domain/persistence/exception.dart';
import 'package:sam/infrastructure/persistence/sql_user_repository.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import '../../test_infrastructure.dart';

void main() {
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

  group('before insert', () {
    test('insert and find work', () async {
      final user = _createUser();
      await expectLater(repo.insertUser(user), completes);
      final dbUser = await repo.findUser(user.id);
      expect(user, dbUser);
    });
    test('find returns null', () {
      final id = const Uuid().v4();
      expect(repo.findUser(id), completion(isNull));
    });
    test(
      'getUsers is empty',
      () => expect(repo.getUsers(), completion(isEmpty)),
    );
    test('delete works', () {
      final id = const Uuid().v4();
      expect(repo.deleteUser(id), completes);
    });
  });

  group('after insert', () {
    final User userA = _createUser(name: 'test-user-a');
    final User userB = _createUser(name: 'test-user-b');
    setUp(() async {
      await repo.insertUser(userA);
      await repo.insertUser(userB);
    });

    test('duplicate insert fails', () {
      expect(repo.insertUser(userA), throwsA(isA<DuplicateException>()));
    });

    test('getUsers contains users', () {
      expect(repo.getUsers(), completion({userA, userB}));
    });
    test('findUser finds the correct user', () {
      expect(repo.findUser(userA.id), completion(userA));
    });

    test('update name works', () async {
      final updated = userA.changeName('new-name');
      await repo.updateUser(updated);
      expect(repo.getUsers(), completion({userB, updated}));
    });
    test('update active works', () async {
      final updated = userA.withActive(false);
      await repo.updateUser(updated);
      expect(repo.getUsers(), completion({userB, updated}));
    });

    test('delete works', () async {
      await expectLater(repo.deleteUser(userA.id), completes);
      expect(repo.getUsers(), completion({userB}));
    });
  });
}

User _createUser({
  String name = 'test-name',
  String? id,
  bool isActive = true,
}) {
  return User.create(
    name: name,
    id: id,
    isActive: isActive,
  );
}
