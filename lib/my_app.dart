import 'package:app_picker/my_app_controller.dart';
import 'package:app_picker/service_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends GetView<MyAppController> {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.green,
          // foregroundColor: Colors.white,
          title: Text(
            'Module Apps Killer',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withAlpha(75),
                    blurRadius: 10,
                    spreadRadius: 2.5)
              ],
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ServiceHandler.isErrorServer.value
                            ? Colors.red
                            : Colors.green),
                    child: Icon(
                      ServiceHandler.isErrorServer.value
                          ? Icons.error
                          : Icons.check,
                      size: Get.width * 0.35,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    ServiceHandler.textStatusServer.value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!ServiceHandler.isErrorServer.value)
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                        if (ServiceHandler.isLoading.value)
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: LinearProgressIndicator(
                                color: Colors.purple,
                              ),
                            ),
                          ),
                        if (!ServiceHandler.isLoading.value &&
                            !ServiceHandler.isError.value)
                          Expanded(
                            child: Text(
                              ServiceHandler.textStatus.value,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          )),
        ),
        // floatingActionButton: ForegroundSwitch(),
      );
    });
  }
}
