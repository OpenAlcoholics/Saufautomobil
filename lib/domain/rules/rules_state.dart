import 'package:sam/data/stateful_stream.dart';
import 'package:sam/domain/game/rule.dart';

class RulesState {
  UpdatableStatefulStream<List<Rule>> activeRules = UpdatableStatefulStream();
}
