import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sam/infrastructure/persistence/migration.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'test_infrastructure.config.dart';

@InjectableInit(generateForDir: ["lib", "test"])
Future<GetIt> configureDependencies() => $initGetIt(
      GetIt.asNewInstance(),
      environment: Environment.test,
    );

@module
abstract class MemoryDatabaseModule {
  @preResolve
  @test
  @singleton
  Future<Database> createDatabase(Migrator migrator) async {
    sqfliteFfiInit();
    final db = await databaseFactoryFfi.openDatabase(inMemoryDatabasePath);
    final version = migrator.newestVersion;
    await migrator.onCreate(db, version);
    return db;
  }
}
