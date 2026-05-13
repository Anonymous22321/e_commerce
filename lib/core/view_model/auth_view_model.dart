import 'package:e_commerce/core/service/firestore.dart';
import 'package:e_commerce/helper/local_storage_data.dart';
import 'package:e_commerce/model/user_model.dart';
import 'package:e_commerce/view/control_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthViewModel extends GetxController {
  // take instance of methods
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? name, email, password;

  // reserve user data to check if the user made login before or not
  final Rx<User?> _user = Rx<User?>(null);

  String? get user => _user.value?.email;

  // try to make password hidden
  Rx<bool> isPasswordHidden = true.obs;
  Rx<bool> isLoading = false.obs;

  final LocalStorageData localStorageData = Get.find();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  // final FacebookAuth _facebookAuth= FacebookAuth.instance;

  @override
  void onInit() {
    super.onInit();
    _user.bindStream(_auth.authStateChanges());
  }

  // make a function to sign in using google account
  void googleSignInMethod() async {
    isLoading.value = true;
    //reserve the sign in data into variable
    // match the data called GoogleSignInAccount
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    // let's see what the googleUser contains

    // here by access authentication we can get tokens we need
    // don't forget to reserve data into match variable
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleUser!.authentication;
    // here to get credential by using GoogleAuthProvider.credential
    // Of course we should reserve data into variable match it
    // Another problem how to get idToken,accessToken
    // Check above to know
    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    // Let's reserve data into firebase
    // but how to get credential
    await _auth.signInWithCredential(credential).then((user) async {
      saveUserData(user);
      Get.snackbar(
        "Success",
        "Login Successful",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: Duration(seconds: 5),
      );
    });
    isLoading.value = false;
  }
  void emailAndPasswordSignInMethod() async {
    try {
      isLoading.value = true;
      // 1. Try to Login
      await _auth
          .signInWithEmailAndPassword(
            email: email!.trim().toLowerCase(),
            password: password!.trim(),
          )
          .then((value) async {
            await FirestoreUser()
                .getUserData(value.user!.uid)
                .then(
                  (value) => setUserData(
                    UserModel.fromJson(value.data() as Map<String, dynamic>),
                  ),
                );
          });
      Get.snackbar(
        "Login Successful",
        "Welcome back",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: Duration(seconds: 5),
      );
      // Get.offAll(ControlView());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential' || e.code == 'user-not-found') {
        // 2. If login fails because user isn't found, suggest signing up
        Get.snackbar(
          "User Not Found",
          "Are you new ?\n"
              "Register now!",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black,
          backgroundColor: Colors.white,
          duration: Duration(seconds: 5),
        );
      } else {
        Get.snackbar("Error", e.message ?? "Login failed");
        print(e.code);
      }
    } finally {
      isLoading.value = false;
    }
  }

  void registerUser() async {
    isLoading.value = true;
    try {
      await _auth
          .createUserWithEmailAndPassword(
            email: email!.trim().toLowerCase(),
            password: password!.trim(),
          )
          .then((user) async {
            saveUserData(user);
          });
      Get.snackbar(
        "Register Successful",
        "Welcome,$name ",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.black,
        backgroundColor: Colors.white,
        duration: Duration(seconds: 5),
      );
      isLoading.value = false;
      Get.offAll(ControlView());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        Get.snackbar(
          "Register failed",
          "The email address is already in use by another account. Please go to login",
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.black,
          backgroundColor: Colors.white,
          duration: Duration(seconds: 5),
        );
      } else {
        Get.snackbar("Error", e.message ?? "Login failed");
        print(e.code);
      }
    }
  }

  void saveUserData(UserCredential user) async {
    // 1. Check if the user already exists in Firestore
    var userDoc = await FirestoreUser().getUserData(user.user!.uid);

    if (!userDoc.exists) {
      // 2. This is a BRAND NEW user (either Register or first-time Google Login)
      UserModel userModel = UserModel(
        email: user.user!.email,
        userId: user.user!.uid,
        pic: user.user!.photoURL ?? "", // Use Google profile pic if available
        username: name ?? user.user!.displayName ?? "User",
      );

      await FirestoreUser().addUserToFirestore(userModel);
      setUserData(userModel);
    } else {
      // 3. RETURNING User: Do not overwrite! Just fetch their existing custom data.
      UserModel existingUser = UserModel.fromJson(
        userDoc.data() as Map<String, dynamic>,
      );
      setUserData(existingUser);
    }
  }

  void setUserData(UserModel userModel) async {
    await localStorageData.setUser(userModel);
  }

  // void facebookSignInMethod() async {
  //  LoginResult result = await _facebookAuth.login(permissions:['email']);
  //  print(result);
  // if(result.status == LoginStatus.success){
  //   final accessToken=  result.accessToken!.tokenString;
  //   AuthCredential faceCredential = FacebookAuthProvider.credential(accessToken);
  //   await _auth.signInWithCredential(faceCredential);
  // }
  //
  //on FirebaseAuthException catch (e) {
  //     if (e.code == 'invalid-credential' || e.code == 'user-not-found') {
  //       // 2. If login fails because user isn't found, suggest signing up
  //       Get.defaultDialog(
  //         title: "User Not Found",
  //         middleText: "Would you like to create a new account?",
  //         textConfirm: "Sign Up",
  //         onConfirm: () => signUpMethod(),
  //         textCancel: "Cancel",
  //       );
  //     }
  //
  // }
}
