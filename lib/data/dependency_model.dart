import 'package:get_it/get_it.dart';
import 'package:sam/domain/tasks/tasks_service.dart';
import 'package:sam/domain/tasks/tasks_state.dart';

final service = GetIt.instance;

class DependencyModel {
  Future<void> init() async {
    service.registerSingleton(TasksState());

    service.registerSingleton(TasksService());
  }
}
