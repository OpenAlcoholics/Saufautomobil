import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/rule.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/rules/rule_card.dart';
import 'package:sam/view/widget/stateful_stream_builder.dart';

class RulesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatefulStreamBuilder<List<Rule>>(
      stream: service<GameState>().activeRules,
      builder: (context, _, rules) {
        if (rules.isEmpty) {
          return Center(
            child: Text(context.messages.rules.noActive),
          );
        } else {
          return ListView.builder(
            itemCount: rules.length,
            itemBuilder: (context, index) {
              final rule = rules[index];
              return RuleCard(rule);
            },
          );
        }
      },
    );
  }
}
