import 'package:sam/data/dependency_model.dart';
import 'package:sam/data/stateful_stream.dart';
import 'package:sam/domain/tasks/taskspec_service.dart';

class InitController {
  UpdatableStatefulStream<bool> _tasksLoaded = UpdatableStatefulStream(false);

  StatefulStream<bool> get tasksLoaded => _tasksLoaded;

  Future<void> updateTaskSpecs() async {
    _tasksLoaded.addValue(false);
    await service<TasksService>().updateTaskSpecs();
    _tasksLoaded.addValue(true);
  }

  void dispose() {
    _tasksLoaded.dispose();
  }
}
