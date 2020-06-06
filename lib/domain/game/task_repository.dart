import 'package:sam/domain/game/task.dart';
import 'package:sam/domain/repository.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = "tasks";

const COLUMN_ID = "task_id";
const COLUMN_ORIGIN_ID = "origin_id";
const COLUMN_INDEX = "task_index";
const COLUMN_TEXT = "task_text";
const COLUMN_USES = "uses";
const COLUMN_ROUNDS = "rounds";
const COLUMN_UNIQUE = "task_unique";

class TaskRepository implements Repository {
  final Database _connection;

  TaskRepository(this._connection);

  @override
  Future<void> createIfNotExists() async {
    await _connection.execute("""
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        $COLUMN_ID TEXT PRIMARY KEY, 
        $COLUMN_ORIGIN_ID TEXT NOT NULL, 
        $COLUMN_INDEX INTEGER UNIQUE NOT NULL, 
        $COLUMN_TEXT TEXT NOT NULL, 
        $COLUMN_USES INTEGER NOT NULL, 
        $COLUMN_ROUNDS INTEGER NOT NULL, 
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
        COLUMN_ID: task.id,
        COLUMN_ORIGIN_ID: task.originId,
        COLUMN_INDEX: index,
        COLUMN_TEXT: task.text,
        COLUMN_USES: task.uses,
        COLUMN_ROUNDS: task.rounds,
        COLUMN_UNIQUE: task.isUnique ? 1 : 0,
      });
    }
    await batch.commit();
  }

  Future<List<Task>> getTasks() async {
    final query = await _connection.query(TABLE_NAME);
    final result = List<Task>(query.length);
    for (final entry in query) {
      final index = entry[COLUMN_INDEX];
      final task = fromEntry(entry);
      result[index] = task;
    }
    return result;
  }

  Task fromEntry(Map<String, dynamic> entry) {
    return Task(
      id: entry[COLUMN_ID],
      originId: entry[COLUMN_ORIGIN_ID],
      text: entry[COLUMN_TEXT],
      uses: entry[COLUMN_USES],
      rounds: entry[COLUMN_ROUNDS],
      isUnique: entry[COLUMN_UNIQUE] == 1,
    );
  }
}
