import 'package:flutter/material.dart';
import 'package:trackless/pages/home/home.dart';

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
  AppPage _previousPage;

  List<AppPage> _history = [];

  /// Get the active page
  AppPage get activePage => _activePage;

  /// Get the previous active page
  AppPage get previousPage => _previousPage ?? homePage;

  /// Change the active page
  set activePage(AppPage newPage) {
    // Only change the page when it is different
    if (_activePage?.pageTitle != newPage.pageTitle) {
      // Add the current page to the history stack
      _history.add(_activePage ?? homePage);
      _previousPage = _activePage ?? homePage;
      // Show the new page
      _activePage = newPage;
      notifyListeners();
    }
  }

  /// Get the previous page from the list and set it as the activePage
  ///
  /// This function will return true if there is no page left
  bool goPreviousPage(AnimationController fabAnimation) {
    // Check if there is a history
    if (_history.length == 0) {
      // No page left
      // Close the app
      return true;
    } else {
      // Set the correct pages
      _previousPage = _activePage;
      _activePage = _history.last;
      // Update the history
      _history.removeLast();
      // Update the fab
      // Check for changes
      if ((_previousPage.floatingActionButton == null) !=
          (_activePage.floatingActionButton == null)) {
        // Check the new state
        if (_activePage.floatingActionButton == null) {
          fabAnimation.reverse();
        } else {
          fabAnimation.forward();
        }
      }
      // Update the ui
      notifyListeners();
      return false;
    }
  }
}
