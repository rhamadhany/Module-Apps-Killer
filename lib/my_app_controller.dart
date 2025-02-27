import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:installed_apps/installed_apps.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart';

class MyAppController extends GetxController {
  final isLoading = false.obs;
  final isError = false.obs;
  final isErrorServer = false.obs;
  final textStatus = ''.obs;
  final textStatusServer = ''.obs;

  @override
  void onInit() {
    super.onInit();
    httpServer();
  }

  Future<void> requestBackgound() async {
    PermissionStatus status =
        await Permission.ignoreBatteryOptimizations.status;
    if (!status.isGranted) {
      Get.dialog(
        barrierDismissible: false,
        AlertDialog(
          title: Text(
            'Background Process',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
              'For make sure server is running, this Apps request permission in background. grant permission?'),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                child: Text("No")),
            ElevatedButton(
                onPressed: () async {
                  Get.back();
                  status = await Permission.ignoreBatteryOptimizations.status;
                  if (status.isDenied) {
                    await Permission.ignoreBatteryOptimizations.request();
                  } else if (status.isPermanentlyDenied) {
                    await openAppSettings();
                  }
                },
                child: Text("Yes"))
          ],
        ),
      );
    }
  }

  Future<void> httpServer() async {
    try {
      isErrorServer.value = false;
      Future<shelf.Response> handler(shelf.Request request) async {
        if (request.method == 'GET' && request.url.path == 'apps') {
          final data = await listApps();
          if (data != null) {
            return shelf.Response.ok(data,
                headers: {'Content-Type': 'application/json'});
          } else {
            return shelf.Response.notFound(jsonEncode('Nothing'));
          }
        } else {
          return shelf.Response.notFound(jsonEncode('Nothing'));
        }
      }

      await serve(handler, 'localhost', 12333);
      textStatusServer.value = 'Running in http://localhost:12333';
    } catch (e) {
      isErrorServer.value = true;
      textStatusServer.value = 'Error: $e';
    }
  }

  Future<String?> listApps() async {
    isLoading.value = true;
    try {
      final listApp = await InstalledApps.getInstalledApps(false, true);
      int total = 0;

      List<Map<String, dynamic>> userApps = [];
      List<Map<String, dynamic>> systemApps = [];

      for (var app in listApp) {
        if (app.packageName == 'com.BNeoTech.AppsKiller' ||
            app.packageName == 'com.BNeoTech.AppsKiller_Module') {
          continue;
        }
        total++;
        final isSystem = await InstalledApps.isSystemApp(app.packageName);

        if (isSystem!) {
          systemApps.add(app.toJson());
        } else {
          userApps.add(app.toJson());
        }
      }
      final map = {
        'userApps': userApps,
        'systemApps': systemApps,
      };
      final encode = jsonEncode(map);

      textStatus.value = '$total Apps Killer';

      isError.value = false;
      isLoading.value = false;
      return encode;
    } catch (e) {
      isError.value = true;
      textStatus.value = 'Error: $e';
    }

    isLoading.value = false;
    return null;
  }
}
