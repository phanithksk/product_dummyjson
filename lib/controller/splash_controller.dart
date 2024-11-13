import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';


class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();

    final storage = GetStorage();
    String? token = storage.read('accessToken');

    Timer(
      const Duration(seconds: 5),
      () {
        if (token != null && token.isNotEmpty) {
          Get.offAllNamed('/product');
        } else {
          Get.offAllNamed('/signin');
        }
      },
    );
  }
}
