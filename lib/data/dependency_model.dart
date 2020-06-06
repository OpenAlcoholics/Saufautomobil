import 'package:get_it/get_it.dart';
import 'package:sam/domain/game/game_service.dart';
import 'package:sam/domain/game/game_state.dart';
import 'package:sam/domain/game/reset_service.dart';
import 'package:sam/domain/game/rules_service.dart';
import 'package:sam/domain/tasks/tasks_service.dart';
import 'package:sam/domain/tasks/tasks_state.dart';

final service = GetIt.instance;

class DependencyModel {
  Future<void> init() async {
    service.registerSingleton(TasksState());
    service.registerSingleton(GameState());

    service.registerSingleton(ResetService());
    service.registerSingleton(RulesService());
    service.registerSingleton(TasksService());
    service.registerSingleton(GameService());
  }
}
