import 'package:get/get.dart';
import 'package:student_lms/authentication/auth_repo.dart';
import 'package:student_lms/authentication/login/login_vm.dart';
import 'UserProfile_vm.dart';

class UserProfileBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => LoginViewModel());
    Get.lazyPut(() => AuthRepository());
  }

}