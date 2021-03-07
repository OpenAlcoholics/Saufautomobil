import 'package:uuid/uuid.dart';

class User {
  final UuidValue id;
  final String name;
  final bool isActive;

  User._({
    required this.id,
    required this.name,
    required this.isActive,
  });

  factory User.create({
    required String name,
    bool isActive = true,
    UuidValue? id,
  }) {
    return User._(
      id: id ?? Uuid().v4obj(),
      name: name,
      isActive: isActive,
    );
  }

  User withActive(bool isActive) {
    return User._(
      id: id,
      name: name,
      isActive: isActive,
    );
  }
}
