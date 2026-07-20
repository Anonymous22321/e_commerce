import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/constants/row_constants.dart';
import 'package:e_commerce/core/view_model/check_out_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeliveryTime extends StatelessWidget {
  const DeliveryTime({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CheckOutViewModel>(
      init: Get.find<CheckOutViewModel>(),
      builder:(controller)=> Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 70,),
          RadioListTile<Delivery>(
            activeColor: primaryColor,
            value: Delivery.standardDelivery,
            groupValue: controller.delivery,
            onChanged: ( value) {
              controller.setDelivery(value);
            },
            title: CustomText(title: "standard".tr),
            subtitle: CustomText(
              title: "standardDetails".tr,
              fontSize: 18,
              fontWeight: .w500,
              maxLines: 3,
            ),
          ),
          SizedBox(height: 50),
          RadioListTile<Delivery>(
            activeColor: primaryColor,
            value: Delivery.nextDayDelivery,
            groupValue: controller.delivery,
            onChanged: ( value) {
              controller.setDelivery(value);

            },
            title: CustomText(title: "nextDay".tr),
            subtitle: CustomText(
              title:
                  "nextDayDetails".tr,
              fontSize: 18,
              fontWeight: .w500,
              maxLines: 3,
            ),
          ),
          SizedBox(height: 50),
          RadioListTile<Delivery>(
            activeColor: primaryColor,
            value: Delivery.nominatedDelivery,
            groupValue: controller.delivery,
            onChanged: (value) {
              controller.setDelivery(value);

            },
            title: CustomText(title: "nominated".tr),
            subtitle: CustomText(
              title:
                  "nominatedDetails".tr,
              fontSize: 18,
              fontWeight: .w500,
              maxLines: 3,
            ),
          ),
        ],
      ),
    );
  }
}
