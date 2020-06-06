import 'package:get_it/get_it.dart';
import 'package:sam/domain/game/game_repository.dart';
import 'package:sam/domain/game/game_service.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/persistence_load_service.dart';
import 'package:sam/domain/game/persistence_store_service.dart';
import 'package:sam/domain/game/reset_service.dart';
import 'package:sam/domain/game/rules_service.dart';
import 'package:sam/domain/tasks/tasks_service.dart';
import 'package:sam/domain/tasks/tasks_state.dart';
import 'package:sqflite/sqflite.dart';

final service = GetIt.instance;

class DependencyModel {
  Future<void> init() async {
    await _registerRepos();
    await _registerStates();
    await _registerServices();
  }

  Future<void> _registerRepos() async {
    final connection = await openDatabase('sam.db');
    service.registerSingleton(GameRepository(connection));
  }

  Future<void> _registerStates() {
    service.registerSingleton(TasksState());
    service.registerSingleton(GameState());
  }

  Future<void> _registerServices() {
    service.registerSingleton(PersistenceLoadService());
    service.registerSingleton(PersistenceStoreService());
    service.registerSingleton(ResetService());
    service.registerSingleton(RulesService());
    service.registerSingleton(TasksService());
    service.registerSingleton(GameService());
  }
}
