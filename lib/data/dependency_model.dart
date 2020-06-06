import 'package:get_it/get_it.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/rules/rules_service.dart';
import 'package:sam/domain/rules/rules_state.dart';
import 'package:sam/domain/tasks/tasks_service.dart';
import 'package:sam/domain/tasks/tasks_state.dart';

final service = GetIt.instance;

class DependencyModel {
  Future<void> init() async {
    service.registerSingleton(RulesState());
    service.registerSingleton(TasksState());
    service.registerSingleton(GameState());

    service.registerSingleton(RulesService());
    service.registerSingleton(TasksService());
  }
}
