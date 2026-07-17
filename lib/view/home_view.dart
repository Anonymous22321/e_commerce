import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/core/view_model/home_view_model.dart';
import 'package:e_commerce/view/product_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final double h = MediaQuery.sizeOf(context).height;
    final double w = MediaQuery.sizeOf(context).width;

    return GetBuilder(
      init: HomeViewModel(),
      builder: (controller) => controller.loading.value
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Text Field
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.grey.shade200,
                    ),
                    child: TextField(
                      autocorrect: true,
                      decoration: InputDecoration(
                        hint: CustomText(
                          title: "Search",
                          color: Colors.grey,
                          fontFamily: "PlayFairDisplay",
                          fontStyle: FontStyle.italic,
                        ),
                        prefixIcon: Icon(Icons.search),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25),
                          borderSide: const BorderSide(
                            color: Colors.blue,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: h * .04),
                  CustomText(
                    title: "categories".tr,
                    fontFamily: "PlayfairDisplay",
                    fontStyle: FontStyle.italic,
                  ),
                  SizedBox(height: h * .02),
                  //Categories List View
                  Container(
                    decoration: BoxDecoration(color: Colors.grey.shade50),
                    height: h * .15,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categoryModel.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 30,
                              child: Image.network(
                                controller.categoryModel[index].image!,
                                errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                              ),
                            ),
                            SizedBox(height: h * .01),
                            CustomText(
                              title: controller.categoryModel[index].name!,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(width: 30),
                    ),
                  ),
                  SizedBox(height: h * .04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        title: "bestSelling".tr,
                        fontFamily: "PlayfairDisplay",
                        fontStyle: FontStyle.italic,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: CustomText(
                          title: "seeAll".tr,
                          fontFamily: "PlayfairDisplay",
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: h * .04),
                  // Best Selling Products List View
                  SizedBox(
                    height: .4 * h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => Get.to(
                            ProductDetailsView(
                              model: controller.bestSelling[index],
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  width: w * .5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: Colors.grey[100],
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: Image.network(
                                    controller.bestSelling[index].productImage!,
                                  ),
                                ),
                              ),
                              CustomText(
                                title:
                                    controller.bestSelling[index].productName!,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                              SizedBox(
                                width: w * .5,
                                child: CustomText(
                                  title: controller
                                      .bestSelling[index]
                                      .description!,
                                  fontSize: 18,
                                  color: Colors.grey.shade500,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              CustomText(
                                title:
                                    "\$${controller.bestSelling[index].price!}",
                                fontSize: 18,
                                color: primaryColor,
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(width: 20),
                      itemCount: controller.bestSelling.length > 5
                          ? 5
                          : controller.bestSelling.length,
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
