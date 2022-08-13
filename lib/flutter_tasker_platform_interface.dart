// Copyright 2021 Pepe Tiebosch (Jellepepe). All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_tasker_method_channel.dart';

abstract class FlutterTaskerPlatform extends PlatformInterface {
  FlutterTaskerPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterTaskerPlatform _instance = MethodChannelFlutterTasker();

  static FlutterTaskerPlatform get instance => _instance;

  static set instance(FlutterTaskerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<bool?> sendCommand(String command) {
    throw UnimplementedError('sendCommand() has not been implemented.');
  }

  Future<List<String>?> getTasks() {
    throw UnimplementedError('getTasks() has not been implemented.');
  }

  Future<bool?> triggerTask(String task) {
    throw UnimplementedError('triggerTask() has not been implemented.');
  }

  Future<String?> checkStatus() {
    throw UnimplementedError('checkStatus() has not been implemented.');
  }

  Future<bool?> checkCommandPermission() {
    throw UnimplementedError('checkCommandPermission() has not been implemented.');
  }

  Future<bool?> requestCommandPermission() {
    throw UnimplementedError('requestCommandPermission() has not been implemented.');
  }

  Future<bool?> openExternalAccessSetting() {
    throw UnimplementedError('openExternalAccessSetting() has not been implemented.');
  }
}
