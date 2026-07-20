import 'package:e_commerce/core/api/api_endpoints.dart';
import 'package:e_commerce/core/service/translations.dart';
import 'package:e_commerce/helper/binding.dart' as helper;
import 'package:e_commerce/view/control_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/view_model/app_language.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // Load the .env file
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: "https://rbloodlokdqgtckzclzp.supabase.co",
    anonKey: "sb_publishable_hwqTp-EwilMQLzYnClmw7Q_CZu0Y3tD",
  );
  Stripe.publishableKey = ApiKeys.publishableKey;
  await GetStorage.init();
  // 2. Fetch the language directly from local storage right here!
  final box = GetStorage();
  String initialLocale = box.read('lang') ?? 'en'; // Defaults to 'en' if empty

  // 3. Inject AppLanguage controller early and pass the fetched locale
  final appLanguage = Get.put(AppLanguage());
  appLanguage.appLocale = initialLocale;

  // 4. Pass the initial language down to MyApp
  runApp(MyApp(initialLocale: initialLocale));
}

class MyApp extends StatelessWidget {
  final String initialLocale;
  const MyApp({required this.initialLocale, super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: helper.Binding(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: "SfProDisplay",
        colorScheme: .fromSeed(seedColor: Colors.deepPurple),
      ),
      translations: Translation(),
      locale: Locale(initialLocale),
      fallbackLocale: Locale('en'),
      home: ControlView(),
    );
  }
}
