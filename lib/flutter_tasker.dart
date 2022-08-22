// Copyright 2022 Pepe Tiebosch (byme.dev/Jellepepe). All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';

import 'flutter_tasker_platform_interface.dart';

/// Implementation of the Tasker Command System and TaskerIntent library
class FlutterTasker {
  /// Send a Tasker Command System command
  ///
  /// See https://tasker.joaoapps.com/commandsystem.html for more information
  static Future<bool> sendCommand(String command) async {
    try {
      return await FlutterTaskerPlatform.instance.sendCommand(command) ?? false;
    } on PlatformException catch (e) {
      if (e.code == 'ERROR') {
        return false;
      } else {
        rethrow;
      }
    }
  }

  /// Get a List of all available tasks
  static Future<List<String>?> getTasks() {
    return FlutterTaskerPlatform.instance.getTasks();
  }

  /// Trigger a [task]
  static Future<bool> triggerTask(String task) async {
    try {
      return await FlutterTaskerPlatform.instance.triggerTask(task) ?? false;
    } on PlatformException catch (e) {
      if (e.code == 'ERROR') {
        return false;
      } else {
        rethrow;
      }
    }
  }

  /// Check tasker status, see [TaskerStatus]
  static Future<TaskerStatus> checkStatus() async {
    return TaskerStatus._fromString(await FlutterTaskerPlatform.instance.checkStatus() ?? '');
  }

  /// Check if command permission is granted
  static Future<bool> checkCommandPermission() async {
    return await FlutterTaskerPlatform.instance.checkCommandPermission() ?? false;
  }

  /// Open permission request dialog for Tasker Command permission if not yet granted
  ///
  /// Returns [false] if tasker is not installed
  static Future<bool> requestCommandPermission() async {
    if (await checkStatus() == TaskerStatus.notInstalled) {
      return false;
    }
    return await FlutterTaskerPlatform.instance.requestCommandPermission() ?? false;
  }

  /// Open SettingsPage in Tasker to enable External Access
  ///
  /// Returns [false] if tasker is not installed
  static Future<bool> openExternalAccessSetting() async {
    if (await checkStatus() == TaskerStatus.notInstalled) {
      return false;
    }
    return await FlutterTaskerPlatform.instance.openExternalAccessSetting() ?? false;
  }
}

/// Status of Tasker Service
enum TaskerStatus {
  notInstalled,
  noPermission,
  notEnabled,
  accessBlocked,
  noReceiver,
  ok,
  invalid;

  @override
  String toString() => name;

  static TaskerStatus _fromString(String status) {
    switch (status) {
      case 'NotInstalled':
        return TaskerStatus.notInstalled;
      case 'NoPermission':
        return TaskerStatus.noPermission;
      case 'NotEnabled':
        return TaskerStatus.notEnabled;
      case 'AccessBlocked':
        return TaskerStatus.accessBlocked;
      case 'NoReceiver':
        return TaskerStatus.noReceiver;
      case 'OK':
        return TaskerStatus.ok;
      default:
        return TaskerStatus.invalid;
    }
  }
}
