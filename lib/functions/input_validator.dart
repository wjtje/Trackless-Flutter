import 'package:flutter/cupertino.dart';
import 'package:trackless/functions/app_localizations.dart';

/// A global function to test an input and return the correct value
///
/// if there is nothing wrong with the input it will return null else
/// it will return the correct string to display
Function inputValidator(
    bool showError, BuildContext context, String inputName) {
  return (value) {
    return ((value == null || value == "") && showError)
        ? AppLocalizations.of(context).translate('input_error').replaceAll(
            '%input',
            AppLocalizations.of(context).translate(inputName).toLowerCase())
        : null;
  };
}
