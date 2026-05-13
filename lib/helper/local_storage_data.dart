import 'dart:convert';
import 'dart:developer';

import 'package:e_commerce/constants/constants.dart';
import 'package:e_commerce/model/user_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageData extends GetxController {

  Future get getUser async {
    try{
      UserModel? userModel = await _getUserData();
      if(userModel == null){
        return;
      }
      return userModel;
    }catch(e){
      log("$e");
      return null;
    }
  }

  Future<UserModel?> _getUserData() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? value = preferences.getString(Constants.CASHED_USER_DATA);
    if (value == null) return null; // Safety check
    return UserModel.fromJson(json.decode(value));
  }

  Future<void> setUser(UserModel userModel) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.setString(
      Constants.CASHED_USER_DATA,
      json.encode(userModel.toJson()),
    );
    log("New User Added: ${userModel.username}");
  }
  Future<void> deleteUserData()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.clear();
  }
}
