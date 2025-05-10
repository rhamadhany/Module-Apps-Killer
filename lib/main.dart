import 'package:app_picker/my_app_controller.dart';
import 'package:app_picker/my_app.dart';
import 'package:app_picker/service_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(MyAppController());
  ServiceHandler.listener();
  runApp(GetMaterialApp(
    home: MyApp(),
    theme: ThemeData(),
    darkTheme: ThemeData.dark(),
  ));
}
