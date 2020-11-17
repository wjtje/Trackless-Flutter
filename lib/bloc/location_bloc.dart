import 'dart:async';
import 'dart:convert';

import 'package:trackless/main.dart';
import 'package:trackless/models/location.dart';
import 'package:trackless/bloc/location_storage.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart';

import './location_event.dart';

class LocationBloc {
  // Connect to the local storage
  final LocationStorage locationStorage = LocationStorage();
  StreamSubscription<Map<String, dynamic>> locationStorageSubscription;

  // Create a local list for storing location
  List<Location> _list = new List<Location>();

  // Create a stream output
  final _stateController = StreamController<List<Location>>();
  StreamSink<List<Location>> get _inLocation => _stateController.sink;
  Stream<List<Location>> get location => _stateController.stream;

  // Create a event input
  final _eventController = StreamController<LocationEvent>();
  Sink<LocationEvent> get locationEventSink => _eventController.sink;

  LocationBloc() {
    print("LocationBloc: created");

    // Load the data from storage
    () async {
      print('LocationBloc: loading from storage');
      List<Location> fromStorage = locationStorage.loadLocation();
      _list = fromStorage;

      // Check if the stream is active
      if (!_stateController.isClosed) {
        _inLocation.add(_list);
      }
    }();

    // Listen to the localStorage for updates
    locationStorageSubscription = storageSteam.listen((event) {
      print('LocationBloc: Storage upgrade');
      // Check if there are differnces between the data
      List<Location> fromStorage = locationStorage.loadLocation();
      String fromStorageHash =
          md5.convert(utf8.encode(jsonEncode(fromStorage))).toString();
      String listHash = md5.convert(utf8.encode(jsonEncode(_list))).toString();

      if (fromStorageHash != listHash) {
        print('LocationBloc: updating storage');
        _list = fromStorage;

        // Check if the stream is active
        if (!_stateController.isClosed) {
          _inLocation.add(_list);
        }
      }
    });

    // Listen to the event controller
    _eventController.stream.listen((event) {
      if (event is LoadLocationFromServer) {
        // Test if apiKey and serverUrl is present
        () async {
          // Get the required information
          final String apiKey = storage.getItem('apiKey');
          final String serverUrl = storage.getItem('serverUrl');

          // Create a tmp buffer
          List<Location> tmp = new List<Location>();

          if (apiKey != null && serverUrl != null) {
            // Get the data from the server
            print('LocationBloc: fetching location: $serverUrl/location');

            final response = await http.get('$serverUrl/location',
                headers: {'Authorization': 'Bearer $apiKey'});

            if (response.statusCode == 200) {
              // Parse the JSON
              List<dynamic> values = new List<dynamic>();
              values = json.decode(response.body);

              if (values.length > 0) {
                for (int i = 0; i < values.length; i++) {
                  if (values[i] != null) {
                    // Convert to location object
                    tmp.add(Location.fromJson(values[i]));
                  }
                }
              }

              // Save the result
              _list = tmp;

              locationStorage.saveLocationOverride(_list);

              // Check if the stream is active
              if (!_stateController.isClosed) {
                _inLocation.add(_list);
              }
            } else {
              throw Exception('Failed to load location');
            }
          }
        }();
      }
    });
  }

  // Close all the streams
  void dispose() {
    print('LocationBloc: closing');
    _stateController.close();
    _eventController.close();
    locationStorageSubscription.cancel();
  }

  /// Get a [Location] by a id
  Location getById(int id) {
    Location result;

    _list.forEach((element) {
      if (element.locationID == id) {
        result = element;
      }
    });

    // Return null if not found
    return result;
  }
}
