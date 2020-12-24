import 'package:flutter/material.dart';

/// This is a public class for creating new pages
class AppPage {
  final String pageTitle;
  final Widget page;
  final Widget floatingActionButton;
  final List<Widget> appBarActions;

  /// A pageTitle and page is required
  AppPage(
      {@required this.pageTitle,
      @required this.page,
      this.floatingActionButton,
      this.appBarActions});
}

/// The global app state
class AppState extends ChangeNotifier {
  AppPage _activePage;

  /// Get the active page
  AppPage get activePage => _activePage;

  /// Change the active page
  set activePage(AppPage newPage) {
    // Only change the page when it is different
    if (_activePage?.pageTitle != newPage.pageTitle) {
      _activePage = newPage;
      notifyListeners();
    }
  }
}
