import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

/// A TracklessUser object will store all the data for a single user
class TracklessUser {
  /// A uniqe ID for this user
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

  /// If you create a TracklessUser object without any data
  /// everything will be blank
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

  /// Calculate a hash for this object
  ///
  /// This can be used the compare two objects
  String get hash => sha256
      .convert(utf8.encode(
          '${this.userID} ${this.firstname} ${this.lastname} ${this.username} ${this.groupID} ${this.groupName}'))
      .toString();

  /// Convert a json object to a [TracklessUser] object
  factory TracklessUser.fromJson(Map<String, dynamic> json) {
    // Check for nulls
    if (json['userID'] == null ||
        json['firstname'] == null ||
        json['lastname'] == null ||
        json['username'] == null ||
        json['groupID'] == null ||
        json['groupName'] == null) {
      throw FormatException();
    } else {
      // No nulls found
      return TracklessUser(
          userID: json['userID'],
          firstname: json['firstname'],
          lastname: json['lastname'],
          username: json['username'],
          groupID: json['groupID'],
          groupName: json['groupName']);
    }
  }
}
