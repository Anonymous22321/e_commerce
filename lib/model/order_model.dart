import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/model/cart_model.dart';
import 'package:e_commerce/model/product_model.dart';

class OrderModel {
  String userId, orderId,status;
  Timestamp dateTime;
  double totalPrice;
  Address address;
  Map<String,ProductModel> products;
  List<CartModel> cart;

  OrderModel({
    required this.userId,
    required this.dateTime,
    required this.totalPrice,
    required this.status,
    required this.address,
    required this.products,
    required this.cart,
    required this.orderId,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'orderId': orderId,
      'dateTime': dateTime,
      'totalPrice': totalPrice,
      'status': status,
      'address': address.toMap(),
      'products': products.map((key, value) => MapEntry(key, value.toJson()),),
      'cart': cart.map((item) => item.toJson()).toList(),
    };
  }

  factory OrderModel.fromJson(Map<String, dynamic> map) {
    return OrderModel(
      userId: map['userId'] ?? '',
      orderId: map['orderId'] ?? '',
      totalPrice: map['totalPrice'] ?? 0,
      // Fix: You had 'orderId' here by mistake
      status: map['status'] ?? 'Pending',
      dateTime: map['dateTime'] as Timestamp,
      // Fix: Use the fromMap constructor
      address: Address.fromMap(map['address']),
      // Fix: Mapping the products back to objects
      products: (map['products'] as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, ProductModel.fromJson(value)),
      ),
      // Fix: Mapping the list back to objects
      cart: (map['cart'] as List).map((item) => CartModel.fromJson(item)).toList(),
    );
  }}

class Address {
  String street1, street2, city, state, country;

  Address({
    required this.street1,
    required this.street2,
    required this.city,
    required this.state,
    required this.country,
  });

  Map<String, dynamic> toMap() {
    return {
      'street1': street1,
      'street2': street2,
      'city': city,
      'state': state,
      'country': country,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street1: map['street1'] as String,
      street2: map['street2'] as String,
      city: map['city'] as String,
      state: map['state'] as String,
      country: map['country'] as String,
    );
  }
}
