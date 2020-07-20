class LoginUser {
  final String username;
  final String password;

  LoginUser({this.username, this.password});

  factory LoginUser.fromJson(Map<String, dynamic> json) {
    return LoginUser(
      username: json['username'],
      password: json['password'],
    );
  }
}
