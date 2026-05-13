import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  final List<String> _menu = [
    "Edit Profile",
    "Shipping Address",
    "Order History",
    "Cards",
    "Notifications",
    "Log Out",
  ];
  final List<String> _menuIcons = [
    "assets/images/Icon_Edit-Profile.png",
    "assets/images/Icon_Location.png",
    "assets/images/Icon_History.png",
    "assets/images/Icon_Payment.png",
    "assets/images/Icon_Alert.png",
    "assets/images/Icon_Exit.png",
  ];

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return GetBuilder(
      init: ProfileViewModel(),
      builder: (controller) => controller.isLoading.value
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: .all(8),
                  child: Row(
                    mainAxisAlignment: .start,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: controller.userModel.pic == ""
                            ? AssetImage("assets/images/Avatar.png")
                            : NetworkImage("${controller.userModel.pic}"),
                      ),
                      SizedBox(width: w * .05),
                      Column(
                        crossAxisAlignment: .start,
                        children: [
                          CustomText(
                            title: "${controller.userModel.username}",
                            fontSize: 28,
                          ),
                          CustomText(
                            title: "${controller.userModel.email}",
                            fontWeight: .w500,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: h * .07),
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) => Container(
                      padding: .all(8),
                      child: ListTile(
                        onTap: () => controller.action(index),
                        title: CustomText(title: _menu[index],fontSize: 24,fontWeight: .w500,),
                        leading: Image.asset(_menuIcons[index],scale: .85,),
                        trailing: index < 5
                            ? Icon(Icons.arrow_forward_ios)
                            : null,
                      ),
                    ),
                    separatorBuilder: (context, index) => SizedBox(height: 18),
                    itemCount: _menu.length,
                  ),
                ),
              ],
            ),
    );
  }
}
