import 'package:sam/domain/model/user.dart';
import 'package:uuid/uuid.dart';

abstract class UserRepository {
  Future<void> insertUser(User user);

  Future<User?> findUser(String userId);

  Future<void> deleteUser(String userId);

  Future<void> updateUser(User user);

  Future<Set<User>> getUsers();
}
