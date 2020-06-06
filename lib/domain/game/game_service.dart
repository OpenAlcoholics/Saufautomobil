import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/player_repository.dart';
import 'package:sam/domain/game/rules_service.dart';
import 'package:sam/domain/game/task_generator.dart';
import 'package:sam/domain/game/task_repository.dart';
import 'package:sam/domain/model.dart';

class GameService {
  Future<void> nextRound() async {
    final state = service<GameState>();

    await _advanceRound(state);
    await _advancePlayer(state);
    await service<RulesService>().advanceRules();
  }

  Future<void> _advanceRound(GameState state) async {
    final round = state.currentRound.lastValue + 1;
    state.currentRound.addValue(round);
  }

  Future<void> _advancePlayer(GameState state) async {
    final previousIndex = state.currentPlayer.lastValue;
    final playerCount = state.players.lastValue.length;
    if (playerCount == 0) return 0;
    return (previousIndex + 1) % playerCount;
  }

  Future<void> setTasks(List<TaskSpec> taskSpecs) async {
    final state = service<GameState>();
    final tasks = TaskGenerator().generateTasks(taskSpecs);
    await service<TaskRepository>().setTasks(tasks);
    state.tasks.addValue(tasks);
  }

  Future<void> reset() async {
    service<TaskRepository>().setTasks([]);
    final state = service<GameState>();
    state.tasks.addValue(null);
    state.activeRules.addValue([]);
    state.currentPlayer.addValue(0);
    state.currentRound.addValue(0);
    // TODO update current round etc. (persist)
  }

  Future<void> updatePlayers(List<String> players) async {
    final state = service<GameState>();
    final previousPlayers = state.players.lastValue;
    final currentPlayerIndex = state.currentPlayer.lastValue;
    final newIndex = _calculateNewIndex(
      previousPlayers,
      players,
      currentPlayerIndex,
    );
    await service<PlayerRepository>().setPlayers(players);
    state.players.addValue(players);
    state.currentPlayer.addValue(newIndex);
  }

  int _calculateNewIndex(
    List<String> oldPlayers,
    List<String> players,
    int currentPlayerIndex,
  ) {
    if (players.isEmpty || oldPlayers.isEmpty) {
      return 0;
    }

    for (var previousIndex = currentPlayerIndex;
        previousIndex != -1;
        previousIndex = _previousPlayerIndex(
            oldPlayers, currentPlayerIndex, previousIndex)) {
      // Go through all old players in reverse, starting with the current one
      // If one is in the new player list, he's selected
      final player = oldPlayers[previousIndex];
      final indexInNew = players.indexOf(player);
      if (indexInNew >= 0) {
        return indexInNew;
      }
    }

    return 0;
  }

  int _previousPlayerIndex(List<String> players, int stopIndex, int index) {
    final previousIndex = index - 1;
    if (previousIndex < 0) {
      final result = players.length - 1;
      if (result == stopIndex) {
        return -1;
      } else {
        return result;
      }
    } else {
      if (previousIndex == stopIndex) {
        return -1;
      } else {
        return previousIndex;
      }
    }
  }
}
