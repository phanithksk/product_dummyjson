// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:produce_api/data/network/api_servise.dart';
import 'package:produce_api/model/auth/login_model.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:produce_api/screen/products/product_screen.dart';

class AuthController extends GetxController {
  ApiBaseHelper apihelper = ApiBaseHelper();
  var phoneController = TextEditingController().obs;
  var passwordController = TextEditingController().obs;
  RxString phoneErrorMessage = ''.obs;
  RxString passwordErrorMessage = ''.obs;
  final formKey = GlobalKey<FormState>();

  Rx<LoginModel> loginData = LoginModel().obs;
  Future<LoginModel?> fetchLoginData({
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    context.loaderOverlay.show();
    try {
      var response = await apihelper.onNetworkRequesting(
        url: '/api/oauth/token',
        methode: METHODE.post,
        body: {
          "phoneNumber": phone,
          "password": password,
        },
      );

      if (response is Map<dynamic, dynamic>) {
        final responseMap = Map<String, dynamic>.from(response);

        if (responseMap.containsKey('accessToken')) {
          context.loaderOverlay.hide();

          // Store access token and refresh token in local storage
          final storage = GetStorage();
          storage.write('accessToken', responseMap['accessToken']);
          storage.write('refreshToken', responseMap['refreshToken']);

          Get.snackbar("Login Successful", "Welcome to the app!",
              snackPosition: SnackPosition.BOTTOM);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProductsScreen()),
          );
        } else if (responseMap['status'] == 401) {
          context.loaderOverlay.hide();
          phoneErrorMessage.value = responseMap['message'] ?? 'Unauthorized';
          passwordErrorMessage.value = responseMap['message'] ?? 'Unauthorized';
          formKey.currentState?.validate();

          await refreshToken(context: context);
        }
      }
    } catch (e) {
      context.loaderOverlay.hide();
      debugPrint('---Unexpected error: $e');
    } finally {
      context.loaderOverlay.hide();
    }
    return null;
  }

  Future<void> refreshToken({required BuildContext context}) async {
    final storage = GetStorage();
    String? refreshToken = storage.read('refreshToken');

    if (refreshToken == null) {
      debugPrint('No refresh token found.');
      Get.snackbar('Error', 'No refresh token available. Please log in again.');
      Get.offAllNamed('/signin');
      return;
    }

    context.loaderOverlay.show();

    try {
      var response = await apihelper.onNetworkRequesting(
        url: '/api/oauth/refresh',
        methode: METHODE.post,
        body: {
          "refreshToken": refreshToken,
        },
      );

      if (response is Map<dynamic, dynamic>) {
        final responseMap = Map<String, dynamic>.from(response);

        if (responseMap.containsKey('accessToken')) {
          // If refresh is successful, store the new access token
          storage.write('accessToken', responseMap['accessToken']);

          Get.snackbar('Success', 'Token refreshed successfully.',
              snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('Error', 'Unable to refresh token. Please log in again.',
              snackPosition: SnackPosition.BOTTOM);
          Get.offAllNamed('/signin');
        }
      }
    } catch (e) {
      context.loaderOverlay.hide();
      debugPrint('---Error refreshing token: $e');
      Get.snackbar('Error', 'Error refreshing token. Please log in again.',
          snackPosition: SnackPosition.BOTTOM);
      Get.offAllNamed('/signin');
    } finally {
      context.loaderOverlay.hide();
    }
  }
}
