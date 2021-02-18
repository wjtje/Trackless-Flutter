import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:package_info/package_info.dart';

PackageInfo _packageInfo;

/// This will get the package data and store is for later use
Future<void> getPackageInfo() async {
  _packageInfo = await PackageInfo.fromPlatform();
}

/// This will generate the correct appVersion string for each platform
String appVersion() {
  // Check if this is build for web
  if (kIsWeb) {
    return 'Web build';
  } else if (Platform.isAndroid || Platform.isIOS) {
    // Build the custom appVersion string for android and ios
    return '${_packageInfo?.version ?? 'Unknown version'} (build ${_packageInfo?.buildNumber ?? 'Development build'})';
  } else if (Platform.isFuchsia) {
    // Why not?
    return 'Fuchsia build';
  } else if (Platform.isLinux || Platform.isMacOS || Platform.isWindows) {
    // Native build
    return 'Native build';
  }

  // For the future!
  return 'Unknown build';
}
