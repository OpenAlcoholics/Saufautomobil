import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/player_repository.dart';
import 'package:sam/domain/game/rule.dart';
import 'package:sam/domain/game/rules_repository.dart';
import 'package:sam/domain/game/task.dart';
import 'package:sam/domain/game/task_repository.dart';

class PersistenceLoadService {
  Future<void> loadGame() async {
    await service<RepoCreation>().waitForRepoCreates();

    final futures = <Future>[];
    final gameState = service<GameState>();

    futures.add(_loadPlayers());

    final tasksFuture = _loadTasks();
    futures.add(tasksFuture);

    futures.add(_loadRules(tasksFuture));

    // TODO implement
    gameState.currentPlayer.addValue(0);
    gameState.currentRound.addValue(0);

    await Future.wait(futures);

    gameState.isInitialized.addValue(true);
  }

  Future<void> _loadPlayers() async {
    final gameState = service<GameState>();
    final players = await service<PlayerRepository>().loadPlayers();
    gameState.players.addValue(players);
  }

  Future<void> _loadTasks() async {
    final gameState = service<GameState>();
    final tasks = await service<TaskRepository>().getTasks();
    if (tasks.isNotEmpty) {
      gameState.tasks.addValue(tasks);
    }
  }

  Future<void> _loadRules(Future<void> tasksFuture) async {
    await tasksFuture;
    final gameState = service<GameState>();
    final tasks = gameState.tasks.lastValue;
    if (tasks == null) {
      gameState.activeRules.addValue(const []);
      return;
    }
    final taskById = Map<String, Task>.fromIterable(tasks, key: (e) => e.id);
    final tasklessRules = await service<RuleRepository>().getRules();
    final rules = tasklessRules
        .map((e) => Rule(
              taskById[e.taskId],
              player: e.player,
              untilRound: e.untilRound,
            ))
        .toList(growable: false);
    gameState.activeRules.addValue(rules);
  }
}
