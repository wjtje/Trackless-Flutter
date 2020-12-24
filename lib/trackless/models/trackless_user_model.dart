import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

/// A TracklessUser object will store all the data for a single user
class TracklessUser {
  /// An uniqe ID for this user
  final int userID;

  /// The user's firstname
  final String firstname;

  /// The user's lastname
  final String lastname;

  /// The user's username
  final String username;

  /// The uniqe ID for this user's group
  final int groupID;

  /// The name for this user's group
  final String groupName;

  /// Null values are not allowed and everything needs to be defined
  TracklessUser(
      {@required this.userID,
      @required this.firstname,
      @required this.lastname,
      @required this.username,
      @required this.groupID,
      @required this.groupName});

  /// Get the user's full name
  ///
  /// Example: Jhon Doe
  String get fullName => '${this.firstname} ${this.lastname}';

  /// Calculates a hash for this object
  ///
  /// This can be used the compare two objects
  String get hash => sha256
      .convert(utf8.encode(
          '${this.userID} ${this.firstname} ${this.lastname} ${this.username} ${this.groupID} ${this.groupName}'))
      .toString();

  /// Convert a json object to a [TracklessUser] object
  factory TracklessUser.fromJson(Map<String, dynamic> json) {
    // Check is the json contains everything
    if (json.containsKey('userID') &&
        json.containsKey('firstname') &&
        json.containsKey('lastname') &&
        json.containsKey('username') &&
        json.containsKey('groupID') &&
        json.containsKey('groupName')) {
      return TracklessUser(
          userID: json['userID'],
          firstname: json['firstname'],
          lastname: json['lastname'],
          username: json['username'],
          groupID: json['groupID'],
          groupName: json['groupName']);
    } else {
      print('TracklessUser: error');
      throw FormatException();
    }
  }

  /// Convert a [TracklessUser] to a json object
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

  /// Convert a [TracklessUser] to a string
  @override
  String toString() {
    return 'TracklessUser: ${this.fullName}';
  }
}
