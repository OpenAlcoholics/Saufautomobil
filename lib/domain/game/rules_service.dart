import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/rule.dart';
import 'package:sam/domain/game/rules_repository.dart';

class RulesService {
  Future<void> deleteWherePlayer(List<String> players) async {
    final activeRules = service<GameState>().activeRules;
    final oldRules = activeRules.lastValue;
    final removedRules = oldRules
        .where((rule) => rule != null && players.contains(rule.player))
        .toSet();
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

    final currentPlayerIndex = state.currentPlayer.lastValue;
    final players = state.players.lastValue;
    String currentPlayer;
    if (players.isNotEmpty) {
      currentPlayer = players[currentPlayerIndex];
    }

    final removals = <Future>[];
    final newRules = <Rule>[];
    for (final rule in rules) {
      final untilPlayerIndex = rule.untilPlayerIndex;
      if (rule.untilRound == -1 ||
          rule.untilRound > round ||
          (untilPlayerIndex >= players.length && currentPlayerIndex == 0) ||
          untilPlayerIndex > currentPlayerIndex) {
        newRules.add(rule);
      } else {
        removals.add(repo.deleteRule(rule.task.id));
      }
    }

    final newTaskIndex = state.currentTurn.lastValue;
    final task = state.tasks.lastValue[newTaskIndex];
    if (task.rounds > 0 || task.rounds == -1) {
      final rule = Rule(
        task,
        player: task.isPersonal ? currentPlayer : null,
        untilRound: task.rounds == -1 ? -1 : round + task.rounds,
        untilPlayerIndex: task.rounds == -1 ? -1 : currentPlayerIndex,
      );

      if (task.isUnique) {
        final originId = task.originId;
        newRules.removeWhere((oldRule) {
          if (oldRule.task.originId == originId) {
            removals.add(repo.deleteRule(oldRule.task.id));
            return true;
          } else {
            return false;
          }
        });
      }

      newRules.add(rule);
      newRules.sort();
      await repo.addRule(rule);
    }

    await Future.wait(removals);

    activeRules.addValue(newRules);
  }
}
