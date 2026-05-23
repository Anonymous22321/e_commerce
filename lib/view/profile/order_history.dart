import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/profile_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderHistory extends StatelessWidget {
  OrderHistory({super.key});

  // final List<String> _orderDate = [
  //   "May 2,2026",
  //   "April 30,2026",
  //   "April 1,2026",
  // ];
  // final Map<String, List<String>> _orderMap = {
  //   "May 2,2026": ["assets/images/Electric_Kettle.png"],
  //   "April 30,2026": [
  //     "assets/images/Product_Image.png",
  //     "assets/images/Product_Image.png",
  //   ],
  //   "April 1,2026": [
  //     "assets/images/headphone.png",
  //     "assets/images/headphone.png",
  //     "assets/images/headphone.png",
  //   ],
  // };

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: Get.find<ProfileViewModel>(),
      builder: (controller) {
        List<String> dates = controller.groupedOrdersProducts.keys.toList();
        return controller.isLoading.value
            ? CircularProgressIndicator()
            : Scaffold(
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
                    itemCount: dates.length,
                    itemBuilder: (context, index) {
                      String currentHeaderDate = controller
                          .groupedOrdersProducts
                          .keys
                          .toList()[index];
                      var productsForThisDate =
                          controller.groupedOrdersProducts[dates[index]] ?? [];

                      return Column(
                        crossAxisAlignment: .start,
                        children: [
                          CustomText(
                            title: dates[index],
                            color: Colors.grey,
                            fontSize: 18,
                          ),
                          SizedBox(height: 25),
                          ListView.separated(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 30),
                            itemCount: productsForThisDate.length,
                            itemBuilder: (context, index) {
                              var currentProduct = productsForThisDate[index];

                              // Extracting variables remains perfectly clean
                              String title = currentProduct['name'];
                              String price = "${currentProduct['price']}";
                              String image = currentProduct['image'];
                              String status = currentProduct['status'];

                              return Container(
                                // Remove container margin to let separatorBuilder handle uniform spacing
                                padding: const EdgeInsets.all(16),
                                // Extra inner cushion room for text fields
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                  // High visibility crisp card border outline
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.02),
                                      // Soft professional shadowing blur effect
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                width: Get.width,
                                height: 140,
                                // Uniform bounding box prevents layout overflows
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // Forces title to top, status badge to bottom
                                        children: [
                                          CustomText(
                                            title: title,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          CustomText(
                                            title: "\$ $price",
                                            // Clean, singular currency formatting string
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: primaryColor,
                                          ),
                                          Container(
                                            alignment: Alignment.center,
                                            // Keeps status strings perfectly locked in the middle
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 14,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: status == "Delivered"
                                                  ? primaryColor
                                                  : Colors.orangeAccent,
                                              borderRadius: BorderRadius.circular(
                                                6,
                                              ), // Mimics the design's smooth tag edges
                                            ),
                                            // Let explicit inner padding control height naturally instead of hardcoding 45
                                            child: CustomText(
                                              title: status == "Delivered"
                                                  ? "Delivered"
                                                  : "In Transit",
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      // Match the curved edges of your images
                                      child: Image.network(
                                        image,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit
                                            .contain, // Snugly centers product images without awkward zooming degradation
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
      },
    );
  }
}
