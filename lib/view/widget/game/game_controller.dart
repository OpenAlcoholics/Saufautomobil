import 'package:sam/domain/model.dart';
import 'package:sam/view/common.dart';

class GameController {
  final ValueNotifier<int> taskCount = ValueNotifier(0);
  final ValueNotifier<Task> currentTask = ValueNotifier(null);

  void dispose() {
    taskCount.dispose();
    currentTask.dispose();
  }
}
