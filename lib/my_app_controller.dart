import 'dart:convert';

import 'package:app_picker/service_handler.dart';
import 'package:get/get.dart';

import 'package:installed_apps/installed_apps.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart';

class MyAppController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    startServer();
  }

  Future<void> startServer() async {
    try {
      stopServer();

      ServiceHandler.isErrorServer.value = false;
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

      ServiceHandler.server = await serve(handler, 'localhost', 12333);
      ServiceHandler.textStatusServer.value = 'Running: http://localhost:12333';
    } catch (e) {
      ServiceHandler.isErrorServer.value = true;
      ServiceHandler.textStatusServer.value = 'Error: $e';
    }
  }

  void stopServer() {
    if (ServiceHandler.server != null) {
      ServiceHandler.server?.close();
      ServiceHandler.server = null;
      ServiceHandler.textStatusServer.value = 'Not Running';
    }
  }

  Future<String?> listApps() async {
    ServiceHandler.isLoading.value = true;
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

      ServiceHandler.textStatus.value = 'successfully get $total apps';

      ServiceHandler.isError.value = false;
      ServiceHandler.isLoading.value = false;
      return encode;
    } catch (e) {
      ServiceHandler.isError.value = true;
      ServiceHandler.textStatus.value = 'Error: $e';
    }

    ServiceHandler.isLoading.value = false;
    return null;
  }
}
