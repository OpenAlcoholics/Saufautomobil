import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/tasks/tasks_service.dart';
import 'package:sam/domain/tasks/tasks_state.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/widget/loading_indicator.dart';
import 'package:sam/view/widget/stateful_stream_builder.dart';

class PlayerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.messages.page.player),
      ),
      body: StatefulStreamBuilder(
        stream: service<TasksState>().tasks,
        refresh: service<TasksService>().updateTasks,
        builder: (context, _, value) {
          if (value == null) {
            return LoadingIndicator();
          } else {
            return Text(value.toString());
          }
        },
      ),
    );
  }
}
