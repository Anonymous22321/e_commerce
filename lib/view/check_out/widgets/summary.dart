import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/cart_view_model.dart';
import 'package:e_commerce/core/view_model/check_out_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Summary extends StatelessWidget {
  const Summary({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: .start,
        mainAxisAlignment: .start,
        children: [
          SizedBox(height: 20),
          GetBuilder<CartViewModel>(
            init: Get.find<CartViewModel>(),
            builder: (controller) => SizedBox(
              width: Get.width,
              height: 200,
              child: ListView.separated(
                scrollDirection: .horizontal,
                separatorBuilder: (context, index) => SizedBox(width: 30),
                itemCount: controller.cartList.length,
                itemBuilder: (context, index) {
                  var cartItem = controller.cartList[index];
                  var product = controller.productDetails[cartItem.productId];
                  if (product == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return Column(
                    crossAxisAlignment: .start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          product.productImage!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 120,
                                height: 120,
                                color: Colors.grey[200],
                                child: Icon(Icons.broken_image),
                              ),
                        ),
                      ),
                      CustomText(
                        title: product.productName!,
                        fontWeight: .w500,
                      ),
                      CustomText(
                        title: "\$${product.price}",
                        fontWeight: .w500,
                        color: primaryColor,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 50),
          CustomText(title: "shippingAddress".tr, fontSize: 24),
          SizedBox(height: 20),
          GetBuilder<CheckOutViewModel>(
            init: Get.find<CheckOutViewModel>(),
            builder: (controller) => Column(
              crossAxisAlignment: .start,
              children: [
                CustomText(
                  title: controller.fullAddress,
                  maxLines: 5,
                  fontWeight: .w500,
                ),
                SizedBox(height: 15),
                GestureDetector(
                  onTap: () {
                    controller.changeIndex(1);
                  },
                  child: CustomText(
                    title: "change".tr,
                    color: primaryColor,
                    fontWeight: .w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
