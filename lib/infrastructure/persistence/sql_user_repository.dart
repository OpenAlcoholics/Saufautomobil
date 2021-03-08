import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sam/domain/model/user.dart';
import 'package:sam/domain/persistence/exception.dart';
import 'package:sam/domain/persistence/user_repository.dart';
import 'package:sam/infrastructure/persistence/migration.dart';
import 'package:sqflite/sqlite_api.dart';

const TABLE_NAME = "user";
const COLUMN_ID = "id";
const COLUMN_NAME = "name";
const COLUMN_ACTIVE = "active";

@injectable
class UserRepositoryMigrator implements RepositoryMigrator {
  final Logger _logger;

  UserRepositoryMigrator(this._logger);

  Future<void> create(Batch batch) async {
    _logger.i("Creating database");
    batch.execute("""
    CREATE TABLE $TABLE_NAME (
      $COLUMN_ID TEXT PRIMARY KEY,
      $COLUMN_NAME TEXT,
      $COLUMN_ACTIVE INTEGER
      )
    """);
  }

  Future<void> upgrade(
    Batch batch,
    int oldVersion,
    int newVersion,
  ) async {
    _logger.i("Updating table from version $oldVersion to $newVersion");
  }
}

@injectable
@Injectable(as: UserRepository)
class SqlUserRepository implements UserRepository {
  final Database _database;
  final Logger _logger;

  SqlUserRepository(this._database, this._logger);

  User _createUser(Map<String, dynamic?> values) {
    final String id = values[COLUMN_ID];
    final String name = values[COLUMN_NAME];
    final bool isActive = values[COLUMN_ACTIVE] == 1;
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
        TABLE_NAME,
        where: "$COLUMN_ID = ?",
        whereArgs: [userId],
      );
      if (result.isEmpty) {
        return null;
      } else {
        return _createUser(result.first);
      }
    } on DatabaseException catch (e) {
      _logger.e("Unexpected error", e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      await _database.delete(
        TABLE_NAME,
        where: "$COLUMN_ID = ?",
        whereArgs: [userId],
      );
    } on DatabaseException catch (e) {
      _logger.e("Unexpected error", e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<Set<User>> getUsers() async {
    try {
      final result = await _database.query(TABLE_NAME);
      return result.map(_createUser).toSet();
    } on DatabaseException catch (e) {
      _logger.e("Unexpected error", e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<void> insertUser(User user) async {
    try {
      await _database.insert(
        TABLE_NAME,
        {
          COLUMN_ID: user.id,
          COLUMN_NAME: user.name,
          COLUMN_ACTIVE: user.isActive ? 1 : 0,
        },
        conflictAlgorithm: ConflictAlgorithm.fail,
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        _logger.e("Unexpected error", e);
        throw DuplicateException("Tried to insert duplicate user: $user");
      } else {
        throw UnexpectedPersistenceException();
      }
    }
  }

  @override
  Future<void> updateUser(User user) async {
    try {
      await _database.update(
        TABLE_NAME,
        {
          COLUMN_ACTIVE: user.isActive ? 1 : 0,
          COLUMN_NAME: user.name,
        },
        where: "$COLUMN_ID = ?",
        whereArgs: [user.id],
      );
    } on DatabaseException catch (e) {
      _logger.e("Unexpected error", e);
      throw UnexpectedPersistenceException();
    }
  }
}
