import 'package:e_commerce/core/service/firestore.dart';
import 'package:e_commerce/model/category_model.dart';
import 'package:e_commerce/model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeViewModel extends GetxController {
  final List<CategoryModel> _categoryModel = [];
  List<CategoryModel> get categoryModel => _categoryModel;

  final List<ProductModel> _bestSellingModel = [];
  List<ProductModel> get bestSelling => _bestSellingModel;

  final ValueNotifier<bool> _loading = ValueNotifier(false);
  ValueNotifier<bool> get loading => _loading;

  Future<void> getCategory() async {
    _loading.value = true;
    await HomeFireStoreService().getCategory().then((value) {
      for (int i = 0; i < value.length; i++) {
        var data = value[i].data() as Map<String, dynamic>;
        _categoryModel.add(CategoryModel.fromJson(data));
      }
      _loading.value = false;
      update();
      print("Category items count:${_categoryModel.length}");
    });
  }

  void getBestSellingItems() {
    _loading.value = true;
    HomeFireStoreService().getBestSelling().then((value) {
      for (int i = 0; i < value.length; i++) {
        var collectionData = value[i].data() as Map<String, dynamic>;
        _bestSellingModel.add(ProductModel.fromJson(collectionData));
      }
      _loading.value = false;
      update();
      print("bestSelling items count:${_bestSellingModel.length}");
    });
  }

  HomeViewModel() {
    getBestSellingItems();
    getCategory();
  }
}
