import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'package:trackless/main.dart';
import 'package:http/http.dart' as http;
import 'package:trackless/trackless/models/trackless_worktype_model.dart';

import 'trackless_failure.dart';

class TracklessWorktypeProvider with ChangeNotifier {
  List<TracklessWorktype> _worktypeList;

  // Open the localStorage
  final LocalStorage _localStorage = LocalStorage('trackless_worktype');

  /// The complete worktype list
  ///
  /// WARNING: This can be null
  List<TracklessWorktype> get worktypeList => _worktypeList;

  /// Setting the worktypeList directly is not recommended
  ///
  /// This is only useful is a debug enviroment
  set worktypeList(List<TracklessWorktype> newList) {
    _worktypeList = newList;
    notifyListeners();
  }

  // Get all the locations from the server
  Future Function() get refreshFromServer => () async {
        // Get information from the storage
        final String apiKey = storage.getItem('apiKey');
        final String serverUrl = storage.getItem('serverUrl');

        try {
          final response = await http.get('$serverUrl/worktype',
              headers: {'Authorization': 'Bearer $apiKey'});

          // Make sure its a valid response code
          if (response.statusCode != 200) {
            throw HttpException(response.statusCode.toString());
          }

          // Clear the list
          _worktypeList = List<TracklessWorktype>();

          for (var jsonItem in json.decode(response.body)) {
            _worktypeList.add(TracklessWorktype.fromJson(jsonItem));
          }

          // Save the worktypes to local storage
          saveToStorage(_worktypeList);

          notifyListeners();
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
          throw TracklessFailure(5, detailCode: 11); // Internal error
        } on TypeError {
          throw TracklessFailure(5, detailCode: 12); // Internal error
        }
      };

  /// Save a [List<TracklessWorktype>] to [LocalStorage]
  Future Function(List<TracklessWorktype> worktypes) get saveToStorage =>
      (worktypes) async {
        await _localStorage.setItem('worktypes', worktypes);
      };

  /// Load all the worktypes from localStorage
  Future Function() get refreshFromLocalStorage => () async {
        try {
          _worktypeList = List<TracklessWorktype>();

          // Parse the json
          for (var json in (_localStorage.getItem('worktypes') ?? [])) {
            _worktypeList.add(TracklessWorktype.fromJson(json));
          }

          notifyListeners();
        } on FormatException {
          throw TracklessFailure(5, detailCode: 13);
        }
      };

  /// Get a Worktype by ID
  TracklessWorktype Function(int worktypeID) get getWorktypeByID =>
      (worktypeID) {
        TracklessWorktype tmp;

        _worktypeList.forEach((element) {
          if (element.worktypeID == worktypeID) {
            tmp = element;
          }
        });

        return tmp;
      };
}
