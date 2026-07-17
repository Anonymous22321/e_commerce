import 'dart:ui';

import 'package:e_commerce/core/service/local_storage.dart';
import 'package:get/get.dart';

class AppLanguage extends GetxController {
  String appLocale = 'en';

  @override
  void onInit() async {
    LocalStorage localStorage = LocalStorage();
    appLocale = await localStorage.languageSelected;
    Get.updateLocale(Locale(appLocale));
    update();
    super.onInit();
  }


  void changeLanguage(String language ){
    LocalStorage localStorage = LocalStorage();
    if(language==appLocale) return;

    if(language =='ar'){
      appLocale = 'ar';
      localStorage.saveLanguage('ar');
    }
    else{
      appLocale ='en';
      localStorage.saveLanguage('en');
    }
    /// Update the locale
    Get.updateLocale(Locale(appLocale));
    update();
  }
}
