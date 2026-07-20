import 'package:e_commerce/constants/app_validators.dart';
import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/auth_view_model.dart';
import 'package:e_commerce/view/Auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Login extends GetWidget<AuthViewModel> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: .1 * h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(title: "welcome".tr, fontSize: 30),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUp()),
                          );
                        },
                        child: CustomText(
                          title: "signUp".tr,
                          color: primaryColor,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  CustomText(
                    title: "signIn".tr,
                    color: Colors.grey,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: .05 * h),

                  CustomTextFormField(
                    labelText: "email".tr,
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
                      labelText: "password".tr,
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

                  Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: TextButton(
                      onPressed: () {},
                      child: CustomText(title: "forgotPassword".tr),
                    ),
                  ),
                  SizedBox(height: .05 * h),
                  Obx(
                    () => controller.isLoading.value
                        ? Center(child: CircularProgressIndicator())
                        : CustomButton(
                            title: "login".tr,
                            onPressed: () {
                              _formKey.currentState!.save();
                              if (_formKey.currentState!.validate()) {
                                controller.emailAndPasswordSignInMethod();
                              }
                            },
                            textColor: Colors.white,
                          ),
                  ),
                  SizedBox(height: .05 * h),
                  Align(
                    alignment: AlignmentGeometry.center,
                    child: CustomText(title: "-OR-"),
                  ),
                  SizedBox(height: .05 * h),
                  CustomButton(
                    icon: Image.asset(
                      "assets/images/google_icon.png",
                      width: 30,
                      height: 30,
                    ),
                    backgroundColor: Colors.white,
                    title: "google".tr,
                    textColor: Colors.black,
                    onPressed: () {
                      controller.googleSignInMethod();
                    },
                  ),

                  // SizedBox(height: .03 * h),
                  // CustomButton(
                  //   icon: Icon(Ionicons.logo_facebook,size: 30, ),
                  //   backgroundColor: Colors.white,
                  //   title: "Sign in using Facebook",
                  //   textColor: Colors.black,
                  //   onPressed: () {
                  //     controller.facebookSignInMethod();
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
