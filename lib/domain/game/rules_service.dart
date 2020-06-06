import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/rule.dart';

class RulesService {
  Future<void> loadRules() async {
    final state = service<GameState>().activeRules;
    state.addValue([]);
    // TODO load from persistence store
  }

  Future<void> addRule(Rule rule) async {
    final state = service<GameState>().activeRules;
    final previous = state.lastValue?.toList() ?? <Rule>[];
    previous.add(rule);
    state.addValue(previous);
    // TODO persist
  }
}
