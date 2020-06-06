import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';

class GameService {
  Future<void> nextRound() async {
    final state = service<GameState>();
    // TODO: assume it's not null
    final round = state.currentRound.lastValue ?? 0;
    final activeRules = state.activeRules;
    final rules = activeRules.lastValue;
    if (rules != null) {
      final newRules = [];
      for (final rule in rules) {
        if (rule.untilRound > round) {
          newRules.add(rule);
        }
      }
      activeRules.addValue(newRules);
      // TODO persist
    }
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
        previousIndex != currentPlayerIndex;
        previousIndex = _previousPlayerIndex(oldPlayers, previousIndex)) {
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

  int _previousPlayerIndex(List<String> players, int index) {
    final previousIndex = index - 1;
    if (previousIndex < 0) {
      return players.length - 1;
    } else {
      return previousIndex;
    }
  }
}
