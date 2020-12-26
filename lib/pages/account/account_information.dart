import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:trackless/app_localizations.dart';
import 'package:trackless/trackless/trackless_account.dart';

class AccountInformation extends StatelessWidget {
  const AccountInformation({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<TracklessAccount>(context).tracklessUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Welcome the user
          (account?.fullName != null)
              ? Text(
                  '${AppLocalizations.of(context).translate('account_welcome')} ${account?.fullName}!',
                  style: Theme.of(context).textTheme.headline5,
                )
              : SkeletonText(
                  height: 24,
                  padding: 2.0,
                ),
          // Your details title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              '${AppLocalizations.of(context).translate('account_details')} ',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tags
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(AppLocalizations.of(context)
                      .translate('account_firstname')),
                  Text(AppLocalizations.of(context)
                      .translate('account_lastname')),
                  Text(AppLocalizations.of(context)
                      .translate('account_username')),
                  Text(AppLocalizations.of(context).translate('account_group'))
                ],
              ),
              // Spacing
              SizedBox(
                width: 16,
              ),
              // Data
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (account?.firstname != null)
                      ? Text(account.firstname)
                      : SkeletonText(
                          height: 12,
                          padding: 2.0,
                        ),
                  (account?.lastname != null)
                      ? Text(account.lastname)
                      : SkeletonText(
                          height: 12,
                          padding: 2.0,
                        ),
                  (account?.username != null)
                      ? Text(account.username)
                      : SkeletonText(
                          height: 12,
                          padding: 2.0,
                        ),
                  (account?.groupName != null)
                      ? Text(account.groupName)
                      : SkeletonText(
                          height: 12,
                          padding: 2.0,
                        ),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
