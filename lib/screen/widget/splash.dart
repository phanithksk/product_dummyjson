import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:produce_api/controller/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: context.isPhone
                  ? 40
                  : context.isLandscape
                      ? 300
                      : 150,
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FlutterLogo(
                  size: 120,
                  duration: Duration(seconds: 2),
                  curve: Curves.easeIn,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
