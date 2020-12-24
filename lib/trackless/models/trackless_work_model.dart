import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:trackless/trackless/models/trackless_location_model.dart';
import 'package:trackless/trackless/models/trackless_user_model.dart';
import 'package:trackless/trackless/models/trackless_worktype_model.dart';

/// A [TracklessWork] will store all the information for a single work thingie
class TracklessWork {
  /// An uniqe ID for this work
  final int workID;

  /// The user that has done this work
  final TracklessUser user;

  /// The location where this work has been done
  final TracklessLocation location;

  /// The type of work that has been done
  final TracklessWorktype worktype;

  /// The amount of time spend doing this work
  final double time;

  /// The date when this work has been done
  final String date;

  /// A description of the work that has been done
  final String description;

  /// Null values are not allowed and everything needs to be defined
  TracklessWork(
      {@required this.workID,
      @required this.user,
      @required this.location,
      @required this.worktype,
      @required this.time,
      @required this.date,
      @required this.description});

  /// Calculate a hash for this object
  ///
  /// This can be used to compare two objects
  String get hash => sha256
      .convert(utf8.encode(
          '${this.workID} ${this.user.hash} ${this.location.hash} ${this.worktype.hash} ${this.time} ${this.date} ${this.description}'))
      .toString();

  /// Convert json to a [TracklessWork] object
  factory TracklessWork.fromJson(Map<String, dynamic> json) {
    // Check if the map contains everything
    if (json.containsKey('workID') &&
        json.containsKey('user') &&
        json.containsKey('location') &&
        json.containsKey('worktype') &&
        json.containsKey('time') &&
        json.containsKey('date') &&
        json.containsKey('description')) {
      return TracklessWork(
          workID: json['workID'],
          user: TracklessUser.fromJson(json['user']),
          location: TracklessLocation.fromJson(json['location']),
          worktype: TracklessWorktype.fromJson(json['worktype']),
          time: double.parse(json['time'].toString()),
          date: json['date'],
          description: json['description']);
    } else {
      throw FormatException();
    }
  }

  /// Converts a [TracklessWork] object to json
  Map<String, dynamic> toJson() {
    return {
      'workID': this.workID,
      'user': this.user.toJson(),
      'location': this.location.toJson(),
      'worktype': this.worktype.toJson(),
      'time': this.time,
      'date': this.date,
      'description': this.description
    };
  }

  /// Converts a [TracklessWork] object to a string
  @override
  String toString() {
    return 'TracklessWork: ${this.date} - ${this.time} - ${this.description} - ${this.location.place}';
  }
}
