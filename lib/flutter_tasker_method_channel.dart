/// Copyright 2021 Pepe Tiebosch (Jellepepe). All rights reserved.
/// Use of this source code is governed by a BSD-style license that can be
/// found in the LICENSE file.
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_tasker_platform_interface.dart';

/// An implementation of [FlutterTaskerPlatform] that uses method channels.
class MethodChannelFlutterTasker extends FlutterTaskerPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_tasker');

  @override
  Future<bool?> sendCommand(String command) async {
    return await methodChannel.invokeMethod<bool>('triggerCommand', <String, String>{'command': command});
  }

  @override
  Future<List<String>?> getTasks() async {
    return await methodChannel.invokeListMethod<String>('getTasks');
  }

  @override
  Future<bool?> triggerTask(String task) async {
    return await methodChannel.invokeMethod<bool>('triggerTask', <String, String>{'task': task});
  }

  @override
  Future<String?> checkStatus() async {
    return await methodChannel.invokeMethod<String>('checkStatus');
  }

  @override
  Future<bool?> checkCommandPermission() async {
    return await methodChannel.invokeMethod<bool>('checkCommandPermission');
  }

  @override
  Future<bool?> requestCommandPermission() async {
    return await methodChannel.invokeMethod<bool>('requestCommandPermission');
  }

  @override
  Future<bool?> openExternalAccessSetting() async {
    return await methodChannel.invokeMethod<bool>('openExternalAccessSetting');
  }
}
