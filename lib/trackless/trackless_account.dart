import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:trackless/main.dart';
import 'package:trackless/trackless/models/trackless_user_model.dart';
import 'package:http/http.dart' as http;
import 'package:trackless/trackless/trackless_failure.dart';

class TracklessAccount with ChangeNotifier {
  TracklessUser _user;

  // Open the localStorage
  final LocalStorage _localStorage = new LocalStorage('trackless_account');

  /// The complete TracklessUser object
  ///
  /// WARNING: this can be null
  TracklessUser get tracklessUser => _user;

  /// This is just for testing
  ///
  /// DO NOT USE IT IN PRODUCTION
  set tracklessUser(TracklessUser newUser) {
    if ((_user?.hash ?? '') != (newUser?.hash ?? '')) {
      _user = newUser;
      notifyListeners();
    }
  }

  /// Get the latest account details from the server
  ///
  /// This function will save the result in LocalStorage
  Future<void> Function() get refreshFromServer => () async {
        // Get infomation from the storage
        final String apiKey = storage.getItem('apiKey');
        final String serverUrl = storage.getItem('serverUrl');

        try {
          final response = await http.get('$serverUrl/user/~',
              headers: {'Authorization': 'Bearer $apiKey'});

          // Make sure its a valid response code
          if (response.statusCode != 200) {
            throw HttpException(response.statusCode.toString());
          }

          // Parse the json
          final newUser = TracklessUser.fromJson(json.decode(response.body)[0]);

          // Make sure there are changes
          if ((_user?.hash ?? '') != newUser.hash) {
            _user = newUser;
            notifyListeners(); // This will update the ui

            await _localStorage.ready; // Make sure the storage is ready

            _localStorage.setItem('currentAccount', _user);
          }
        } on SocketException {
          throw TracklessFailure(1); // No internet connection
        } on HttpException catch (e) {
          switch (e.message) {
            case '401':
              throw TracklessFailure(2); // Unauthorized
            case '404':
              throw TracklessFailure(3); // Not found
            default:
              throw TracklessFailure(4); // Internal server error
          }
        } on FormatException {
          throw TracklessFailure(5); // Internal error
        } on RangeError {
          throw TracklessFailure(5, detailCode: 1); // Internal error
        }
      };

  /// Get the latest details from localstorage
  Future<void> Function() get refreshFromLocalStorage => () async {
        await _localStorage.ready; // Make sure the storage is ready

        final json = _localStorage.getItem('currentAccount');

        try {
          final newUser = TracklessUser.fromJson(json);

          // Update the ui
          if ((_user?.hash ?? '') != newUser.hash) {
            _user = newUser;
            notifyListeners();
          }
        } on TypeError {
          throw TracklessFailure(5, detailCode: 2); // Internal error
        } on FormatException {
          throw TracklessFailure(5, detailCode: 3); // Internal error
        }
      };

  @override
  void dispose() {
    // Clean up the function
    _localStorage?.dispose();
    super.dispose();
  }
}
