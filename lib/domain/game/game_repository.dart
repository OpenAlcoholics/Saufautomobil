import 'package:sam/domain/repository.dart';
import 'package:sqflite/sqflite.dart';

class GameRepository implements Repository {
  final Database _connection;

  GameRepository(this._connection);

  @override
  Future<void> createIfNotExists() async {
    // TODO implement
  }

  Future<void> close() {
    return _connection.close();
  }
}
