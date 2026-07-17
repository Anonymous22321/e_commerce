import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/cart_view_model.dart';
import 'package:e_commerce/view/check_out/check_out_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.sizeOf(context).height;
    return GetBuilder(
      init: CartViewModel(),
      builder: (controller) {
        if (controller.cartList.isEmpty && controller.loading.value == false) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  "assets/images/Cart_Empty.svg",
                  width: 200,
                  height: 200,
                ),
                 SizedBox(height: 20,),
                 CustomText(title: "Cart is Empty!",fontSize: 32,)
              ],
            ),
          );
        }
        return controller.loading.value
            ? Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemBuilder: (context, index) {
                        var cartItem = controller.cartList[index];
                        var product =
                            controller.productDetails[cartItem.productId];

                        if (product == null) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return Slidable(
                          key: ValueKey(cartItem.cartId),
                          startActionPane: ActionPane(
                            motion: DrawerMotion(),
                            extentRatio: .25,
                            children: [
                              CustomSlidableAction(
                                onPressed: (context) {},
                                backgroundColor: Colors.yellow,
                                foregroundColor: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                autoClose: true,
                                child: Icon(Icons.star, size: 32),
                              ),
                            ],
                          ),
                          endActionPane: ActionPane(
                            motion: DrawerMotion(),
                            extentRatio: .25,
                            dismissible: DismissiblePane(
                              closeOnCancel: true,
                              onDismissed: () async =>
                                  await controller.removeFromCart(index: index),
                            ),
                            children: [
                              CustomSlidableAction(
                                onPressed: (context) =>
                                    controller.removeFromCart(index: index),
                                backgroundColor: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                                foregroundColor: Colors.white,
                                child: Icon(
                                  CupertinoIcons.delete_solid,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Fixed Image Size
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.network(
                                    product.productImage!,
                                    width: 120,
                                    height: 120,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              width: 120,
                                              height: 120,
                                              color: Colors.grey[200],
                                              child: Icon(Icons.broken_image),
                                            ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                // 2. Wrap the text side in Expanded so it takes the rest of the Row space
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        title: product.productName!,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(height: 8),
                                      CustomText(
                                        title: "\$ ${product.price}",
                                        color: primaryColor,
                                        fontSize: 16,
                                      ),
                                      const SizedBox(height: 15),

                                      // 3. The Quantity Selector
                                      Container(
                                        width: 110,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () {
                                                controller.decrement(
                                                  index: index,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.remove,
                                                size: 18,
                                              ),
                                            ),
                                            CustomText(
                                              title: "${cartItem.amount}",
                                              fontSize: 16,
                                            ),
                                            IconButton(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              onPressed: () {
                                                controller.increment(
                                                  index: index,
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.add,
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      itemCount: controller.cartList.length,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    height: h * .1,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              title: "total".tr,
                              fontWeight: FontWeight.normal,
                            ),
                            SizedBox(height: 5),
                            CustomText(
                              title: "\$${controller.totalPrice}",
                              color: primaryColor,
                            ),
                          ],
                        ),
                        const Spacer(),
                        Expanded(
                          child: CustomButton(
                            title: "checkout".tr,
                            textColor: Colors.white,

                            onPressed: () {
                              Get.to(CheckOutView());
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
      },
    );
  }
}
