import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

/// A [TracklessWorktype] will store all the information for a single worktype
class TracklessWorktype {
  /// An uniqe ID for the worktype
  final int worktypeID;

  /// The name of this worktype
  final String name;

  /// Null values are not allowed and everything needs to be defined
  TracklessWorktype({@required this.worktypeID, @required this.name});

  /// Calculate a hash for this object
  ///
  /// This can be used to compare two objects
  String get hash =>
      sha256.convert(utf8.encode('${this.worktypeID} ${this.name}')).toString();

  /// Convert json to a [TracklessWorktype] object
  factory TracklessWorktype.fromJson(Map<String, dynamic> json) {
    // Check for nulls
    if (json.containsKey('worktypeID') && json.containsKey('name')) {
      return TracklessWorktype(
          worktypeID: json['worktypeID'], name: json['name']);
    } else {
      throw FormatException();
    }
  }

  /// Convert a [TracklessWorktype] object to json
  Map<String, dynamic> toJson() {
    return {'worktypeID': this.worktypeID, 'name': this.name};
  }

  /// Convert a [TracklessWorktype] to a string
  @override
  String toString() {
    return 'TracklessWorktype: ${this.worktypeID} - ${this.name}';
  }
}
