import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:loader_overlay/loader_overlay.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Logout function that removes the token and navigates to the login screen
  void logout(BuildContext context) async {
    context.loaderOverlay.show();

    final storage = GetStorage();
    storage.remove('accessToken');
    storage.remove('refreshToken');

    await Future.delayed(const Duration(seconds: 2));
    context.loaderOverlay.hide();

    Get.offAllNamed('/signin');
  }

  void showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Do you really want to log out?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                logout(context);
                Get.back();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xff5D44AD),
          title: Text(
            'Profile',
            style: TextStyle(
              fontSize: 18,
              fontFamily: Get.locale == const Locale('km', 'KM')
                  ? 'KH-BOLD'
                  : 'ROBOTO-BOLD',
              color: Colors.white,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            // Logout button in the AppBar
            IconButton(
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                // Show confirmation dialog on logout button tap
                showLogoutConfirmationDialog(context);
              },
            ),
          ],
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Profile content goes here (e.g., user name, profile picture, etc.)
              Text('User Profile Info', style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
