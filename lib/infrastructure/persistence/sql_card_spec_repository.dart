import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sam/domain/model/card_spec.dart';
import 'package:sam/domain/persistence/card_spec_repository.dart';
import 'package:sam/domain/persistence/exception.dart';
import 'package:sam/infrastructure/persistence/migration.dart';
import 'package:sqflite/sqflite.dart';

const tableName = 'card_specs';
const columnId = 'id';
const columnText = 'text';
const columnCount = 'count';
const columnUses = 'uses';
const columnRounds = 'rounds';
const columnRemote = 'remote';
const columnPersonal = 'personal';
const columnUnique = 'is_unique';

@injectable
class CardSpecRepositoryMigrator implements RepositoryMigrator {
  final Logger _logger;

  CardSpecRepositoryMigrator(this._logger);

  @override
  Future<void> create(Batch batch) async {
    _logger.i('Creating table');
    batch.execute('''
    CREATE TABLE $tableName (
      $columnId TEXT PRIMARY KEY,
      $columnText TEXT NOT NULL,
      $columnCount INTEGER NOT NULL,
      $columnUses INTEGER NOT NULL,
      $columnRounds INTEGER NOT NULL,
      $columnRemote INTEGER NOT NULL,
      $columnPersonal INTEGER NOT NULL,
      $columnUnique INTEGER NOT NULL
      )
    ''');
  }

  @override
  Future<void> upgrade(Batch batch, int oldVersion, int newVersion) async {
    _logger.i('Updating table from version $oldVersion to $newVersion');
  }
}

@injectable
@Injectable(as: CardSpecRepository)
class SqlCardSpecRepository implements CardSpecRepository {
  final Database _database;
  final Logger _logger;

  SqlCardSpecRepository(this._database, this._logger);

  CardSpec _createCardSpec(Map<String, dynamic> values) {
    return CardSpec(
      id: values[columnId] as String,
      text: values[columnText] as String,
      count: values[columnCount] as int,
      uses: values[columnUses] as int,
      rounds: values[columnRounds] as int,
      isRemote: values[columnRemote] == 1,
      isPersonal: values[columnPersonal] == 1,
      isUnique: values[columnUnique] == 1,
    );
  }

  @override
  Future<Set<CardSpec>> getSpecs() async {
    try {
      final result = await _database.query(tableName);
      return result.map(_createCardSpec).toSet();
    } on DatabaseException catch (e) {
      _logger.e('Unexpected error', e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<void> clearSpecs() async {
    try {
      await _database.delete(tableName);
    } on DatabaseException catch (e) {
      _logger.e('Unexpected error', e);
      throw UnexpectedPersistenceException();
    }
  }

  @override
  Future<void> replaceSpecs(Iterable<CardSpec> specs) async {
    try {
      await _database.transaction((txn) async {
        await txn.delete(tableName);
        final batch = txn.batch();
        for (final spec in specs) {
          batch.insert(
            tableName,
            {
              columnId: spec.id,
              columnText: spec.text,
              columnCount: spec.count,
              columnUses: spec.uses,
              columnRounds: spec.rounds,
              columnRemote: spec.isRemote ? 1 : 0,
              columnPersonal: spec.isPersonal ? 1 : 0,
              columnUnique: spec.isUnique ? 1 : 0,
            },
            conflictAlgorithm: ConflictAlgorithm.fail,
          );
        }
        await batch.commit();
      });
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        _logger.e('Unexpected error', e);
        throw DuplicateException('Tried to insert duplicate spec');
      } else {
        throw UnexpectedPersistenceException();
      }
    }
  }
}
