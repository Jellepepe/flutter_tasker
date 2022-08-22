# flutter_tasker

Simple flutter plugin that implements the Tasker Command System, TaskerIntent library, and the Tasker Task ContentProvider.


## Usage
*First check if relevant permissions are available!*  
Use `FlutterTasker.checkStatus()` to retrieve the tasker status (`TaskerStatus`) to check whether tasks can be triggered.  
Use `FlutterTasker.checkCommandPermission()` to check if the permission for the Tasker Command System is granted (`bool`).  
  
*Request relevant permissions if required!*  
Use `FlutterTasker.requestCommandPermission()` to trigger a permission dialog for the Command System permission.  
Use `FlutterTasker.openExternalAccessSetting()` to open the external access menu in tasker for the user to enable it.

*Request and trigger tasks*  
Use `FlutterTasker.getTasks()` to get a list of named tasks (`List<String>`).  
Use `FlutterTasker.triggerTask(String task)` to trigger a task.  

*Send a command through the Tasker Command System*  
Use `FlutterTasker.sendCommand(String command)` to send a command.

## How to install
The relevant permissions are already declared in the android manifest of the plugin:
```xml
<uses-permission android:name="net.dinglisch.android.tasker.PERMISSION_SEND_COMMAND"/>
<uses-permission android:name="net.dinglisch.android.tasker.PERMISSION_RUN_TASKS"/>
<queries>
	<package android:name="net.dinglisch.android.taskerm" />
</queries>
```
Additionally it requires the option `Allow external access` to be enabled in the tasker settings.  
Helper functions (`FlutterTasker.checkStatus()` & `FlutterTasker.openExternalAccessSetting()`) are provided to check if this option is enabled and open the relevant menu for the user.

## Example
Check the example app for a simple implementation example.

## License
This project is licensed under a BSD-3 Clause License, see the included LICENSE file for the full text.  
The `TaskerIntent.java` file was provided by the Tasker developer here: https://tasker.joaoapps.com/code/TaskerIntent.java

## Contribute
Issues and pull requests are always welcome!  
If you found this project helpful, consider buying me a cup of :coffee:
- [PayPal](https://www.paypal.me/bymedev)