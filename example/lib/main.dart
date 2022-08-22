// Copyright 2022 Pepe Tiebosch (byme.dev/Jellepepe). All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_tasker/flutter_tasker.dart';

void main() {
  runApp(
    const MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String command = '';
  bool commandPermission = false;
  TaskerStatus status = TaskerStatus.invalid;
  List<String> tasks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasker Plugin Example'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  FlutterTasker.checkStatus().then((value) {
                    setState(() {
                      status = value;
                    });
                  });
                },
                child: Text('Check status: $status'),
              ),
              TextButton(
                onPressed: () {
                  FlutterTasker.checkCommandPermission().then((value) {
                    setState(() {
                      commandPermission = value;
                    });
                  });
                },
                child: Text("Check Command Permission: ${commandPermission ? 'granted' : 'missing'}"),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  FlutterTasker.openExternalAccessSetting().then((value) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Opened External access menu successfully: $value')));
                  });
                },
                child: const Text('Open External Access menu'),
              ),
              TextButton(
                onPressed: () {
                  FlutterTasker.requestCommandPermission().then((value) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Requested permission successfully: $value')));
                  });
                },
                child: const Text('Request command permission'),
              ),
            ],
          ),
          TextButton(
            onPressed: () {
              FlutterTasker.getTasks().then((value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tasks: $value')));
                setState(() {
                  tasks = value ?? [];
                });
              });
            },
            child: const Text('Get Tasks'),
          ),
          Column(
            children: [
              for (String task in tasks)
                TextButton(
                  onPressed: () {
                    FlutterTasker.triggerTask(task);
                  },
                  child: Text('Run Task: $task'),
                )
            ],
          ),
          const Text('Command:'),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Command',
            ),
            onChanged: (value) {
              command = value;
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.send),
        onPressed: () {
          try {
            FlutterTasker.sendCommand(command).then(
              (value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Command Result: $value'))),
            );
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Command failed: $e')));
          }
        },
      ),
    );
  }
}
