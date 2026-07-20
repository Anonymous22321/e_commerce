import 'dart:developer';
import 'dart:io';

import 'package:e_commerce/core/service/firestore.dart';
import 'package:e_commerce/core/view_model/app_language.dart';
import 'package:e_commerce/helper/local_storage_data.dart';
import 'package:e_commerce/model/order_model.dart';
import 'package:e_commerce/model/user_model.dart';
import 'package:e_commerce/view/profile/edit_profile.dart';
import 'package:e_commerce/view/profile/order_history.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileViewModel extends GetxController {
  final LocalStorageData localStorageData = Get.find();

  UserModel get userModel => _userModel;
  late UserModel _userModel;

  File? pickedImage;
  final Rx<bool> _isLoading = false.obs;

  // The key is the formatted date string (e.g., "May 10, 2026")
  // The value is a list of maps, where each map contains a specific product's data plus its order status
  List<OrderModel> orders = [];
  Map<String, List<Map<String, dynamic>>> groupedOrdersProducts = {};

  Rx<bool> get isLoading => _isLoading;
  final ValueNotifier<bool> _hiddenPassword = ValueNotifier(true);

  ValueNotifier<bool> get hiddenPassword => _hiddenPassword;
  String? password, confirmPassword, name;

  @override
  void onInit() {
    super.onInit();
    getCurrentUser();
  }

  void togglePasswordVisibility() {
    _hiddenPassword.value = !_hiddenPassword.value;
    update();
  }

  void getCurrentUser() async {
    _isLoading.value = true;
    await localStorageData.getUser.then((value) => _userModel = value);
    _isLoading.value = false;
    update();
  }

  void action(int index) {
    switch (index) {
      case 0:
        Get.to(EditProfile());
        break;
      case 2:
        orderHistory().then((_) {
          // 2. Only navigate to the screen once the map is fully populated
          Get.to(() => OrderHistory());
        });
        break;
      case 5:
        changeLanguage();
        break;
      case 6:
        signOut();
        break;
    }
  }

  void signOut() {
    GoogleSignIn().signOut();
    FirebaseAuth.instance.signOut();
    localStorageData.deleteUserData();
  }

  Future<void> pickImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      pickedImage = File(image.path);
      update();
    }
  }

  Future editProfile() async {
    _isLoading.value = true;
    update();
    try {
      if (pickedImage != null) {
        String pathFile = "Users/Profile_${userModel.userId}.png";
        String getImageUrl;
        await Supabase.instance.client.storage
            .from("images")
            .upload(
              pathFile,
              pickedImage!,
              fileOptions: FileOptions(upsert: true),
            );
        getImageUrl = Supabase.instance.client.storage
            .from("images")
            .getPublicUrl(pathFile);
        String profileImageURL =
            "$getImageUrl?t=${DateTime.now().millisecondsSinceEpoch}";
        _userModel.pic = profileImageURL;
        pickedImage = null;
      }
      if (name != null && name!.isNotEmpty) {
        _userModel.username = name!;
      }
      // 3. Sync to Database (using the updated existing model)
      await FirestoreUser().updateUserInfo(_userModel);

      // 4. Sync to Local Storage
      await localStorageData.setUser(_userModel);
      name = null;
      Get.back(); // Automatically returns to profile screen after saving
      Get.snackbar("Success", "Profile updated successfully");

      // if(password !=null){
      //   try {
      //     await FirebaseAuth.instance.currentUser!.updatePassword(password!);
      //   } on FirebaseAuthException catch (e) {
      //     if (e.code == 'requires-recent-login') {
      //       // 1. Tell the user why it failed
      //       Get.snackbar(
      //         "Security Timeout",
      //         "Please log out and log back in to change your password.",
      //         snackPosition: SnackPosition.BOTTOM,
      //         backgroundColor: Colors.red,
      //         colorText: Colors.white,
      //       );
      //       // 2. Optionally, you could force them to the login screen
      //       // Get.offAll(LoginView());
      //     } else {
      //       Get.snackbar("Error", e.message ?? "Password update failed");
      //     }
      //   }
      // }
      update();
    } catch (e) {
      log(e.toString());
    } finally {
      _isLoading.value = false;
      update();
    }
  }

  Future orderHistory() async {
    try {
      _isLoading.value = true;
      await OrderFireStoreService().orderHistory(userModel.userId!).then((
        value,
      ) {
        //TODO 1. Clear previous data so tracking doesn't duplicate when refreshing
        orders.clear();
        groupedOrdersProducts.clear();

        //TODO 2. Map snapshot docs into your local order list
        for (int i = 0; i < value.length; i++) {
          final Map<String, dynamic>? data =
              value[i].data() as Map<String, dynamic>?;

          if (data != null) {
            orders.add(OrderModel.fromJson(data));
          }
        }

        //TODO 3. Flatten the orders down to a product level
        for (var order in orders) {
          // Format your date timestamp to match "Sept 23, 2018"
          DateTime date = order.dateTime.toDate();
          String formattedOrderDate = DateFormat.yMMMd().format(date);

          // Initialize key if missing
          if (!groupedOrdersProducts.containsKey(formattedOrderDate)) {
            groupedOrdersProducts[formattedOrderDate] = [];
          }
          // Loop through the inner products map from Firestore
          // Loop through the inner products map from your OrderModel
          order.products.forEach((productId, productData) {
            // Read attributes directly from the model object instead of a Map cast
            groupedOrdersProducts[formattedOrderDate]!.add({
              'orderId': order.orderId,
              'status': order.status,
              'name': productData.productName ?? 'Unknown Item',
              'price': productData.price ?? 0,
              'image': productData.productImage ?? '',
            });
          });
        }
      });
      _isLoading.value=false;
    } on FirebaseException catch (e) {
      Get.log(e.message.toString());
    }
  }

  void changeLanguage() {
    Get.bottomSheet(
      GetBuilder<AppLanguage>(
        init: AppLanguage(), // Re-use the initialized global language controller
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Title and Close Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Language',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.grey, size: 28),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),

                // English Option
                _buildLanguageTile(
                  title: 'English',
                  flagAsset: 'assets/images/en_flag.png', // Replace with your actual asset path
                  value: 'en',
                  groupValue: controller.appLocale,
                  onChanged: (val) {
                    controller.changeLanguage(val!);
                    Get.updateLocale(Locale(val));
                    Get.back(); // Close bottom sheet on selection
                  },
                ),
                const Divider(),

                // Arabic Option (Or any other language from your design)
                _buildLanguageTile(
                  title: 'Arabic',
                  flagAsset: 'assets/images/ar_flag.png', // Replace with your actual asset path
                  value: 'ar',
                  groupValue: controller.appLocale,
                  onChanged: (val) {
                    controller.changeLanguage(val!);
                    Get.updateLocale(Locale(val));
                    Get.back();
                  },
                ),
                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  // Custom helper to style list options to match your design
  Widget _buildLanguageTile({
    required String title,
    required String flagAsset,
    required String value,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    final bool isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.black : Colors.grey[600],
              ),
            ),
            Row(
              children: [
                // Display flag
                Image.asset(
                  flagAsset,
                  width: 60,
                  height: 50,
                  fit: BoxFit.fill,
                ),
                const SizedBox(width: 12),
                // Radio button indicator
                Radio<String>(
                  value: value,
                  groupValue: groupValue,
                  onChanged: onChanged,
                  activeColor: Colors.green, // Match theme accent
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }}
