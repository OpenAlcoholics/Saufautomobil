import 'file:///E:/saufautomobil/lib/view/widget/rules/remaining_rounds.dart';
import 'package:sam/domain/rules/rule.dart';
import 'package:sam/view/common.dart';

class RuleCard extends StatelessWidget {
  final Rule rule;

  const RuleCard(
    this.rule,
  ) : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          rule.task.text,
          maxLines: 2,
        ),
        subtitle: Text(rule.player),
        trailing: RemainingRounds(rule.untilRound),
      ),
    );
  }
}
