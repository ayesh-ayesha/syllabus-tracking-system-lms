import 'package:get/get.dart';
import 'package:student_lms/authentication/signUP/signup_vm.dart';

import '../../userProfile/UserProfile_vm.dart';
import '../../userProfile/user_profile_repo.dart';
import '../auth_repo.dart';

class SignupDependency extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(SignUpViewModel());
    Get.put(UserProfileRepository());
    Get.put(UserProfileVM());

  }}