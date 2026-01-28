import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/userProfile/UserProfile_vm.dart';


import '../../app_theme.dart';
import '../../userProfile/user_profile_model.dart';
import '../../userProfile/user_profile_repo.dart';
import '../auth_repo.dart';

class SignUpViewModel extends GetxController {
  AuthRepository authRepository = Get.find();
  UserProfileRepository userProfileRepository = Get.find();
  UserProfileVM userProfileVM = Get.find();
  UserProfile? userProfile;


  var isLoading = false.obs;
  var isAdmin = false.obs;
  var isBidder = false.obs;


  Future<void> signup(String email, String password, String confirmPassword,
      String displayName) async {
    if (!email.contains('@')) {
      Get.snackbar("Error", "Invalid Email",backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
      return;
    }
    if (password != confirmPassword) {
      Get.snackbar("Error", "password and confirm password must match",backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
      return;
    }

    if (email == 'ayesha@gmail.com' && password == confirmPassword) {
      isAdmin.value = true;
    } else {
      isAdmin.value == false;
    }
    if (displayName.isEmpty) {
      Get.snackbar("Error", "Enter Display name",backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
      return;
    }
    isLoading.value = true;


    try {
      UserCredential credential = await authRepository.signUp(email, password);
      String uid = credential.user!.uid;
      userProfile = UserProfile
          (id: uid,
          fullName: displayName,
          email: email,
          isAdmin: isAdmin.value,

      );
      await userProfileRepository.addUserProfile(userProfile!);
      Get.offAllNamed('/login');
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? 'SignUp Failed',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);

      //error
    } finally {
      isLoading.value = false;
    }
  }

  bool isUserLoggedIn() {
    return authRepository.getLoggedInUser() != null;
  }


}