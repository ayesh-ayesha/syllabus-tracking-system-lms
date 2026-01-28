
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/app_theme.dart';
import 'package:student_lms/userProfile/user_profile_repo.dart';

import '../../userProfile/UserProfile_vm.dart';
import '../auth_repo.dart';


class LoginViewModel extends GetxController {
  AuthRepository authRepository=Get.find();
  UserProfileRepository userProfileRepository=Get.find();
  var isLoading=false.obs;

  Future<void> login(String email, String password) async {
    // 1. Basic Validation (Email/Password format)
    if (!email.contains('@')) {
      Get.snackbar("Error", "Invalid Email",backgroundColor: errorColor.withValues(alpha: 0.5) );
      return;
    }
    if (password.length < 6) {
      Get.snackbar("Error", "Password should be at least 6 characters",backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      // 2. Log in FIRST (This generates the User ID)
      await authRepository.login(email, password);

      // 3. NOW check if they are active (Since they are logged in, we have an ID)
      String? uid = getCurrentUserId();

      // Safety check: Ensure UID is not null
      if (uid != null) {
        bool isActive = await userProfileRepository.getUserIsActive(uid);

        if (isActive) {
          // Success: User is active, go to home
          Get.offAllNamed('/home');
        } else {
          // Failure: User is NOT active
          // IMPORTANT: Log them out immediately so they don't stay signed in
          await FirebaseAuth.instance.signOut();
          Get.snackbar("Access Denied", "Your account is not active. Please contact admin.",backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
        }
      } else {
        Get.snackbar("Error", "Login succeeded but User ID was null.",backgroundColor: secondaryColor,colorText: Colors.white);
      }

    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? 'Login Failed',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
    } catch (e) {
      // Catch other errors (like network issues fetching the profile)
      Get.snackbar("Error", "An unexpected error occurred: $e",backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
      // Ensure we don't leave them in a weird logged-in state if the profile check fails
      await FirebaseAuth.instance.signOut();
    } finally {
      isLoading.value = false;
    }
  }
  bool isUserLoggedIn(){
    return authRepository.getLoggedInUser()!=null;
  }


  void logout() async {
    await authRepository.logout(); // your Firebase signOut logic

    // Reset user profile data
    final UserProfileVM userProfileVM = Get.find();
    userProfileVM.clearUser();

    Get.offAllNamed('/login'); // go back to login screen
  }


  String? getCurrentUserId() {
    User? currentUser = FirebaseAuth.instance.currentUser;
    return currentUser?.uid; // Returns the Firebase user ID
  }

}