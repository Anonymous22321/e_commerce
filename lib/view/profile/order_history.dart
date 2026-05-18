import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistory extends StatelessWidget {
  OrderHistory({super.key});

  final List<String> _orderDate = [
    "May 2,2026",
    "April 30,2026",
    "April 1,2026",
  ];
  final Map<String, List<String>> _orderMap = {
    "May 2,2026": ["assets/images/Electric_Kettle.png"],
    "April 30,2026": [
      "assets/images/Product_Image.png",
      "assets/images/Product_Image.png",
    ],
    "April 1,2026": [
      "assets/images/headphone.png",
      "assets/images/headphone.png",
      "assets/images/headphone.png",
    ],
  };
  bool delivered = true;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: Get.find<ProfileViewModel>(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          title: CustomText(title: "Track Order"),
          centerTitle: true,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(Icons.navigate_before),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 20),
            itemCount: _orderDate.length,
            itemBuilder: (context, index) {
              String date = _orderDate[index];
              List<String> images = _orderMap[date] ?? [];
              return Column(
                crossAxisAlignment: .start,
                children: [
                  CustomText(
                    title: _orderDate[index],
                    color: Colors.grey,
                    fontSize: 18,
                  ),
                  SizedBox(height: 25),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SizedBox(height: 30),
                    itemCount: images.length,
                    itemBuilder: (context, index) => Container(
                      decoration: BoxDecoration(
                        shape: .rectangle,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.white),
                      ),
                      width: Get.width,
                      height: Get.height * .16,
                      child: Row(
                        crossAxisAlignment: .start,
                        mainAxisAlignment: .spaceAround,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: .start,
                              children: [
                                CustomText(title: "Electric Kettle"),
                                SizedBox(height: 10),
                                CustomText(
                                  title: "\$ 50",
                                  fontSize: 20,
                                  fontWeight: .normal,
                                  color: primaryColor,
                                ),
                                Spacer(),
                                Container(
                                  padding: .only(left: 10, top: 7),
                                  color: delivered
                                      ? primaryColor
                                      : Colors.orangeAccent,
                                  width: 120,
                                  height: 45,
                                  child: CustomText(
                                    title: delivered
                                        ? "Delivered"
                                        : "In Transit",
                                    color: Colors.white,
                                    fontWeight: .w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Image.asset(
                            images[index],
                            width: 120,
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
