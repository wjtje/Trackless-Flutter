import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:trackless/functions/request.dart';
import 'package:trackless/main.dart';

/// A dialog to show the devices conntected to your account
class AccountConnectedDevices extends StatefulWidget {
  const AccountConnectedDevices({Key key}) : super(key: key);

  @override
  _AccountConnectedDevicesState createState() =>
      _AccountConnectedDevicesState();
}

class _AccountConnectedDevicesState extends State<AccountConnectedDevices>
    with AfterLayoutMixin<AccountConnectedDevices> {
  StreamController<List<Map<String, dynamic>>> _controller = StreamController();

  @override
  void afterFirstLayout(BuildContext context) {
    // Fetch the data
    tryRequest(Get.context, () async {
      final response = await http.get('${storage.getItem('serverUrl')}/api',
          headers: {'Authorization': 'Bearer ${storage.getItem('apiKey')}'});

      if (response.statusCode != 200) {
        throw HttpException(response.statusCode.toString());
      }

      // Update the controller
      _controller = json.decode(response.body);
    });
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Make the appBar the correct colors
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          textTheme: Theme.of(context)
              .textTheme
              .apply(bodyColor: Theme.of(context).colorScheme.onBackground),

          iconTheme: Theme.of(context)
              .iconTheme
              .copyWith(color: Theme.of(context).colorScheme.onBackground),
          elevation: 0,
          // Show the title
          title: Text('Connected devices'),
        ),
        body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            if (snapshot == null) {
              return Text('Loading!');
            } else {
              return Text('Done!');
            }
          },
        ));
  }
}
