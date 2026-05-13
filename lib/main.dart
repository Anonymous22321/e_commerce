import 'package:e_commerce/helper/binding.dart' as helper;
import 'package:e_commerce/view/control_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: "https://rbloodlokdqgtckzclzp.supabase.co",
    anonKey: "sb_publishable_hwqTp-EwilMQLzYnClmw7Q_CZu0Y3tD",
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: helper.Binding(),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(fontFamily: "SfProDisplay",colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: ControlView(),
    );
  }
}
