import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sam/domain/model/user.dart';
import 'package:sam/domain/persistence/exception.dart';
import 'package:sam/domain/persistence/user_repository.dart';
import 'package:sam/infrastructure/persistence/migration.dart';
import 'package:sqflite/sqflite.dart';

const tableName = 'user';
const columnId = 'id';
const columnName = 'name';
const columnActive = 'active';

@injectable
class UserRepositoryMigrator implements RepositoryMigrator {
  final Logger _logger;

  UserRepositoryMigrator(this._logger);

  @override
  Future<void> create(Batch batch) async {
    _logger.i('Creating table');
    batch.execute('''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnActive INTEGER NOT NULL
      )
    ''');
  }

  @override
  Future<void> upgrade(
    Batch batch,
    int oldVersion,
    int newVersion,
  ) async {
    _logger.i('Updating table from version $oldVersion to $newVersion');
  }
}

@injectable
@Injectable(as: UserRepository)
class SqlUserRepository implements UserRepository {
  final Database _database;
  final Logger _logger;

  SqlUserRepository(this._database, this._logger);

  User _createUser(Map<String, dynamic> values) {
    final String id = values[columnId] as String;
    final String name = values[columnName] as String;
    final bool isActive = values[columnActive] == 1;
    return User.create(
      id: id,
      name: name,
      isActive: isActive,
    );
  }

  @override
  Future<User?> findUser(String userId) async {
    try {
      final result = await _database.query(
        tableName,
        where: '$columnId = ?',
        whereArgs: [userId],
      );
      if (result.isEmpty) {
        return null;
      } else {
        return _createUser(result.first);
      }
    } on DatabaseException catch (e) {
      _logger.e('Unexpected error', e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _database.delete(
        tableName,
        where: '$columnId = ?',
        whereArgs: [userId],
      );
    } on DatabaseException catch (e) {
      _logger.e('Unexpected error', e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<Set<User>> getUsers() async {
    try {
      final result = await _database.query(tableName);
      return result.map(_createUser).toSet();
    } on DatabaseException catch (e) {
      _logger.e('Unexpected error', e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<void> insertUser(User user) async {
    try {
      await _database.insert(
        tableName,
        {
          columnId: user.id,
          columnName: user.name,
          columnActive: user.isActive ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        _logger.e('Unexpected error', e);
        throw DuplicateException('Tried to insert duplicate user: $user');
      } else {
        throw UnexpectedPersistenceException();
      }
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await _database.update(
        tableName,
        {
          columnActive: user.isActive ? 1 : 0,
          columnName: user.name,
        },
        where: '$columnId = ?',
        whereArgs: [user.id],
      );
    } on DatabaseException catch (e) {
      _logger.e('Unexpected error', e);
      throw UnexpectedPersistenceException();
    }
  }
}
