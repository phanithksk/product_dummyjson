import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:produce_api/core/app_lang.dart';
import 'package:produce_api/screen/products/product_screen.dart';

void main() async {
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = GetStorage();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      fallbackLocale: AppTranslations().fallbackLocale,
      locale: storage.read('langCode') != null
          ? Locale(storage.read('langCode'), storage.read('countryCode'))
          : const Locale('km', 'KM'),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
      home: const ProductsScreen(),
    );
  }
}
