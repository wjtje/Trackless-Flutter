import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// A basic dialog to edit some account details
class AccountEditDetails extends StatelessWidget {
  const AccountEditDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AccountEditDetailsState(),
      child: Builder(
        builder: (context) => WillPopScope(
            child: Dialog(
              insetPadding: MediaQuery.of(context).viewInsets,
              child: Scaffold(
                appBar: AppBar(),
              ),
            ),
            onWillPop: () async {
              return true;
            }),
      ),
    );
  }
}

/// The 'global' state for the account dialog
class AccountEditDetailsState with ChangeNotifier {}
