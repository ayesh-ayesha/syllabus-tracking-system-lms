import 'package:get/get.dart';
import 'package:student_lms/authentication/resetPassword/reset_password_vm.dart';

import '../auth_repo.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(ResetPasswordVm());
  }
}