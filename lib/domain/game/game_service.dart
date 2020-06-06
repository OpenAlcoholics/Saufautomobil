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
}
