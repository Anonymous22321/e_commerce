import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/cart_view_model.dart';
import 'package:e_commerce/model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class ProductDetailsView extends StatelessWidget {
 final ProductModel model;

  const ProductDetailsView({required this.model, super.key});

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.sizeOf(context).height;
    final double w = MediaQuery.sizeOf(context).width;
    return Scaffold(
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        height: h * .12,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(title: "price", fontWeight: FontWeight.normal),
                SizedBox(height: 5),
                CustomText(title: "\$${model.price}", color: primaryColor),
              ],
            ),
            SizedBox(width: w*.3,),
            Expanded(
              child: GetBuilder(
                init: CartViewModel(),
                builder: (controller) => CustomButton(
                  title: "ADD TO CART",
                  textColor: Colors.white,
                  onPressed: () {
                    controller.addToCart(productId: model.productId!);
                  },
                  backgroundColor: primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: h * .3,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(model.productImage!),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(Icons.star_border, size: 35),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(title: model.productName!, fontSize: 25),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          width: w * .4,
                          height: h * .06,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(title: "Size", fontWeight: .w500),
                              CustomText(title: model.size!),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(8),
                          width: w * .4,
                          height: h * .06,
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CustomText(title: "Colour", fontWeight: .w500),
                              CircleAvatar(
                                backgroundColor: model.color,
                                radius: 12,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    CustomText(title: "Details", fontSize: 26),
                    SizedBox(height: 10),
                    CustomText(
                      title: model.description!,
                      height: 2,
                      fontSize: 18,
                      fontWeight: .w500,
                      maxLines: 15,
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
