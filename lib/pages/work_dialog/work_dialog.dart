import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:trackless/app_localizations.dart';
import 'package:trackless/pages/work_dialog/actions/work_dialog_delete.dart';
import 'package:trackless/pages/work_dialog/actions/work_dialog_save.dart';
import 'package:trackless/pages/work_dialog/work_dialog_body.dart';
import 'package:trackless/trackless/models/trackless_work_model.dart';
import 'package:trackless/trackless/trackless_failure.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:trackless/trackless/trackless_work.dart';

import '../../async_state.dart';

/// A dialog to add, edit and remove work
class WorkDialog extends StatelessWidget {
  final TracklessWork editWork;

  const WorkDialog(this.editWork, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WorkDialogState(editWork),
      child: Builder(
        // Show a dialog box if there are any unsaved details
        builder: (context) => WillPopScope(
          onWillPop: () async {
            final workDialogState =
                Provider.of<WorkDialogState>(context, listen: false);

            // Check if there are any onsaved changes
            bool newChanges = (workDialogState.currentLocationID != null ||
                workDialogState._currentWorktypeID != null ||
                workDialogState.currentDescription != "" ||
                workDialogState.currentTime != 0.0);

            bool editChanges = (workDialogState.currentLocationID !=
                    workDialogState.editWork?.location?.locationID ||
                workDialogState._currentWorktypeID !=
                    workDialogState.editWork?.worktype?.worktypeID ||
                workDialogState.currentDescription !=
                    workDialogState.editWork?.description ||
                workDialogState.currentTime != workDialogState.editWork?.time ||
                DateFormat('yyyy-MM-dd').format(workDialogState.currentDate) !=
                    workDialogState.editWork?.date);

            if ((workDialogState.editWork == null && newChanges) ||
                (workDialogState.editWork != null && editChanges)) {
              bool returnValue = false;

              await showDialog<bool>(
                  context: context,
                  builder: (_) => AlertDialog(
                        title: Text(AppLocalizations.of(context)
                            .translate('add_work_save_title')),
                        content: Text(AppLocalizations.of(context)
                            .translate('add_work_save_content')),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                returnValue = true;
                              },
                              child: Text(AppLocalizations.of(context)
                                  .translate('add_work_leave'))),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(AppLocalizations.of(context)
                                  .translate('add_work_stay')))
                        ],
                      ));

              return returnValue;
            } else {
              // All good
              return true;
            }
          },
          child: Scaffold(
            appBar: AppBar(
              // Make the appBar the correct colors
              backgroundColor: Theme.of(context).accentColor,
              iconTheme: Theme.of(context).accentIconTheme,
              textTheme: Theme.of(context).accentTextTheme,
              // Show the correct title
              title: Text(
                  AppLocalizations.of(context).translate('add_work_title')),
              // Show the correct actions
              actions: [
                WorkDialogDelete(),
                WorkDialogSave(),
              ],
            ),
            body: WorkDialogBody(),
          ),
        ),
      ),
    );
  }
}

/// The state for the work dialog
class WorkDialogState with ChangeNotifier {
  // States for the current inputs
  DateTime _currentDate = DateTime.now();
  int _currentLocationID;
  TextEditingController _descriptionController = new TextEditingController();
  TextEditingController _timeController = new TextEditingController();
  int _currentWorktypeID;

  // Global states
  bool _showInputError = false;
  TracklessWork _editWork;

  WorkDialogState(TracklessWork editWork) {
    if (editWork != null) {
      // Edit work
      _editWork = editWork;
      // Set the inputs correct
      _currentDate = DateTime.tryParse(editWork.date) ?? DateTime.now();
      _currentLocationID = editWork.location.locationID;
      _descriptionController.text = editWork.description;
      _timeController.text = editWork.time.toString();
      _currentWorktypeID = editWork.worktype.worktypeID;
    }
  }

  /// Should input errors be shown?
  bool get showInputError => _showInputError;

  /// Change the show input error value
  set showInputError(bool newState) {
    if (_showInputError != newState) {
      _showInputError = newState;
      notifyListeners();
    }
  }

  /// Get the current input date
  DateTime get currentDate => _currentDate;

