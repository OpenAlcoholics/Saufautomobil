import 'package:injectable/injectable.dart';
import 'package:sam/infrastructure/persistence/migration.dart';
import 'package:sqflite/sqflite.dart';

@module
abstract class DatabaseModule {
  @prod
  @preResolve
  @Singleton()
  Future<Database> createDatabase(Migrator migrator) async {
    return openDatabase(
      'sam2.db',
      version: migrator.newestVersion,
      onCreate: migrator.onCreate,
      onUpgrade: migrator.onUpgrade,
    );
  }
}
