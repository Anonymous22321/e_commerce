import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/control_view_model.dart';
import 'package:e_commerce/view/Auth/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/view_model/auth_view_model.dart';

class ControlView extends GetWidget<AuthViewModel> {
  const ControlView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => (Get.find<AuthViewModel>().user == null
          ? Login()
          : GetBuilder(
              init: ControlViewModel(),
              builder: (controller) => Scaffold(
                body: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: controller.currentScreen,
                  ),
                ),
                bottomNavigationBar: BottomNavigationBar(
                  elevation: 0,
                  items: [
                    BottomNavigationBarItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: CustomText(title: "Explore", fontSize: 18),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Image.asset(
                          "assets/images/Icon_Explore.png",
                          width: 20,
                          fit: BoxFit.fill,
                        ),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: CustomText(title: "Cart", fontSize: 18),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Image.asset(
                          "assets/images/Icon_Cart.png",
                          width: 25,
                          fit: BoxFit.fill,
                        ),
                      ),
                      label: '',
                    ),
                    BottomNavigationBarItem(
                      activeIcon: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: CustomText(title: "Account", fontSize: 18),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Image.asset(
                          "assets/images/Icon_User.png",
                          width: 23,
                          fit: BoxFit.fill,
                        ),
                      ),
                      label: '',
                    ),
                  ],
                  currentIndex: controller.navigationValue,
                  onTap: (index) {
                    controller.changeSelectedValue(index);
                  },
                ),
              ),
            )),
    );
  }
}
