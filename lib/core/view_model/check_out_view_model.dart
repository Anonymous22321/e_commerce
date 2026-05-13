import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/constants/colors.dart';
import 'package:e_commerce/constants/row_constants.dart';
import 'package:e_commerce/core/service/firestore.dart';
import 'package:e_commerce/core/view_model/cart_view_model.dart';
import 'package:e_commerce/model/order_model.dart';
import 'package:e_commerce/view/check_out/widgets/add_address.dart';
import 'package:e_commerce/view/check_out/widgets/delevery_time.dart';
import 'package:e_commerce/view/check_out/widgets/summary.dart';
import 'package:e_commerce/view/control_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class CheckOutViewModel extends GetxController {
  int get currentIndex => _currentIndex;
  int _currentIndex = 0;

  Pages get pages => _pages;
  Pages _pages = Pages.deliveryTime;

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  ValueNotifier<bool> get loading => _loading;

  Delivery _delivery = Delivery.standardDelivery;

  Delivery get delivery => _delivery;

  late String street1, street2, city, state, country;

  String get fullAddress =>
      '${street1 + ',' + street2 + ',' + city + ',' + state + ',' + country}';

  GlobalKey<FormState> addressGlobalKey = GlobalKey();

  void setDelivery(Delivery? value) {
    if (value != null) {
      _delivery = value;
      update(); // This refreshes the UI
    }
  }

  void changeIndex(int index) {
    // Prevent index from going out of bounds
    if (index >= 0 && index <= 3) {
      // Check validation BEFORE updating the index
      if (index > _currentIndex) {
        // Only validate when moving FORWARD
        if (_currentIndex == 1) {
          // If we are leaving the Address page
          if (addressGlobalKey.currentState != null) {
            addressGlobalKey.currentState?.save();
            if (!addressGlobalKey.currentState!.validate()) {
              return; // STOP HERE. Don't update index or call update()
            }
          }
        }
      }
      _currentIndex = index;
      // Update the pages enum based on the index so the body knows what to show
      if (_currentIndex == 0) _pages = Pages.deliveryTime;
      if (_currentIndex == 1) _pages = Pages.addAddress;
      if (_currentIndex == 2) {
        addressGlobalKey.currentState!.save();
        if (addressGlobalKey.currentState!.validate()) {
          _pages = Pages.summary;
        } else
          return;
      }
      if (_currentIndex == 3) {
        Get.offAll(ControlView());
        _currentIndex = 0;
      }
      _pages = Pages.values[_currentIndex];

      update(); // CRITICAL: This tells GetBuilder to refresh the UI
    }
  }

  Widget get selectedWidget {
    switch (_pages) {
      case Pages.deliveryTime:
        return DeliveryTime();
      case Pages.addAddress:
        return AddAddress();
      case Pages.summary:
        return Summary();
      default:
        return DeliveryTime();
    }
  }

  Color getDotColor(int index) {
    if (index < _currentIndex) {
      return primaryColor;
    } else {
      return todoColor;
    }
  }

  Color getLineColor(int index, bool isLeading) {
    // Leading line (left of dot)
    if (isLeading) {
      if (index == 0) return Colors.transparent;
      return index <= _currentIndex ? Colors.green : Colors.grey.shade300;
    }
    // Trailing line (right of dot)
    else {
      if (index == 2) return Colors.transparent;
      return index < _currentIndex ? Colors.green : Colors.grey.shade300;
    }
  }

  Future addOrder() async {
    loading.value = true;
    var cartController = Get.find<CartViewModel>();
    try {
      await OrderFireStoreService().addOrder(
        OrderModel(
          userId: FirebaseAuth.instance.currentUser!.uid,
          dateTime: Timestamp.now(),
          status: "Pending",
          address: Address(
            street1: street1,
            street2: street2,
            city: city,
            state: state,
            country: country,
          ),
          totalPrice: cartController.totalPrice,
          products: cartController.productDetails,
          cart: cartController.cartList,
          orderId: Uuid().v4(),
        ),
      );
      cartController.cartList.clear();
      cartController.cartList.clear();
      changeIndex(currentIndex + 1);
      await cartController.removeWholeCart();
      Get.snackbar("Success", "Order placed successfully!");
    } on FirebaseException catch (e) {
      log(e.message.toString());
    } catch (e) {
      Get.snackbar("Order Failed", e.toString());
    } finally {
      loading.value = false;
      update();
    }
  }
}
