import 'package:e_commerce/constants/app_validators.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/auth_view_model.dart';
import 'package:e_commerce/view/Auth/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUp extends GetWidget<AuthViewModel> {
  SignUp({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(CupertinoIcons.back, size: 35),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: .035 * h),
                  CustomText(title: "Sign Up", fontSize: 30),
                  SizedBox(height: .05 * h),
                  CustomTextFormField(
                    labelText: "Name",
                    hint: "Please Enter your name",
                    onChange: (value) {
                      controller.name = value;
                    },
                    validator: (value) {
                      return AppValidators.displayNameValidator(value);
                    },
                  ),
                  SizedBox(height: .05 * h),
                  CustomTextFormField(
                    labelText: "Email",
                    hint: "example@mail.com",
                    onChange: (value) {
                      controller.email = value;
                    },
                    validator: (value) {
                      return AppValidators.emailValidator(value);
                    },
                  ),
                  SizedBox(height: .05 * h),
                  Obx(
                    () => CustomTextFormField(
                      labelText: "Password",
                      hint: "**************",
                      obscureText: controller.isPasswordHidden.value,
                      suffixIcon: IconButton(
                        onPressed: () {
                          controller.togglePasswordVisibility();
                        },
                        icon: controller.isPasswordHidden.value == true
                            ? Icon(Icons.visibility_off)
                            : Icon(Icons.visibility),
                      ),
                      onChange: (value) {
                        controller.password = value;
                      },
                      validator: (value) {
                        return AppValidators.passwordValidator(value);
                      },
                    ),
                  ),
                  SizedBox(height: .05 * h),
                  Obx(
                    () => controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : CustomButton(
                            title: "Register",
                            onPressed: () {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                controller.registerUser();
                              }
                            },
                            textColor: Colors.white,
                          ),
                  ),
                  SizedBox(height: .05 * h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        title: "Already have an account?",
                        fontFamily: "PlayfairDisplay",
                        fontStyle: FontStyle.italic,
                      ),
                      TextButton(
                        onPressed: () {
                          Get.offAll(Login());
                        },
                        child: CustomText(
                          title: "Login",
                          color: Colors.blue,
                          fontFamily: "PlayfairDisplay",
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
