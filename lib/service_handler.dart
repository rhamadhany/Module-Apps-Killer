import 'dart:io';

import 'package:app_picker/my_app_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ServiceHandler {
  static const channel =
      MethodChannel("com.BNeoTech.AppsKiller_Module.channelService");
  static HttpServer? server;
  static final isLoading = false.obs;
  static final isError = false.obs;
  static final isErrorServer = false.obs;
  static final textStatus = ''.obs;
  static final textStatusServer = 'Not Running'.obs;

  static void listener() {
    channel.setMethodCallHandler((data) {
      switch (data.method) {
        case "fromService":
          Get.put(MyAppController());
          break;
      }

      return Future.value();
    });
  }
}
