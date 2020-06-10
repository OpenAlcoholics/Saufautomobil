import 'package:sam/domain/game/rule.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/rules/remaining_rounds.dart';

class RuleCard extends StatelessWidget {
  final Rule rule;

  const RuleCard(
    this.rule,
  ) : super();

  @override
  Widget build(BuildContext context) {
    final text = rule.task.text;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rule.player ?? context.messages.common.everyone,
                    style: TextStyle(
                      inherit: true,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    text,
                    softWrap: true,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 5),
            RemainingRounds(rule.untilRound),
          ],
        ),
      ),
    );
  }
}
