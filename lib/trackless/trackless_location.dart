import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:trackless/functions/app_failure.dart';
import 'package:trackless/main.dart';
import 'package:trackless/trackless/models/trackless_location_model.dart';
import 'package:http/http.dart' as http;

class TracklessLocationProvider with ChangeNotifier {
  List<TracklessLocation> _locationList;

  // Open the localStorage
  final LocalStorage _localStorage = LocalStorage('trackless_location');

  /// The complete location list
  ///
  /// WARNING: This can be null
  List<TracklessLocation> get locationList => _locationList;

  /// Setting the locationList directly is not recommended
  ///
  /// This is only useful is a debug enviroment
  set locationList(List<TracklessLocation> newList) {
    _locationList = newList;
    notifyListeners();
  }

  // Get all the locations from the server
  Future Function() get refreshFromServer => () async {
        // Get information from the storage
        final String apiKey = storage.getItem('apiKey');
        final String serverUrl = storage.getItem('serverUrl');

        try {
          final response = await http.get('$serverUrl/location?sort=place,name',
              headers: {'Authorization': 'Bearer $apiKey'});

          // Make sure its a valid response code
          if (response.statusCode != 200) {
            throw AppFailure.httpExecption(response);
          }

          // Clear the list
          _locationList = [];

          for (var jsonItem in json.decode(response.body)) {
            _locationList.add(TracklessLocation.fromJson(jsonItem));
          }

          // Save the locations to local storage
          saveToStorage(_locationList);

          notifyListeners();
        } on SocketException {
          throw AppFailure(3); // No internet connection
        } on FormatException {
          throw AppFailure(2, detail: 'trackless.location.formatError');
        } on RangeError {
          throw AppFailure(2, detail: 'trackless.location.rangeError');
        } on TypeError {
          throw AppFailure(2, detail: 'trackless.location.typeError');
        }
      };

  /// Save a [List<TracklessLocation>] to [LocalStorage]
  Future Function(List<TracklessLocation> locations) get saveToStorage =>
      (locations) async {
        await _localStorage.setItem('locations', locations);
      };

  /// Load all the locations from localStorage
  Future Function() get refreshFromLocalStorage => () async {
        try {
          _locationList = [];

          // Parse the json
          for (var json in (_localStorage.getItem('locations') ?? [])) {
            _locationList.add(TracklessLocation.fromJson(json));
          }

          notifyListeners();
        } on FormatException {
          throw AppFailure(2, detail: 'trackless.location.formatError');
        }
      };

  /// Get a location by ID
  TracklessLocation Function(int locationID) get getLocationByID =>
      (locationID) {
        TracklessLocation tmp;

        _locationList.forEach((element) {
          if (element.locationID == locationID) {
            tmp = element;
          }
        });

        return tmp;
      };
}
