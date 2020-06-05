import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/rules/rule.dart';
import 'package:sam/domain/rules/rules_state.dart';

class RulesService {
  Future<void> loadRules() async {
    final state = service<RulesState>().activeRules;
    state.addValue([]);
  }

  Future<void> addRule(Rule rule) async {
    final state = service<RulesState>().activeRules;
    final previous = state.lastValue?.toList() ?? <Rule>[];
    previous.add(rule);
    state.addValue(previous);
    // TODO persist
  }

  Future<void> updateRound(int round) async {
    final state = service<RulesState>().activeRules;
    final rules = state.lastValue;
    if (rules != null) {
      final newRules = [];
      for (final rule in rules) {
        if (rule.untilRound > round) {
          newRules.add(rule);
        }
      }
      state.addValue(newRules);
      // TODO persist
    }
  }
}
