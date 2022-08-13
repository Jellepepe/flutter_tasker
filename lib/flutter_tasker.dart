// Copyright 2021 Pepe Tiebosch (Jellepepe). All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart';

import 'flutter_tasker_platform_interface.dart';

class FlutterTasker {
  Future<bool?> sendCommand(String command) {
    return FlutterTaskerPlatform.instance.sendCommand(command);
  }

  Future<List<String>?> getTasks() {
    return FlutterTaskerPlatform.instance.getTasks();
  }

  Future<bool?> triggerTask(String task) {
    return FlutterTaskerPlatform.instance.triggerTask(task);
  }

  Future<TaskerStatus> checkStatus() async {
    return TaskerStatus.fromString(await FlutterTaskerPlatform.instance.checkStatus() ?? "");
  }

  Future<bool> checkCommandPermission() async {
    return await FlutterTaskerPlatform.instance.checkCommandPermission() ?? false;
  }

  Future<bool?> requestCommandPermission() {
    return FlutterTaskerPlatform.instance.requestCommandPermission();
  }

  Future<bool?> openExternalAccessSetting() {
    return FlutterTaskerPlatform.instance.openExternalAccessSetting();
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
