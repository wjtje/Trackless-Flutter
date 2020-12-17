import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import '../main.dart';
import '../models/worktype.dart';
import 'worktype_storage.dart';
import 'worktype_event.dart';

class WorktypeBloc {
  // Connect to the local storage
  final WorktypeStorage worktypeStorage = WorktypeStorage();
  StreamSubscription<Map<String, dynamic>> worktypeStorageSubscription;

  // Create a local list for storing worktype
  List<Worktype> _list = new List<Worktype>();

  // Create a stream output
  final _stateController = StreamController<List<Worktype>>();
  StreamSink<List<Worktype>> get _inWorktype => _stateController.sink;
  Stream<List<Worktype>> get worktype => _stateController.stream;

  // Create a event input
  final _eventController = StreamController<WorktypeEvent>();
  Sink<WorktypeEvent> get worktypeEventSink => _eventController.sink;

  WorktypeBloc() {
    print("WorktypeBloc: created");

    // Load the data from storage
    () async {
      print('WorktypeBloc: loading from storage');
      List<Worktype> fromStorage = worktypeStorage.loadWorktype();
      _list = fromStorage;

      // Check if the stream is active
      if (!_stateController.isClosed) {
        _inWorktype.add(_list);
      }
    }();

    // Listen to the localStorage for updates
    worktypeStorageSubscription = storageSteam.listen((event) {
      print('WorktypeBloc: Storage upgrade');
      // Check if there are differnces between the data
      List<Worktype> fromStorage = worktypeStorage.loadWorktype();
      String fromStorageHash =
          md5.convert(utf8.encode(jsonEncode(fromStorage))).toString();
      String listHash = md5.convert(utf8.encode(jsonEncode(_list))).toString();

      if (fromStorageHash != listHash) {
        print('WorktypeBloc: updating storage');
        _list = fromStorage;

        // Check if the stream is active
        if (!_stateController.isClosed) {
          _inWorktype.add(_list);
        }
      }
    });

    // Listen to the event controller
    _eventController.stream.listen((event) {
      if (event is LoadWorktypeFromServer) {
        // Test if apiKey and serverUrl is present
        () async {
          // Get the required information
          final String apiKey = storage.getItem('apiKey');
          final String serverUrl = storage.getItem('serverUrl');

          // Create a tmp buffer
          List<Worktype> tmp = new List<Worktype>();

          if (apiKey != null && serverUrl != null) {
            // Get the data from the server
            print('WorktypeBloc: fetching worktype: $serverUrl/worktype');

            final response = await http.get('$serverUrl/worktype',
                headers: {'Authorization': 'Bearer $apiKey'});

            if (response.statusCode == 200) {
              // Parse the JSON
              List<dynamic> values = new List<dynamic>();
              values = json.decode(response.body);

              if (values.length > 0) {
                for (int i = 0; i < values.length; i++) {
                  if (values[i] != null) {
                    // Convert to worktype object
                    tmp.add(Worktype.fromJson(values[i]));
                  }
                }
              }

              // Save the result
              _list = tmp;

              worktypeStorage.saveWorktypeOverride(_list);

              // Check if the stream is active
              if (!_stateController.isClosed) {
                _inWorktype.add(_list);
              }
            } else {
              throw Exception('Failed to load worktype');
            }
          }
        }();
      }
    });
  }

  // Close all the streams
  void dispose() {
    print('WorktypeBloc: closing');
    _stateController.close();
    _eventController.close();
    worktypeStorageSubscription.cancel();
  }

  /// Get a [Worktype] by a id
  Worktype getById(int id) {
    Worktype result;

    _list.forEach((element) {
      if (element.worktypeID == id) {
        result = element;
      }
    });

    // Return null if not found
    return result;
  }
}
