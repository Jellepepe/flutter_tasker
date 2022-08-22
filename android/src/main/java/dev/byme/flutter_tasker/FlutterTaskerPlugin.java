/**
* Copyright 2022 Pepe Tiebosch (byme.dev/Jellepepe). All rights reserved.
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*/

package dev.byme.flutter_tasker;

import java.util.ArrayList;
import java.util.List;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.database.Cursor;
import android.net.Uri;
import android.os.Build;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.*;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

/** FlutterTaskerPlugin */
public class FlutterTaskerPlugin implements FlutterPlugin, MethodCallHandler, ActivityAware {
  private MethodChannel channel;
  private Context context;
  private Activity activity;

  private static final String PERMISSION_SEND_COMMAND = "net.dinglisch.android.tasker.PERMISSION_SEND_COMMAND";
  private static final String PERMISSION_RUN_TASKS = "net.dinglisch.android.tasker.PERMISSION_RUN_TASKS";
  private static final String EXTRA_COMMAND = "command";

  private boolean canSendTaskerCommand() {
    if(Build.VERSION.SDK_INT < Build.VERSION_CODES.M) return true;
    return context.checkSelfPermission(PERMISSION_SEND_COMMAND) == PackageManager.PERMISSION_GRANTED;
  }

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    context = flutterPluginBinding.getApplicationContext();
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_tasker");
  }

  @Override
  public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
    this.activity = binding.getActivity();
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    if (call.method.equals("triggerCommand")) {
      if(!call.hasArgument("command") || TextUtils.isEmpty(call.argument("command").toString())) {
        result.error("ERROR", "Empty or null command", null);
      } else if (!canSendTaskerCommand()) {
        result.error("ERROR", "No permission to send Tasker Commands", null);
      } else {
        Intent intent = new Intent().setClassName("net.dinglisch.android.taskerm", "com.joaomgcd.taskerm.command.ServiceSendCommand");
        intent.putExtra(EXTRA_COMMAND, call.argument("command").toString());
        try {
          if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) {
            context.startService(intent);
          } else {
            context.startForegroundService(intent);
          }
          result.success(true);
        } catch (Exception e) {
          result.error("ERROR", "Failed to send command", e);
        }
      }
    } else if (call.method.equals("getTasks")) {
      List<String> list = new ArrayList<String>();
      try {
        Cursor c = context.getContentResolver().query( Uri.parse( "content://net.dinglisch.android.tasker/tasks" ), null, null, null, null );
        if ( c != null ) {
          int nameCol = c.getColumnIndex( "name" );
          int projNameCol = c.getColumnIndex( "project_name" );
          while (c.moveToNext()) {
            list.add(c.getString( nameCol ));
          }
          c.close();
        }
        result.success(list);
      } catch (Exception e) {
        result.error("ERROR", "Failed to get tasks", e);
      }
    } else if (call.method.equals("triggerTask")) {
      if(!call.hasArgument("task") || TextUtils.isEmpty(call.argument("task").toString())) {
        result.error("ERROR", "Empty or null task", null);
      } else if (!TaskerIntent.testStatus(context).equals(TaskerIntent.Status.OK)) {
        result.error("ERROR", "Unable to trigger task: " + TaskerIntent.testStatus(context), null);
      } else {
        try {
          TaskerIntent intent = new TaskerIntent(call.argument("task").toString());
          context.sendBroadcast(intent);
          result.success(true);
        } catch (Exception e) {
          result.error("ERROR", "Failed to send command", e);
        }
      }
    } else if (call.method.equals("checkStatus")) {
      result.success(TaskerIntent.testStatus(context).toString());
    } else if (call.method.equals("checkCommandPermission")) {
      result.success(canSendTaskerCommand());
    } else if (call.method.equals("requestCommandPermission")) {
      if (!canSendTaskerCommand()) {
        activity.requestPermissions(new String[]{PERMISSION_SEND_COMMAND}, 1231);
      }
      result.success(true);
    } else if (call.method.equals("openExternalAccessSetting")) {
      activity.startActivity(TaskerIntent.getExternalAccessPrefsIntent());
      result.success(true);
    } else {
      result.notImplemented();
    }
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
    channel.setMethodCallHandler(null);
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}
