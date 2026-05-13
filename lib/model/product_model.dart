// contain the model of the product that will be passed to model view
// any process should we do in model must be here

import 'dart:ui';

import 'package:e_commerce/helper/extension.dart';

class ProductModel {
  String? productName, productImage, description, size,productId;
  double? price;
  Color? color;
  int? sellCount;

  ProductModel({
    this.productName,
    this.productId,
    this.color,
    this.size,
    this.description,
    this.productImage,
    this.sellCount = 0,
    this.price,
  });

  ProductModel.fromJson(Map<dynamic, dynamic> map) {
    if (map.isEmpty) {
      return;
    }
    productImage = map["productImage"];
    productName = map["productName"];
    productId = map[ "productId"];
    color = HexColor.fromHex(map["color"]);
    size = map["size"] == "" ? "-" : map["size"];
    description = map["description"];
    sellCount = map["sellCount"];
    price = map["price"];
  }
  Map<String, dynamic> toJson() {
    return {
      "productImage": productImage,
      "productName": productName,
      "productId": productId,
      "description": description,
      "size": size,
      "color": color!.toHex(),
      "sellCount": sellCount,
      "price": price,
    };
  }
}
