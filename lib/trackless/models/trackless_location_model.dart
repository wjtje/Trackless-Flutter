import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

/// A [TracklessLocation] will store all the information for a single location
class TracklessLocation {
  /// An uniqe ID for the location
  final int locationID;

  /// Is the location hidden or not?
  final bool hidden;

  /// The name of the person
  final String name;

  /// The place of the person
  final String place;

  /// The internal id
  final String id;

  /// The total time worked on this location
  final double time;

  /// Null values are not allowed and everything needs to be defined
  TracklessLocation(
      {@required this.locationID,
      @required this.hidden,
      @required this.name,
      @required this.place,
      @required this.id,
      @required this.time});

  /// Calculate a hash for this object
  ///
  /// This can be used to compare two objects
  String get hash => sha256
      .convert(utf8.encode('$locationID $hidden $name $place $id $time'))
      .toString();

  /// Gets the full name of a location
  ///
  /// place - name
  String get fullName => '$place - $name';

  /// Convert json to a [TracklessLocation] object
  factory TracklessLocation.fromJson(Map<String, dynamic> json) {
    // Check if the map contains everything
    if (json.containsKey('locationID') &&
        json.containsKey('hidden') &&
        json.containsKey('name') &&
        json.containsKey('place') &&
        json.containsKey('id') &&
        json.containsKey('time')) {
      return TracklessLocation(
          locationID: json['locationID'],
          hidden: (json['hidden'] == 1),
          name: json['name'],
          place: json['place'],
          id: json['id'],
          time: double.parse(json['time'].toString()));
    } else {
      throw FormatException();
    }
  }

  /// Converts a [TracklessLocation] object to json
  Map<String, dynamic> toJson() {
    return {
      'locationID': this.locationID,
      'hidden': this.hidden,
      'name': this.name,
      'place': this.place,
      'id': this.id,
      'time': this.time
    };
  }

  /// Converts a [TracklessLocation] object to a string
  @override
  String toString() {
    return 'TracklessLocation: ${this.place} - ${this.name}';
  }
}
