class CartModel {
  String? uid, productId, cartId;
  int? amount;
  CartModel(this.uid, this.productId, this.cartId, this.amount);

  CartModel.fromJson(Map<String,dynamic> cartMap){
    if (cartMap.isEmpty) {
      return;
    }
    uid = cartMap ["uid"];
    productId = cartMap ["productId"];
    cartId = cartMap ["cartId"];
    amount = cartMap ["amount"];
  }
  Map<String, Object?> toJson(){
    return {
      "uid" : uid,
      "productId" : productId,
      "cartId" : cartId,
      "amount" : amount,
    };
  }

}