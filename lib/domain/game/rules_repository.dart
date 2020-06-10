import 'package:sam/domain/game/rule.dart';
import 'package:sam/domain/repository.dart';
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = "rules";

const COLUMN_TASK_ID = "task_id";
const COLUMN_UNTIL = "until_round";
const COLUMN_UNTIL_PLAYER = "until_player_index";
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
        $COLUMN_UNTIL_PLAYER INTEGER, 
        $COLUMN_PLAYER STRING
    )
    """);
  }

  Future<void> addRule(Rule rule) async {
    await _connection.insert(TABLE_NAME, {
      COLUMN_TASK_ID: rule.task.id,
      COLUMN_PLAYER: rule.player,
      COLUMN_UNTIL: rule.untilRound,
      COLUMN_UNTIL_PLAYER: rule.untilPlayerIndex,
    });
  }

  Future<List<TasklessRule>> getRules() async {
    final query = await _connection.query(TABLE_NAME, orderBy: COLUMN_UNTIL);
    final result = List<TasklessRule>();
    for (final entry in query) {
      final task = TasklessRule(
        player: entry[COLUMN_PLAYER],
        untilRound: entry[COLUMN_UNTIL],
        untilPlayerIndex: entry[COLUMN_UNTIL_PLAYER],
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

  Future<void> deleteRulesWhereTasks(Iterable<String> taskIds) async {
    final batch = _connection.batch();
    for (final taskId in taskIds) {
      batch.delete(
        TABLE_NAME,
        where: "$COLUMN_TASK_ID = ?",
        whereArgs: [taskId],
      );
    }
    await batch.commit();
  }

  Future<void> deleteRules() async {
    await _connection.delete(TABLE_NAME);
  }
}

class TasklessRule {
  final String taskId;
  final String player;
  final int untilRound;
  final int untilPlayerIndex;

  TasklessRule({
    this.taskId,
    this.player,
    this.untilRound,
    this.untilPlayerIndex,
  });
}
