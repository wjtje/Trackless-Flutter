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

  /// The complete work list
  ///
  /// WARNING: this can be null
  List<TracklessWork> get workList => _workList;

  /// This for debug only
  ///
  /// setting the workList self is not recommended
  set workList(List<TracklessWork> newWork) {
    _workList = newWork;
    notifyListeners();
  }

  /// Thhis will clear the workList
  Function get clearWorkList => () {
        _workList = null;
        notifyListeners();
      };

  /// Sort the workList by date
  List<List<TracklessWork>> get sortedWorkList => () {
        List<TracklessWork> tmp = [];
        List<List<TracklessWork>> parcedWork = [];
        String lastDate;

        // Sort the work by date
        this._workList?.forEach((element) {
          if (lastDate != element.date) {
            // Update the lastDate push tmp to parcedWork and clean the tmp
            lastDate = element.date;
            if (tmp.length > 0) {
              parcedWork.add(tmp);
            }
            tmp = [];
          }

          tmp.add(element);
        });

        // Add the last
        parcedWork.add(tmp);

        // Return null if the list is null
        if (_workList == null) {
          return null;
        } else {
          return parcedWork;
        }
      }();

  /// The start date of the work list
  DateTime get startDate => _startDate ?? DateTime.now();

  /// The end date of the work list
  DateTime get endDate => _endDate ?? DateTime.now();

  /// Get all the work between a startDate and a endDate from the server
  /// and save it to localStorage
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
          this._workList = [];

          for (var jsonItem in json.decode(response.body)) {
            _workList.add(TracklessWork.fromJson(jsonItem));
          }

          // Sort the list
          _workList.sort((a, b) {
            return -DateTime.parse(a.date).compareTo(DateTime.parse(b.date));
          });

          // Save the work to localStorage
          await this.saveToStorage(this.sortedWorkList, startDate, endDate);

          // Update the start and end date
          // Make sure only the year, month and date are saved
          _startDate =
              DateTime.parse(DateFormat('yyyy-MM-dd').format(startDate));
          _endDate = DateTime.parse(DateFormat('yyyy-MM-dd').format(endDate));

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

  /// Save a [List<List<TracklessWork>>] object to [LocalStorage]
  Future Function(
          List<List<TracklessWork>> work, DateTime startDate, DateTime endDate)
      get saveToStorage => (work, startDate, endDate) async {
            // Clean the localStorage
            DateTime tmpDate = startDate;

            while (!tmpDate.isAfter(endDate)) {
              await _localStorage
                  .deleteItem(DateFormat('yyyy-MM-dd').format(tmpDate));

              // Go to the next day
              tmpDate = tmpDate.add(Duration(days: 1));
            }

            // Save new data
            work.forEach((element) {
              // Make sure there is data to save
              if (element.length > 0) {
                try {
                  _localStorage.setItem(element[0].date, element);
                } on RangeError {
                  throw TracklessFailure(5, detailCode: 6);
                }
              }
            });
          };

  /// Load work from the localStorage
  Future Function(DateTime startDate, DateTime endDate)
      get refreshFromLocalStorage => (startDate, endDate) async {
            List<TracklessWork> tmp = [];
            DateTime tmpDate = endDate;

            // Make sure to load the last day first
            try {
              while (!tmpDate.isBefore(startDate)) {
                // Load work for each date
                final List<dynamic> jsonList = _localStorage
                    .getItem(new DateFormat('yyyy-MM-dd').format(tmpDate));

                if (jsonList != null) {
                  jsonList.forEach((element) {
                    tmp.add(TracklessWork.fromJson(element));
                  });
                }

                // Go to the next date
                tmpDate = tmpDate.subtract(Duration(days: 1));
              }

              // Save the result
              _workList = tmp;

              // Update the start and end date
              // Make sure only the year, month and date are saved
              _startDate =
                  DateTime.parse(DateFormat('yyyy-MM-dd').format(startDate));
              _endDate =
                  DateTime.parse(DateFormat('yyyy-MM-dd').format(endDate));

              notifyListeners();
            } on FormatException {
              throw TracklessFailure(5, detailCode: 7);
            }
          };

  /// Saves a [TracklessWork] object to localStorage and updates the ui
  ///
  /// The _workList this function creates is not sorted
  /// It's better to refresh from server
  Future Function(TracklessWork work) get saveWork => (newWork) async {
        // Save this new work to localStorage
        List<TracklessWork> tmpList = [];

        try {
          // Get all the current work from localStorage
          final List<dynamic> jsonList = _localStorage.getItem(newWork.date);

          if (jsonList != null) {
            jsonList.forEach((json) {
              tmpList.add(TracklessWork.fromJson(json));
            });
          }
        } on TypeError {
          throw TracklessFailure(5, detailCode: 16);
        }

        // Add new work
        tmpList.add(newWork);

        // Save changes to localStorage
        await _localStorage.setItem(newWork.date, tmpList);

        // Check if we need to update the ui
        DateTime newWorkDate = DateTime.parse(newWork.date);

        if ((newWorkDate.isAtSameMomentAs(startDate) ||
                newWorkDate.isAfter(startDate)) &&
            (newWorkDate.isAtSameMomentAs(endDate) ||
                newWorkDate.isBefore(endDate))) {
          // The newWorkDate is shown
          // Update the ui
          _workList.add(newWork);

          notifyListeners();
        }
      };
}
