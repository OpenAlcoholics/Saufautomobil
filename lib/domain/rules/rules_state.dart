import 'package:sam/data/stateful_stream.dart';
import 'package:sam/domain/rules/rule.dart';

class RulesState {
  UpdatableStatefulStream<List<Rule>> activeRules = UpdatableStatefulStream();
}
