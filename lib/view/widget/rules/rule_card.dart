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
        isThreeLine: true,
        // TODO actually calculate
        trailing: Text(
          "0",
          textScaleFactor: 2,
        ),
      ),
    );
  }
}
