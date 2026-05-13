import 'package:e_commerce/constants/app_validators.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/check_out_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddAddress extends StatelessWidget {
  const AddAddress({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckOutViewModel>(
      init: Get.find<CheckOutViewModel>(),
      builder: (controller) => Form(
        key: controller.addressGlobalKey,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  Image.asset("assets/images/Radio_Button.png"),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomText(
                        title:
                            "Billing address is the same as delivery address",
                        fontWeight: .w500,
                        maxLines: 2,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40),
              CustomTextFormField(
                labelText: "Street 1",
                hint: "21, Alex Davidson Avenue",
                onChange: (value) => controller.street1 = value,
                validator: (value) => AppValidators.addressValidator(value),
              ),
              SizedBox(height: 40),
              CustomTextFormField(
                labelText: "Street 2",
                hint: "Opposite Omegatron, Vicent Quarters",
                onChange: (value) => controller.street2 = value,
                validator: (value) => AppValidators.addressValidator(value),
              ),
              SizedBox(height: 40),
              CustomTextFormField(
                labelText: "City",
                hint: "Victoria Island",
                onChange: (value) => controller.city = value,
                validator: (value) => AppValidators.addressValidator(value),
              ),
              SizedBox(height: 40),
              Container(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: .spaceBetween,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "State",
                        hint: "Lagos State",
                        onChange: (value) => controller.state = value,
                        validator: (value) =>
                            AppValidators.addressValidator(value),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: CustomTextFormField(
                        labelText: "Country",
                        hint: "Nigeria",
                        onChange: (value) => controller.country = value,
                        validator: (value) =>
                            AppValidators.addressValidator(value),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
