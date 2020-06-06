import 'package:sam/domain/game/player_repository.dart' as player;
import 'package:sam/domain/game/rule.dart';
import 'package:sam/domain/game/task_repository.dart' as tasks;
import 'package:sam/domain/repository.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = "rules";

const COLUMN_TASK_ID = "task_id";
const COLUMN_UNTIL = "until_round";
const COLUMN_PLAYER = "player";

class RuleRepository implements Repository {
  final Database _connection;

  RuleRepository(this._connection);

  @override
  Future<void> createIfNotExists() async {
    await _connection.execute("""
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        $COLUMN_TASK_ID TEXT NOT NULL, 
        $COLUMN_UNTIL INTEGER, 
        $COLUMN_PLAYER STRING, 
        FOREIGN KEY ($COLUMN_TASK_ID) 
        REFERENCES ${tasks.TABLE_NAME} (${tasks.COLUMN_INDEX})
        ON DELETE CASCADE,
        FOREIGN KEY ($COLUMN_PLAYER) 
        REFERENCES ${player.TABLE_NAME} (${player.COLUMN_NAME})
        ON DELETE CASCADE
    )
    """);
  }

  Future<void> addRule(Rule rule) async {
    await _connection.insert(TABLE_NAME, {
      COLUMN_TASK_ID: rule.task.id,
      COLUMN_PLAYER: rule.player,
      COLUMN_UNTIL: rule.untilRound,
    });
  }

  Future<List<TasklessRule>> getRules() async {
    final query = await _connection.query(TABLE_NAME, orderBy: COLUMN_UNTIL);
    final result = List<TasklessRule>();
    for (final entry in query) {
      final task = TasklessRule(
        player: entry[COLUMN_PLAYER],
        untilRound: entry[COLUMN_UNTIL],
        taskId: entry[COLUMN_TASK_ID],
      );
      result.add(task);
    }
    return result;
  }

  Future<void> deleteRule(String taskId) async {
    await _connection.delete(
      TABLE_NAME,
      where: "$COLUMN_TASK_ID = ?",
      whereArgs: [taskId],
    );
  }

  Future<void> deleteRules() async {
    await _connection.delete(TABLE_NAME);
  }
}

class TasklessRule {
  final String taskId;
  final String player;
  final int untilRound;

  TasklessRule({this.taskId, this.player, this.untilRound});
}
