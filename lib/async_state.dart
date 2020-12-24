import 'package:flutter/cupertino.dart';

class AsyncState with ChangeNotifier {
  bool _isAsyncLoading = false;

  /// This is true when an async process is started but not finished
  bool get isAsyncLoading => _isAsyncLoading;

  /// Change the async state
  set isAsyncLoading(bool newState) {
    if (newState != _isAsyncLoading) {
      _isAsyncLoading = newState;
      notifyListeners();
    }
  }
}
