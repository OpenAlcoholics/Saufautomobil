import 'dart:math';

import 'package:sam/domain/game/task.dart';
import 'package:sam/domain/model.dart';

// Not exactly, but whatever
const MAX_RANDOM_INT = 1 << 32;

const MAX_TEMPLATE_INT = 7;
const MIN_TEMPLATE_INT = 2;

class TaskGenerator {
  final Random random = Random();

  List<Task> generateTasks(List<TaskSpec> specs) {
    final result = <Task>[];
    for (final spec in specs) {
      result.addAll(_generateTasks(spec));
    }
    result.shuffle(random);
    return result;
  }

  List<Task> _generateTasks(TaskSpec spec) {
    final specId = _generateId();
    final result = List<Task>(spec.count);
    for (var index = 0; index < spec.count; ++index) {
      final task = _generateTask(spec, specId);
      result[index] = task;
    }
    return result;
  }

  String _generateId() {
    return random.nextInt(MAX_RANDOM_INT).toString();
  }

  Task _generateTask(TaskSpec spec, String originId) {
    return Task(
      id: _generateId(),
      originId: originId,
      text: _processText(spec.text),
      uses: spec.uses,
      rounds: spec.rounds,
      isPersonal: spec.personal,
      isUnique: spec.unique,
    );
  }

  String _processText(String text) {
    final parts = text.split("{int}");
    return parts.reduce((value, element) => "$value${_generateInt()}$element");
  }

  int _generateInt() {
    final randomInt = random.nextInt(
      MAX_TEMPLATE_INT + 1 - MIN_TEMPLATE_INT,
    );
    return randomInt + MIN_TEMPLATE_INT;
  }
}
