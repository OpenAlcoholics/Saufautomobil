import 'package:get_it/get_it.dart';
import 'package:sam/domain/game/game_persist.dart';
import 'package:sam/domain/game/game_repository.dart';
import 'package:sam/domain/game/game_service.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/persistence_load_service.dart';
import 'package:sam/domain/game/player_repository.dart';
import 'package:sam/domain/game/reset_service.dart';
import 'package:sam/domain/game/rules_repository.dart';
import 'package:sam/domain/game/rules_service.dart';
import 'package:sam/domain/game/task_repository.dart';
import 'package:sam/domain/repository.dart';
import 'package:sam/domain/tasks/taskspec_service.dart';
import 'package:sam/domain/tasks/taskspec_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final service = GetIt.instance;

class RepoCreation {
  final List<Future<void>> _createFutures;

  RepoCreation(this._createFutures);

  Future<void> waitForRepoCreates() async {
    await Future.wait(_createFutures);
  }
}

class DependencyModel {
  Future<void> init() async {
    service.registerSingleton(await SharedPreferences.getInstance());
    await _registerRepos();
    await _registerStates();
    await _registerServices();
  }

  Future<void> _registerRepos() async {
    final connection = await openDatabase('sam.db');
    service.registerSingleton(GamePersist());

    final createFutures = <Future<void>>[];
    createFutures.add(_registerRepo(GameRepository(connection)));

    final playerFuture = _registerRepo(PlayerRepository(connection));
    createFutures.add(playerFuture);

    final taskFuture = _registerRepo(TaskRepository(connection));
    createFutures.add(taskFuture);

    final rulesFuture = _doAfter(
      () => _registerRepo(RuleRepository(connection)),
      [taskFuture, playerFuture],
    );
    createFutures.add(rulesFuture);

    service.registerSingleton(RepoCreation(createFutures));
  }

  Future<void> _doAfter(
    Future<void> Function() function,
    List<Future<void>> before,
  ) async {
    await Future.wait(before);
    await function();
  }

  Future<void> _registerRepo<T extends Repository>(T repo) {
    service.registerSingleton(repo);
    return repo.createIfNotExists();
  }

  Future<void> _registerStates() async {
    service.registerSingleton(TaskSpecState());
    service.registerSingleton(GameState());
  }

  Future<void> _registerServices() async {
    service.registerSingleton(PersistenceLoadService());
    service.registerSingleton(ResetService());
    service.registerSingleton(RulesService());
    service.registerSingleton(TasksService());
    service.registerSingleton(GameService());
  }
}
