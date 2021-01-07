import 'package:flutter/material.dart';
import 'package:trackless/global/app_state.dart';

final settingsPage =
    AppPage(pageTitle: 'settings_page_title', page: SettingsPage());

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text('There aren\'t any settings yet'),
    );
  }
}
