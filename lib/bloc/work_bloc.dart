import 'dart:async';
import 'dart:convert';

import 'package:trackless/main.dart';
import 'package:trackless/models/work.dart';
import 'package:trackless/bloc/work_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:crypto/crypto.dart';

import './work_event.dart';

class WorkBloc {
  final DateTime startDate;
  final DateTime endDate;

  // Connect to the local storage
  final WorkStorage workStorage = WorkStorage();
  StreamSubscription<Map<String, dynamic>> workStorageSubscription;

  // Create a local list for storing work
  List<Work> _list = new List<Work>();

  // Create a stream output
  final _stateController = StreamController<List<Work>>();
  StreamSink<List<Work>> get _inWork => _stateController.sink;
  Stream<List<Work>> get work => _stateController.stream;

  // Create a event input
  final _eventController = StreamController<WorkEvent>();
  Sink<WorkEvent> get workEventSink => _eventController.sink;

  WorkBloc({this.startDate, this.endDate}) {
    print(
        "WorkBloc: startDate: ${this.startDate.toString()} endDate: ${this.endDate.toString()}");

    // Load the data from storage
    () async {
      print('WorkBloc: loading from storage');
      List<Work> fromStorage = workStorage.loadWork(startDate, endDate);
      _list = fromStorage;

      // Check if the stream is active
      if (!_stateController.isClosed) {
        _inWork.add(_list);
      }
    }();

    // Listen to the localStorage for updates
    workStorageSubscription = storageSteam.listen((event) {
      print('WorkBloc: Storage upgrade');
      // Check if there are differnces between the data
      List<Work> fromStorage = workStorage.loadWork(startDate, endDate);
      String fromStorageHash =
          md5.convert(utf8.encode(jsonEncode(fromStorage))).toString();
      String listHash = md5.convert(utf8.encode(jsonEncode(_list))).toString();

      if (fromStorageHash != listHash) {
        print('WorkBloc: updating storage');
        _list = fromStorage;

        // Check if the stream is active
        if (!_stateController.isClosed) {
          _inWork.add(_list);
        }
      }
    });

    // Listen to the event controller
    _eventController.stream.listen((event) {
      if (event is LoadWorkFromServer) {
        // Test if apiKey and serverUrl is present
        () async {
          // Get the required information
          final String apiKey = storage.getItem('apiKey');
          final String serverUrl = storage.getItem('serverUrl');
          final String startDateFormat =
              new DateFormat('yyyy-MM-dd').format(this.startDate);
          final String endDateFormat =
              new DateFormat('yyyy-MM-dd').format(this.endDate);

          // Create a tmp buffer
          List<Work> tmp = new List<Work>();

          if (apiKey != null && serverUrl != null) {
            // Get the data from the server
            print(
                'WorkBloc: fetching work: $serverUrl/user/~/work?startDate=$startDateFormat&endDate=$endDateFormat&order=date');

            final response = await http.get(
                '$serverUrl/user/~/work?startDate=$startDateFormat&endDate=$endDateFormat&order=date',
                headers: {'Authorization': 'Bearer $apiKey'});

            if (response.statusCode == 200) {
              // Parse the JSON
              List<dynamic> values = new List<dynamic>();
              values = json.decode(response.body);

              if (values.length > 0) {
                for (int i = 0; i < values.length; i++) {
                  if (values[i] != null) {
                    // Convert to work object
                    tmp.add(Work.fromJson(values[i]));
                  }
                }
              }

              // Sort the list
              tmp.sort((a, b) {
                DateTime aDate = DateTime.parse(a.date);
                DateTime bDate = DateTime.parse(b.date);
                return -aDate.compareTo(bDate);
              });

              // Save the result
              _list = tmp;

              workStorage.saveWorkOverride(_list);

              // Check if the stream is active
              if (!_stateController.isClosed) {
                _inWork.add(_list);
              }
            } else {
              throw Exception('Failed to load work');
            }
          }
        }();
      }
    });
  }

  // Close all the streams
  void dispose() {
    print('WorkBloc: closing');
    _stateController.close();
    _eventController.close();
    workStorageSubscription.cancel();
  }
}
