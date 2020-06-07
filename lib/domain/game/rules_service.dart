import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/rule.dart';
import 'package:sam/domain/game/rules_repository.dart';

class RulesService {
  Future<void> deleteWherePlayer(List<String> players) async {
    final activeRules = service<GameState>().activeRules;
    final oldRules = activeRules.lastValue;
    final removedRules =
        oldRules.where((rule) => players.contains(rule.player)).toSet();
    final newRules = oldRules.toList();
    newRules.removeWhere((rule) => removedRules.contains(rule));
    activeRules.addValue(newRules);

    if (removedRules.isNotEmpty) {
      await service<RuleRepository>().deleteRulesWhereTasks(
        removedRules.map((e) => e.task.id),
      );
    }
  }

  Future<void> advanceRules() async {
    final state = service<GameState>();
    final round = state.currentRound.lastValue;
    final activeRules = state.activeRules;
    final rules = activeRules.lastValue;
    final repo = service<RuleRepository>();

    final removals = <Future>[];
    final newRules = <Rule>[];
    for (final rule in rules) {
      if (rule.untilRound > round || rule.untilRound == -1) {
        newRules.add(rule);
      } else {
        removals.add(repo.deleteRule(rule.task.id));
      }
    }
    await Future.wait(removals);

    final newTaskIndex = state.currentTurn.lastValue;
    final task = state.tasks.lastValue[newTaskIndex];
    if (task.rounds > 0 || task.rounds == -1) {
      final currentPlayerIndex = state.currentPlayer.lastValue;
      final currentPlayer = state.players.lastValue[currentPlayerIndex];
      final rule = Rule(
        task,
        player: currentPlayer,
        untilRound: task.rounds == -1 ? -1 : round + task.rounds,
      );
      newRules.add(rule);
      newRules.sort();
      await repo.addRule(rule);
    }

    activeRules.addValue(newRules);
  }
}
