// Copyright 2021 Pepe Tiebosch (Jellepepe). All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'flutter_tasker_platform_interface.dart';

class FlutterTasker {
  static Future<bool> sendCommand(String command) async {
    return await FlutterTaskerPlatform.instance.sendCommand(command) ?? false;
  }

  static Future<List<String>?> getTasks() {
    return FlutterTaskerPlatform.instance.getTasks();
  }

  static Future<bool> triggerTask(String task) async {
    return await FlutterTaskerPlatform.instance.triggerTask(task) ?? false;
  }

  static Future<TaskerStatus> checkStatus() async {
    return TaskerStatus.fromString(await FlutterTaskerPlatform.instance.checkStatus() ?? "");
  }

  static Future<bool> checkCommandPermission() async {
    return await FlutterTaskerPlatform.instance.checkCommandPermission() ?? false;
  }

  static Future<bool> requestCommandPermission() async {
    return await FlutterTaskerPlatform.instance.requestCommandPermission() ?? false;
  }

  static Future<bool> openExternalAccessSetting() async {
    return await FlutterTaskerPlatform.instance.openExternalAccessSetting() ?? false;
  }
}

enum TaskerStatus {
  notInstalled,
  noPermission,
  notEnabled,
  accessBlocked,
  noReceiver,
  ok,
  invalid;

  @override
  String toString() {
    return describeEnum(this);
  }

  static TaskerStatus fromString(String status) {
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
