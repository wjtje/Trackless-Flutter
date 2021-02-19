import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

/// An AppFailure will contain all information about a failure and display
/// it to an user
class AppFailure {
  /// A failure level will define where the error accured
  ///
  /// 1 - User error (Wrong input value)
  /// 2 - Local internal error (Something gone wrong on the inside)
  /// 3 - Communication error (Can't tell what you said)
  /// 4 - External server error (👽)
  final int failureLevel;

  /// This provides context to the user what's gone wrong
  final String detail;

  AppFailure(this.failureLevel, {this.detail = 'unknown'});

  /// Generate an [AppFailure] from an [Response]
  factory AppFailure.httpExecption(http.Response response) {
    print(response.body);

    // Get the detail code
    String detail = json.decode(response.body)['code'];

    // Choose the correct error
    switch (response.statusCode) {
      case 400:
        return AppFailure(1, detail: detail);
        break;
      case 401:
        return AppFailure(1, detail: detail);
        break;
      case 403:
        return AppFailure(1, detail: detail);
        break;
      case 404:
        return AppFailure(2, detail: detail);
        break;
      case 500:
        return AppFailure(4, detail: detail);
        break;
      default:
        return AppFailure(2);
    }
  }

  @override
  String toString() {
    return '(${this.failureLevel} - ${this.detail})';
  }

  /// This will create a snackbar to inform the user
  displayFailure() {
    // Get the correct message and color
    Color backgroundColor = (this.failureLevel == 1 || this.failureLevel == 3)
        ? Colors.orange
        : Colors.red;

    String message = this.toString();

    // Display the snackbar
    ScaffoldMessenger.of(Get.context).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }
}