  /// Update the current date
  set currentDate(DateTime newDate) {
    if (!_currentDate.isAtSameMomentAs(newDate)) {
      _currentDate = newDate;
      notifyListeners();
    }
  }

  /// Get the current locationID
  int get currentLocationID => _currentLocationID;

  /// Update the current locationID
  set currentLocationID(int newLocation) {
    if (_currentLocationID != newLocation) {
      _currentLocationID = newLocation;
      notifyListeners();
    }
  }

  /// Get the currect description controller
  TextEditingController get descriptionController => _descriptionController;

  // Get the current description
  String get currentDescription => _descriptionController.text;

  /// Change the current description
  set currentDescription(String value) {
    _descriptionController.text = value;
    notifyListeners();
  }

  /// Get the current time controller
  TextEditingController get timeController => _timeController;

  /// Get the current time
  double get currentTime =>
      double.tryParse(_timeController.text.replaceAll(',', '.')) ?? 0;

  /// Change the current time
  set currentTime(double value) {
    _timeController.text = value.toString();
    notifyListeners();
  }

  /// Get the current WorktypeID
  int get currentWorktypeID => _currentWorktypeID;

  /// Update the current WorktypeID
  set currentWorktypeID(int value) {
    if (_currentWorktypeID != value) {
      _currentWorktypeID = value;
      notifyListeners();
    }
  }

  /// Get the current workID
  ///
  /// If this is null that means that there is no current work.
  int get currentWorkID => _editWork?.workID;

  /// Get the full [TracklessWork] object
  ///
  /// WARNING: this could be null
  TracklessWork get editWork => _editWork;
}

/// A global function to test an input and return the correct value
///
/// if there is nothing wrong with the input it will return null else
/// it will return the correct string to display
Function validator(
    WorkDialogState workDialogState, BuildContext context, String inputName) {
  return (value) {
    return ((value == null || value == "") && workDialogState.showInputError)
        ? AppLocalizations.of(context)
            .translate('add_work_valueNotvalid')
            .replaceAll('%input',
                AppLocalizations.of(context).translate(inputName).toLowerCase())
        : null;
  };
}

/// This function will try to run [function] and if it fails will display a dialog to inform the user
Future dialogTry(BuildContext context, Future Function() function) async {
  try {
    await function();
  } on SocketException {
    TracklessFailure(1).displayFailure(context); // No internet connection
  } on HttpException catch (e) {
    switch (e.message) {
      case '400':
        TracklessFailure(6, detailCode: 14)
            .displayFailure(context); // Bad request
        break;
      case '401':
        TracklessFailure(2).displayFailure(context); // Unauthorized
        break;
      case '403':
        TracklessFailure(2).displayFailure(context); // Forbidden
        break;
      case '404':
        TracklessFailure(3).displayFailure(context); // Not found
        break;
      default:
        TracklessFailure(4).displayFailure(context); // Internal server error
    }
  } on FormatException {
    TracklessFailure(5).displayFailure(context); // Internal error
  } on TypeError {
    TracklessFailure(5, detailCode: 15)
        .displayFailure(context); // Internal error
  } finally {
    // hide the loading animation
    context.hideLoaderOverlay();
  }
}

// This will reload the home page if needed
Future dialogReloadHome(
    BuildContext context, WorkDialogState workDialogState) async {
  // Reload the home page
  final asyncState = Provider.of<AsyncState>(context, listen: false);
  final tracklessWorkProvider =
      Provider.of<TracklessWorkProvider>(context, listen: false);
  // Show the async loading
  asyncState.isAsyncLoading = true;

  // Check if we need to update the u
  if ((workDialogState.currentDate
              .isAtSameMomentAs(tracklessWorkProvider.startDate) ||
          workDialogState.currentDate
              .isAfter(tracklessWorkProvider.startDate)) &&
      (workDialogState.currentDate
              .isAtSameMomentAs(tracklessWorkProvider.endDate) ||
          workDialogState.currentDate
              .isBefore(tracklessWorkProvider.endDate))) {
    // The date is visable update the ui
    await tracklessWorkProvider.refreshFromServer(
        tracklessWorkProvider.startDate, tracklessWorkProvider.endDate);
  }

  // Done loading
  asyncState.isAsyncLoading = false;
}
