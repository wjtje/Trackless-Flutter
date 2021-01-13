import 'package:flutter/material.dart';
import 'package:morpheus/morpheus.dart';
import 'package:trackless/pages/account/account_connected_devices/account_connected_devices.dart';
import 'package:trackless/pages/account/account_edit_details/account_edit_details.dart';

import '../../functions/app_localizations.dart';

class AccountOptions extends StatelessWidget {
  AccountOptions({Key key}) : super(key: key);

  final editBtnKey = GlobalKey();
  final connectedBtnKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppLocalizations.of(context).translate('account_options'),
              style: Theme.of(context).textTheme.headline6),
          SizedBox(
            height: 8,
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text(AppLocalizations.of(context)
                .translate('account_change_password')),
            onTap: () {},
          ),
          ListTile(
            key: connectedBtnKey,
            leading: Icon(Icons.devices),
            title: Text(AppLocalizations.of(context)
                .translate('account_connected_devices')),
            onTap: () {
              Navigator.push(
                  context,
                  MorpheusPageRoute(
                      parentKey: connectedBtnKey,
                      builder: (_) => AccountConnectedDevices(),
                      transitionColor:
                          Theme.of(context).scaffoldBackgroundColor));
            },
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text(AppLocalizations.of(context)
                .translate('account_download_details')),
            onTap: () {},
          ),
          ListTile(
            key: editBtnKey,
            leading: Icon(Icons.edit),
            title: Text(
                AppLocalizations.of(context).translate('account_edit_details')),
            onTap: () {
              Navigator.push(
                  context,
                  MorpheusPageRoute(
                      parentKey: editBtnKey,
                      builder: (_) => AccountEditDetails(),
                      transitionColor:
                          Theme.of(context).scaffoldBackgroundColor));
            },
          )
        ],
      ),
    );
  }
}
