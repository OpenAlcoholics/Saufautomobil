import 'package:sam/data/stateful_stream.dart';
import 'package:sam/domain/model.dart';

class TaskSpecState {
  final UpdatableStatefulStream<List<TaskSpec>> tasks =
      UpdatableStatefulStream();
}
