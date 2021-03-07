import 'package:injectable/injectable.dart';
import 'package:sam/infrastructure/persistence/sql_user_repository.dart';
import 'package:sqflite/sqlite_api.dart';

abstract class RepositoryMigrator {
  Future<void> create(Batch batch);

  Future<void> upgrade(Batch batch, int oldVersion, int newVersion);
}

@injectable
class Migrator {
  final int newestVersion = 1;
  final UserRepositoryMigrator _userRepositoryMigrator;

  Migrator(this._userRepositoryMigrator);

  Future<void> onCreate(Database database, int version) async {
    final batch = database.batch();
    await _userRepositoryMigrator.create(batch);
    await batch.commit();
  }

  Future<void> onUpgrade(
    Database database,
    int oldVersion,
    int newVersion,
  ) async {
    final batch = database.batch();
    await _userRepositoryMigrator.upgrade(batch, oldVersion, newVersion);
    await batch.commit();
  }
}
