import 'package:e_commerce/view/cart_view.dart';
import 'package:e_commerce/view/home_view.dart';
import 'package:e_commerce/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ControlViewModel extends GetxController {
  int _navigationValue = 0;
  int get navigationValue => _navigationValue;
  Widget _currentScreen = HomeView();
  Widget get currentScreen => _currentScreen;
  void changeSelectedValue(int selectedValue) {
    _navigationValue = selectedValue;
    switch (selectedValue) {
      case 0:
        _currentScreen = HomeView();
        break;
      case 1:
        _currentScreen = CartView();
        break;
      case 2:
        _currentScreen = ProfileView();
        break;
    }
    update();
  }
}
