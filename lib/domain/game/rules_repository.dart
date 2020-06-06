import 'package:sam/domain/game/player_repository.dart' as player;
import 'package:sam/domain/game/rule.dart';
import 'package:sam/domain/repository.dart';
import 'package:sam/domain/tasks/task_repository.dart' as tasks;
import 'package:sqflite/sqflite.dart';

const TABLE_NAME = "rules";

const COLUMN_TASK_INDEX = "task_index";
const COLUMN_UNTIL = "until_round";
const COLUMN_PLAYER = "player";

class RuleRepository implements Repository {
  final Database _connection;

  RuleRepository(this._connection);

  @override
  Future<void> createIfNotExists() async {
    await _connection.execute("""
    CREATE TABLE IF NOT EXISTS $TABLE_NAME (
        $COLUMN_TASK_INDEX INTEGER NOT NULL, 
        $COLUMN_UNTIL INTEGER, 
        $COLUMN_PLAYER STRING, 
        FOREIGN KEY ($COLUMN_TASK_INDEX) 
        REFERENCES ${tasks.TABLE_NAME} (${tasks.COLUMN_INDEX})
        ON DELETE CASCADE,
        FOREIGN KEY ($COLUMN_PLAYER) 
        REFERENCES ${player.TABLE_NAME} (${player.COLUMN_NAME})
        ON DELETE CASCADE
    )
    """);
  }

  Future<void> addRule(Rule rule) async {
    // TODO task index
    await _connection.insert(TABLE_NAME, {
      COLUMN_TASK_INDEX: 0,
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
        taskIndex: entry[COLUMN_TASK_INDEX],
      );
      result.add(task);
    }
    return result;
  }

  Future<void> deleteRule(int taskIndex) async {
    await _connection.delete(
      TABLE_NAME,
      where: "$COLUMN_TASK_INDEX = ?",
      whereArgs: [taskIndex],
    );
  }

  Future<void> deleteRules() async {
    await _connection.delete(TABLE_NAME);
  }
}

class TasklessRule {
  final int taskIndex;
  final String player;
  final int untilRound;

  TasklessRule({this.taskIndex, this.player, this.untilRound});
}
