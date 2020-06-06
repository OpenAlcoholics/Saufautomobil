import 'package:sam/domain/model.dart';
import 'package:sam/domain/repository.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = "tasks";

const COLUMN_INDEX = "task_index";
const COLUMN_TEXT = "task_text";
const COLUMN_COUNT = "count";
const COLUMN_USES = "uses";
const COLUMN_ROUNDS = "rounds";
const COLUMN_REMOTE = "remote";
const COLUMN_UNIQUE = "task_unique";

class TaskRepository implements Repository {
  final Database _connection;

  TaskRepository(this._connection);

  @override
  Future<void> createIfNotExists() async {
    await _connection.execute("""
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        $COLUMN_INDEX INTEGER PRIMARY KEY, 
        $COLUMN_TEXT TEXT UNIQUE NOT NULL, 
        $COLUMN_COUNT INTEGER NOT NULL, 
        $COLUMN_USES INTEGER NOT NULL, 
        $COLUMN_ROUNDS INTEGER NOT NULL, 
        $COLUMN_REMOTE INTEGER NOT NULL, 
        $COLUMN_UNIQUE INTEGER NOT NULL
    )
    """);
  }

  Future<void> setTasks(List<Task> tasks) async {
    await _connection.delete(TABLE_NAME);
    if (tasks.isEmpty) {
      return;
    }
    final batch = _connection.batch();
    for (var index = 0; index < tasks.length; ++index) {
      final task = tasks[index];
      batch.insert(TABLE_NAME, {
        COLUMN_INDEX: index,
        COLUMN_TEXT: task.text,
        COLUMN_COUNT: task.count,
        COLUMN_USES: task.uses,
        COLUMN_ROUNDS: task.rounds,
        COLUMN_REMOTE: task.remote ? 1 : 0,
        COLUMN_UNIQUE: task.unique ? 1 : 0,
      });
    }
    await batch.commit();
  }

  Future<List<Task>> getTasks() async {
    final query = await _connection.query(TABLE_NAME);
    final result = List<Task>(query.length);
    for (final entry in query) {
      final index = entry[COLUMN_INDEX];
      final task = Task(
        text: entry[COLUMN_TEXT],
        count: entry[COLUMN_COUNT],
        uses: entry[COLUMN_USES],
        rounds: entry[COLUMN_ROUNDS],
        remote: entry[COLUMN_REMOTE] == 1,
        unique: entry[COLUMN_UNIQUE] == 1,
      );
      result[index] = task;
    }
    return result;
  }
}
