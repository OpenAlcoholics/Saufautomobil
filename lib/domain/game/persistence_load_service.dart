import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/player_repository.dart';
import 'package:sam/domain/tasks/task_repository.dart';

class PersistenceLoadService {
  Future<void> loadGame() async {
    await service<RepoCreation>().waitForRepoCreates();

    final futures = <Future>[];
    final gameState = service<GameState>();
    futures.add(_loadPlayers());
    futures.add(_loadTasks());
    gameState.currentPlayer.addValue(0);
    gameState.currentRound.addValue(0);
    gameState.activeRules.addValue([]);

    await Future.wait(futures);

    // TODO remove
    await Future.delayed(Duration(seconds: 1));

    gameState.isInitialized.addValue(true);
    // TODO implement
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
}
