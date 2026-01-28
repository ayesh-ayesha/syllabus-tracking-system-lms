
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/app_theme.dart';


import '../auth_repo.dart';


class ResetPasswordVm extends GetxController {
  AuthRepository authRepository=Get.find();
  var isLoading=false.obs;

  Future<void> reset(String email) async {
    if (!email.contains('@')){
      Get.snackbar("Error", "Invalid Email",backgroundColor:errorColor.withValues(alpha: 0.5) );
      return;
    }

    isLoading.value=true;
    try{
      await authRepository.resetPassword(email);
      Get.snackbar("Success", "Password reset email sent to $email",backgroundColor: secondaryColor,colorText: Colors.white);
      Get.offAllNamed('/Login');
    }on FirebaseAuthException catch(e){
      Get.snackbar("Error", e.message??' Failed to send reset password email',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);

      //error
    }finally{
      isLoading.value=false;

    }

  }


}