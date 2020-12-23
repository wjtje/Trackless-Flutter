import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../models/work.dart';
import 'work_storage.dart';

Future<void> loadWorkFromServer(DateTime startDate, DateTime endDate) async {
  // Get the required information
  final String apiKey = storage.getItem('apiKey');
  final String serverUrl = storage.getItem('serverUrl');
  final String startDateFormat = new DateFormat('yyyy-MM-dd').format(startDate);
  final String endDateFormat = new DateFormat('yyyy-MM-dd').format(endDate);

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
        return -a.date.compareTo(b.date);
      });

      // Save the result
      final WorkStorage workStorage = WorkStorage();
      await workStorage.saveWorkOverride(tmp, startDate, endDate);
    } else {}
  }
}
