class User {
  final String name;
  final bool isActive;

  User({
    required this.name,
    this.isActive = true,
  });

  User withActive(bool isActive) {
    return User(
      name: name,
      isActive: isActive,
    );
  }
}
