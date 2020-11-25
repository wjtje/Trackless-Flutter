import 'dart:async';
import 'dart:convert';

import 'package:trackless/bloc/work_fromServer.dart';
import 'package:trackless/main.dart';
import 'package:trackless/models/work.dart';
import 'package:trackless/bloc/work_storage.dart';
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
    // Load something into list output
    _inWork.add(_list);

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
        loadWorkFromServer(this.startDate, this.endDate);
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
