import 'package:app_picker/my_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyApp extends GetView<MyAppController> {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    controller.requestBackgound();

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          title: Text(
            'Module Apps Killer',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
              child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: controller.isErrorServer.value
                            ? Colors.red
                            : Colors.green),
                    child: Icon(
                      controller.isErrorServer.value
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
                    controller.textStatusServer.value,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if (!controller.isErrorServer.value)
                    Row(
                      children: [
                        Text(
                          'Status: ',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        if (controller.isLoading.value)
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: LinearProgressIndicator(
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        if (!controller.isLoading.value &&
                            !controller.isError.value)
                          Expanded(
                            child: Text(
                              controller.textStatus.value,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          )),
        ),
      );
    });
  }
}
