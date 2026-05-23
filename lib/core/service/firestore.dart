import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/model/cart_model.dart';
import 'package:e_commerce/model/order_model.dart';
import 'package:e_commerce/model/user_model.dart';

class FirestoreUser {
  final CollectionReference _userCollectionRef = FirebaseFirestore.instance
      .collection("Users");

  Future<void> addUserToFirestore(UserModel user) async {
    return await _userCollectionRef.doc(user.userId).set(user.toJson());
  }

  Future<void> updateUserInfo(UserModel user) async {
    return await _userCollectionRef
        .doc(user.userId)
        .set(user.toJson(), SetOptions(merge: true));
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _userCollectionRef.doc(uid).get();
  }
}

class HomeFireStoreService {
  final CollectionReference _categoryCollectionRef = FirebaseFirestore.instance
      .collection("Categories");
  final CollectionReference _productsCollectionRef = FirebaseFirestore.instance
      .collection("Products");

  Future<List<QueryDocumentSnapshot>> getCategory() async {
    var category = await _categoryCollectionRef.get();
    return category.docs;
  }

  Future<List<QueryDocumentSnapshot>> getBestSelling() async {
    var bestSelling = await _productsCollectionRef
        .orderBy("sellCount", descending: true)
        .limit(5)
        .get();
    return bestSelling.docs;
  }

  Future getProduct({required String productId}) async {
    var product = await _productsCollectionRef.doc(productId).get();
    return product;
  }
}

class CartFireStoreService {
  final CollectionReference _cartCollectionRef = FirebaseFirestore.instance
      .collection("Cart");

  Future<List<QueryDocumentSnapshot>> getCart(String uid) async {
    var cart = await _cartCollectionRef.where("uid", isEqualTo: uid).get();
    return cart.docs;
  }

  Future removeWholeCart(String uid) async {
    var snapshots = await _cartCollectionRef.where("uid", isEqualTo: uid).get();
    WriteBatch batch = FirebaseFirestore.instance.batch();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    return await batch.commit();
  }

  Future<void> updateCartItem(String cartId, int newAmount) async {
    return await _cartCollectionRef.doc(cartId).update({'amount': newAmount});
  }

  Future addItemToCart(CartModel cartItem) async {
    return await _cartCollectionRef.doc(cartItem.cartId).set(cartItem.toJson());
  }

  Future removeItemFromCart(String cartId) async {
    return await _cartCollectionRef.doc(cartId).delete();
  }
}

class OrderFireStoreService {
  final CollectionReference _orderCollectionRef = FirebaseFirestore.instance
      .collection("Orders");

  Future addOrder(OrderModel order) async {
    return await _orderCollectionRef.doc(order.orderId).set(order.toJson());
  }
  Future<List<DocumentSnapshot>> orderHistory(String userId)async{
   var orders = await _orderCollectionRef.where("userId",isEqualTo: userId).get();
     return orders.docs;
  }
}
