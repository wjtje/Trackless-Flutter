class User {
  final int userID;
  final String firstname;
  final String lastname;
  final String username;
  final int groupID;
  final String groupName;

  User(
      {this.userID,
      this.firstname,
      this.lastname,
      this.username,
      this.groupID,
      this.groupName})
      : assert(userID != null),
        assert(firstname != null),
        assert(lastname != null),
        assert(username != null),
        assert(groupID != null),
        assert(groupName != null);

  // Convert from json
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userID: json['userID'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        username: json['username'],
        groupID: json['groupID'],
        groupName: json['groupName']);
  }

  // Convert to json
  Map<String, dynamic> toJson() {
    return {
      'userID': this.userID,
      'firstname': this.firstname,
      'lastname': this.lastname,
      'username': this.username,
      'groupID': this.groupID,
      'groupName': this.groupName
    };
  }
}
