class User {
  final int? userId;
  final String username;
  final String password;
  final int isAdmin;

  User({
    this.userId,
    required this.username,
    required this.password,
    this.isAdmin = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] != null
          ? int.tryParse(json['user_id'].toString())
          : null,
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      isAdmin: json['is_admin'] != null
          ? int.tryParse(json['is_admin'].toString()) ?? 0
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (userId != null) 'user_id': userId,
      'username': username,
      'password': password,
      'is_admin': isAdmin,
    };
  }

  bool get isAdministrator => isAdmin == 1;
}
