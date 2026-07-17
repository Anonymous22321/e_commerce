import 'package:e_commerce/constants/languages/arabic.dart';
import 'package:e_commerce/constants/languages/english.dart';
import 'package:get/get.dart';
class Translation extends Translations {
  @override
  Map<String, Map<String,String>> get keys => {
    'en':en,
    'ar':ar
  };
}