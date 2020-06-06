import 'package:dio/dio.dart';
import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/model.dart';
import 'package:sam/domain/tasks/taskspec_state.dart';

const _TASKS_URL =
    'https://github.com/OpenAlcoholics/drinking-game-cards/raw/develop/tasks_is.json';

class TasksService {
  Future<void> updateTaskSpecs() async {
    final state = service<TaskSpecState>().tasks;
    try {
      final dio = Dio();
      dio.transformer = _JsonTransformer();
      final response = await dio.get<List<dynamic>>(_TASKS_URL);
      final parsed = response.data.map((e) => TaskSpec.fromJson(e));
      state.addValue(parsed.toList(growable: false));
    } on DioError catch (e) {
      state.addError(e);
    }
  }
}

class _JsonTransformer extends DefaultTransformer {
  @override
  Future transformResponse(RequestOptions options, ResponseBody response) {
    response.headers['content-type'] = ['application/json'];
    return super.transformResponse(options, response);
  }
}
