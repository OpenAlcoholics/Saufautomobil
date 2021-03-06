class User {
  final String name;
  bool _isActive;

  bool get isActive => _isActive;

  User({
    required this.name,
    bool isActive = true,
  }) : this._isActive = isActive;
}
