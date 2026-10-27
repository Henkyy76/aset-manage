class UserProfile {
  final String username;
  // WARNING: Storing passwords in plaintext is not secure for production apps.
  final String password;

  UserProfile({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> map) {
    return UserProfile(
      username: map['username'] as String,
      password: map['password'] as String,
    );
  }

  UserProfile copyWith({
    String? username,
    String? password,
  }) {
    return UserProfile(
      username: username ?? this.username,
      password: password ?? this.password,
    );
  }
}
