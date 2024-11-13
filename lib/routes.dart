import 'package:get/get.dart';
import 'package:produce_api/screen/auth/login_screen.dart';
import 'package:produce_api/screen/products/product_screen.dart';
import 'package:produce_api/screen/widget/splash.dart';

final appRoute = [
  GetPage(name: '/splash', page: () => const SplashScreen()),
  GetPage(name: '/product', page: () => const ProductsScreen()),
  GetPage(name: '/signin', page: () => const SigninScreen()),
];
