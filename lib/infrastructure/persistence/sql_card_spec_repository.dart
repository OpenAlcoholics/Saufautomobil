import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sam/domain/model/card_spec.dart';
import 'package:sam/domain/persistence/card_spec_repository.dart';
import 'package:sam/domain/persistence/exception.dart';
import 'package:sam/infrastructure/persistence/migration.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common/sqlite_api.dart';

const TABLE_NAME = "card_specs";
const COLUMN_ID = "id";
const COLUMN_TEXT = "text";
const COLUMN_COUNT = "count";
const COLUMN_USES = "uses";
const COLUMN_ROUNDS = "rounds";
const COLUMN_REMOTE = "remote";
const COLUMN_PERSONAL = "personal";
const COLUMN_UNIQUE = "is_unique";

@injectable
class CardSpecRepositoryMigrator implements RepositoryMigrator {
  final Logger _logger;

  CardSpecRepositoryMigrator(this._logger);

  @override
  Future<void> create(Batch batch) async {
    _logger.i("Creating table");
    batch.execute("""
    CREATE TABLE $TABLE_NAME (
      $COLUMN_ID TEXT PRIMARY KEY,
      $COLUMN_TEXT TEXT NOT NULL,
      $COLUMN_COUNT INTEGER NOT NULL,
      $COLUMN_USES INTEGER NOT NULL,
      $COLUMN_ROUNDS INTEGER NOT NULL,
      $COLUMN_REMOTE INTEGER NOT NULL,
      $COLUMN_PERSONAL INTEGER NOT NULL,
      $COLUMN_UNIQUE INTEGER NOT NULL
      )
    """);
  }

  @override
  Future<void> upgrade(Batch batch, int oldVersion, int newVersion) async {
    _logger.i("Updating table from version $oldVersion to $newVersion");
  }
}

@injectable
@Injectable(as: CardSpecRepository)
class SqlCardSpecRepository implements CardSpecRepository {
  final Database _database;
  final Logger _logger;

  SqlCardSpecRepository(this._database, this._logger);

  CardSpec _createCardSpec(Map<String, dynamic?> values) {
    return CardSpec(
      id: values[COLUMN_ID],
      text: values[COLUMN_TEXT],
      count: values[COLUMN_COUNT],
      uses: values[COLUMN_USES],
      rounds: values[COLUMN_ROUNDS],
      isRemote: values[COLUMN_REMOTE] == 1,
      isPersonal: values[COLUMN_PERSONAL] == 1,
      isUnique: values[COLUMN_UNIQUE] == 1,
    );
  }

  @override
  Future<Set<CardSpec>> getSpecs() async {
    try {
      final result = await _database.query(TABLE_NAME);
      return result.map(_createCardSpec).toSet();
    } on DatabaseException catch (e) {
      _logger.e("Unexpected error", e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<void> clearSpecs() async {
    try {
      await _database.delete(TABLE_NAME);
    } on DatabaseException catch (e) {
      _logger.e("Unexpected error", e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<void> replaceSpecs(Iterable<CardSpec> specs) async {
    try {
      await _database.transaction((txn) async {
        await txn.delete(TABLE_NAME);
        final batch = txn.batch();
        for (final spec in specs) {
          batch.insert(
            TABLE_NAME,
            {
              COLUMN_ID: spec.id,
              COLUMN_TEXT: spec.text,
              COLUMN_COUNT: spec.count,
              COLUMN_USES: spec.uses,
              COLUMN_ROUNDS: spec.rounds,
              COLUMN_REMOTE: spec.isRemote ? 1 : 0,
              COLUMN_PERSONAL: spec.isPersonal ? 1 : 0,
              COLUMN_UNIQUE: spec.isUnique ? 1 : 0,
            },
            conflictAlgorithm: ConflictAlgorithm.fail,
          );
        }
        await batch.commit();
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        _logger.e("Unexpected error", e);
        throw DuplicateException("Tried to insert duplicate spec");
      } else {
        throw UnexpectedPersistenceException();
      }
    }
  }
}
