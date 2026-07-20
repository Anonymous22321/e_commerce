import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/check_out_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class CheckOutView extends StatelessWidget {
  CheckOutView({super.key});

 final List<String> steps = ["delivery".tr, "address".tr, "summary".tr];

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return GetBuilder(
      init: CheckOutViewModel(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: CustomText(title: "checkout".tr),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.navigate_before),
          ),
        ),

        body: Padding(
          padding: .only(top: 30),
          child: controller.loading.value
              ? Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(steps.length, (index) {
                        return Expanded(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // 1. The Line BEFORE the dot (hide for the first item)
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: controller.getLineColor(
                                        index,
                                        true,
                                      ),
                                    ),
                                  ),

                                  // 2. The Dot
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: controller.getDotColor(index),
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(4),
                                    child: index <= controller.currentIndex
                                        ? Container(
                                            decoration: const BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.green,
                                            ),
                                          )
                                        : null,
                                  ),
                                  // 3. The Line AFTER the dot (hide for the last item)
                                  Expanded(
                                    child: Container(
                                      height: 2,
                                      color: controller.getLineColor(
                                        index,
                                        false,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // 4. The Label
                              CustomText(
                                title: steps[index],
                                fontWeight: .w500,
                                fontSize: 18,
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: controller
                              .selectedWidget, // Your pages (Delivery, Address, Summary)
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      height: h * .12,
                      color: Colors.white,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          controller.currentIndex == 0
                              ? Spacer()
                              : Expanded(
                                  child: CustomButton(
                                    title: "back".tr,
                                    textColor: Colors.black,
                                    onPressed: () {
                                      controller.changeIndex(
                                        controller.currentIndex - 1,
                                      );
                                    },
                                    backgroundColor: Colors.white,
                                  ),
                                ),
                          SizedBox(width: w * .3),
                          controller.currentIndex == 2
                              ? Expanded(
                                  child: controller.loading.value
                                      ? CircularProgressIndicator()
                                      : CustomButton(
                                          title: "deliver".tr,
                                          textColor: Colors.white,
                                          onPressed: () async{
                                           await controller.addOrder();
                                          },
                                          backgroundColor: primaryColor,
                                        ),
                                )
                              : Expanded(
                                  child: CustomButton(
                                    title: "next".tr,
                                    textColor: Colors.white,
                                    onPressed: () {
                                      controller.changeIndex(
                                        controller.currentIndex + 1,
                                      );
                                    },
                                    backgroundColor: primaryColor,
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
