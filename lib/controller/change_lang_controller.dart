import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ChangeLanguageController extends GetxController {
  static ChangeLanguageController instance = Get.find();
  final storage = GetStorage();

  var km = const Locale('km', 'KM');
  var us = const Locale('en', 'US');

  final langs = ['Khmer', 'English'];
  final locales = [const Locale('km', 'KM'), const Locale('en', 'US')];

  @override
  void onInit() {
    super.onInit();
    String? savedLang = storage.read('lang');
    if (savedLang != null) {
      final locale = _getSaved(savedLang);
      Get.updateLocale(locale);
    }
  }

  Locale _getSaved(String lang) {
    for (int i = 0; i < langs.length; i++) {
      if (lang == langs[i]) return locales[i];
    }
    return Get.locale!;
  }

  updateLanguage(String lang) {
    final locale = _getSaved(lang);
    Get.updateLocale(locale);
    storage.write('lang', lang);
    update();
    Get.back();
  }
}
