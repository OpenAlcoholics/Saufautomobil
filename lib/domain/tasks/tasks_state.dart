import 'package:sam/data/stateful_stream.dart';
import 'package:sam/domain/model.dart';

class TasksState {
  final UpdatableStatefulStream<List<Task>> tasks = UpdatableStatefulStream();
}
