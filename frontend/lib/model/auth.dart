class Auth {
  final String uid;
  final String email;
  final String password;

  Auth(this.uid, {required this.email, required this.password});

  factory Auth.fromJson(Map<String, dynamic> json, String password) {
    return Auth(
      json['uid'] ?? '',
      email: json['email'] ?? '',
      password: password,
    );
  }
}