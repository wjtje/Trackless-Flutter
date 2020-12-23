import 'package:flutter/material.dart';

class AccountOptions extends StatelessWidget {
  const AccountOptions({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Options for your account',
              style: Theme.of(context).textTheme.headline6),
          SizedBox(
            height: 8,
          ),
          ListTile(
            leading: Icon(Icons.vpn_key),
            title: Text('Change password'),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.devices),
            title: Text('Connected devices'),
          ),
          ListTile(
            leading: Icon(Icons.file_download),
            title: Text('Download details'),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit details'),
          )
        ],
      ),
    );
  }
}
