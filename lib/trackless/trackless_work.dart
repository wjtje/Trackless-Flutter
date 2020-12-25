import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localstorage/localstorage.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import 'models/trackless_work_model.dart';
import 'trackless_failure.dart';

class TracklessWorkProvider with ChangeNotifier {
  List<TracklessWork> _workList;

  DateTime _startDate;
  DateTime _endDate;

  // Open the localStorage
  final LocalStorage _localStorage = new LocalStorage('trackless_work');

  /// The compile work list
  ///
  /// WARNING: this can be null
  List<TracklessWork> get workList => _workList;

  /// The start date of the work list
  DateTime get startDate => _startDate;

  /// The end date of the work list
  DateTime get endDate => _endDate;

  /// Get all the work between a startDate and a endDate
  Future Function(DateTime startDate, DateTime endDate) get refreshFromServer =>
      (startDate, endDate) async {
        final startDateString = DateFormat('yyyy-MM-dd').format(startDate);
        final endDateString = DateFormat('yyyy-MM-dd').format(endDate);

        // Get information for the storage
        final String apiKey = storage.getItem('apiKey');
        final String serverUrl = storage.getItem('serverUrl');

        try {
          final response = await http.get(
              '$serverUrl/user/~/work?startDate=$startDateString&endDate=$endDateString',
              headers: {'Authorization': 'Bearer $apiKey'});

          // Make sure its a valid response code
          if (response.statusCode != 200) {
            throw HttpException(response.statusCode.toString());
          }

          // Clear the work list
          this._workList = new List<TracklessWork>();

          for (var jsonItem in json.decode(response.body)) {
            final work = TracklessWork.fromJson(jsonItem);
            await this.saveToStorage(work);
            _workList.add(work);
          }

          // Sort the list
          _workList.sort((a, b) {
            return -DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
          });

          // Update the start and end date
          _startDate = startDate;
          _endDate = endDate;

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
          throw TracklessFailure(5, detailCode: 4); // Internal error
        } on TypeError {
          throw TracklessFailure(5, detailCode: 5); // Internal error
        }
      };

  /// Save a [TracklessWork] object to [LocalStorage]
  Future Function(TracklessWork work) get saveToStorage => (work) async {
        final workOnDay = _localStorage.getItem(work.date);

        print(workOnDay);
      };
}
