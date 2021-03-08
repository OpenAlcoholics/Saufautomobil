import 'package:uuid/uuid.dart';

class User {
  final String id;
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
    String? id,
  }) {
    return User._(
      id: id ?? Uuid().v4(),
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

  User changeName(String name) {
    return User._(
      id: id,
      name: name,
      isActive: isActive,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          isActive == other.isActive;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isActive.hashCode;

  @override
  String toString() {
    return '{id: $id, name: $name, isActive: $isActive}';
  }
}
