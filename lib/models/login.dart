class Login {
  final String bearer;

  Login({this.bearer});

  // Convert from json
  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(bearer: json['bearer']);
  }
}
