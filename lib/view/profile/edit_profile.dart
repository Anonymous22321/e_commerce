import 'package:e_commerce/constants/app_validators.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(title: "Edit your Profile", fontSize: 24),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.navigate_before),
        ),
      ),
      body: GetBuilder<ProfileViewModel>(
        init: Get.find<ProfileViewModel>(),
        builder: (controller) => SafeArea(
          child: Padding(
            padding: .all(12),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: controller.pickedImage != null
                        ? FileImage(controller.pickedImage!)
                        : (controller.userModel.pic != null && controller.userModel.pic!.isNotEmpty
                        ? NetworkImage(controller.userModel.pic!) as ImageProvider
                        : const AssetImage("assets/images/Avatar.png")),
                    backgroundColor: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  title: "Change Your Image",
                  textColor: Colors.white,
                  icon: Icon(Icons.add, color: Colors.white),
                  width: 300,
                  onPressed: () {
                    controller.pickImage();
                  },
                ),
                SizedBox(height: 30),
                CustomTextFormField(
                  labelText: "Name",
                  hint: controller.userModel.username,
                  onChange: (value) => controller.name = value,
                  validator: (value) =>
                      AppValidators.displayNameValidator(value),
                ),
                SizedBox(height: 30),
                // CustomTextFormField(
                //   labelText: "Password",
                //   hint: "***************",
                //   obscureText: controller.hiddenPassword.value,
                //   suffixIcon: IconButton(
                //     onPressed: () {
                //       controller.togglePasswordVisibility();
                //     },
                //     icon: Icon(
                //       controller.hiddenPassword.value
                //           ? Icons.visibility_off
                //           : Icons.visibility,
                //     ),
                //   ),
                //   onChange: (value) => controller.password = value,
                //   validator: (value) => AppValidators.passwordValidator(value),
                // ),
                // SizedBox(height: 30),
                // CustomTextFormField(
                //   labelText: "Confirm Password",
                //   hint: "***************",
                //   obscureText: controller.hiddenPassword.value,
                //   suffixIcon: IconButton(
                //     onPressed: () {
                //       controller.togglePasswordVisibility();
                //     },
                //     icon: Icon(
                //       controller.hiddenPassword.value
                //           ? Icons.visibility_off
                //           : Icons.visibility,
                //     ),
                //   ),
                //   onChange: (value) => controller.confirmPassword = value,
                //   validator: (value) => AppValidators.repeatPasswordValidator(
                //     value: value,
                //     password: controller.password,
                //   ),
                // ),
                Spacer(),
                controller.isLoading.value
                    ? CircularProgressIndicator()
                    : CustomButton(
                        onPressed: () {
                          controller.editProfile();
                        },
                        title: "Save Changes",
                        textColor: Colors.white,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
