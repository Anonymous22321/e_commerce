import 'package:e_commerce/core/service/firestore.dart';
import 'package:e_commerce/model/cart_model.dart';
import 'package:e_commerce/model/product_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/state_manager.dart';
import 'package:uuid/uuid.dart';

class CartViewModel extends GetxController {
  String? uid;
  late double totalPrice;

  final List<CartModel> _cartList = [];

  List<CartModel> get cartList => _cartList;

  final Map<String, ProductModel> _productDetails = {};

  Map<String, ProductModel> get productDetails => _productDetails;

  final ValueNotifier<bool> _loading = ValueNotifier(false);

  ValueNotifier<bool> get loading => _loading;

  // New list to store the actual product data
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
    // Get the current user ID automatically
    uid = _auth.currentUser?.uid;
    if (uid != null) {
      getCartItems();
    }
  }

  Future getCartItems() async {
    _loading.value = true;
    await CartFireStoreService().getCart(uid!).then((value) async {
      // _cartList.clear();
      // _productDetails.clear();
      for (int i = 0; i < value.length; i++) {
        _cartList.add(
          CartModel.fromJson(value[i].data() as Map<String, dynamic>),
        );
        var productSnapshot = await HomeFireStoreService().getProduct(
          productId: _cartList[i].productId!,
        );
        if (productSnapshot.exists) {
          _productDetails[_cartList[i].productId!] = ProductModel.fromJson(
            productSnapshot.data() as Map<String, dynamic>,
          );
        }
        print("Found ${_cartList[i].amount} amount");
        print("Found ${_productDetails[_cartList[i].productId]!.price} prices");
      }
      print("Found ${_cartList.length} items"); // Add this to debug
      calculateTotalPrice();

      _loading.value = false;

      update();
    });
  }

  // Helper method to calculate total price (cleaner)
  void calculateTotalPrice() {
    totalPrice = 0;
    for (int i = 0; i < _cartList.length; i++) {
      var product = _productDetails[_cartList[i].productId];
      if (product != null) {
        totalPrice += (product.price! * _cartList[i].amount!);
      }
    }
    update();
  }

  Future increment({required int index}) async {
    // 1. Update local data immediately (Instant UI feedback)
    _cartList[index].amount = _cartList[index].amount! + 1;

    // 2. Recalculate price locally
    calculateTotalPrice();

    // 3. Update Firebase in the background
    CartFireStoreService().updateCartItem(
      _cartList[index].cartId!,
      _cartList[index].amount!,
    );
  }

  Future decrement({required int index}) async {
    if (_cartList[index].amount! > 1) {
      // 1. Update local data
      _cartList[index].amount = _cartList[index].amount! - 1;

      // 2. Recalculate price
      calculateTotalPrice();

      // 3. Update Firebase
      CartFireStoreService().updateCartItem(
        _cartList[index].cartId!,
        _cartList[index].amount!,
      );
    }
  }

  Future addToCart({required String productId}) async {
    for (int i = 0; i < _cartList.length; i++) {
      if (productId == _cartList[i].productId) {
        return;
      }
    }
    CartFireStoreService().addItemToCart(
      CartModel(uid, productId, Uuid().v4(), 1),
    );
  }

  Future removeFromCart({required int index}) async {
    String cartId = _cartList[index].cartId!;
    _cartList.removeAt(index);
    calculateTotalPrice();
    update();
    await CartFireStoreService().removeItemFromCart(cartId);
  }

  Future removeWholeCart() async {
   await CartFireStoreService().removeWholeCart(_auth.currentUser!.uid);
   _cartList.clear();
   update();
  }
}
