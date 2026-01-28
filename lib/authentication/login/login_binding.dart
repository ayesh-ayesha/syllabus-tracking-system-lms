import 'package:get/get.dart';
import '../../userProfile/UserProfile_vm.dart';
import '../../userProfile/user_profile_repo.dart';
import '../auth_repo.dart';
import 'login_vm.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthRepository());
    Get.put(UserProfileRepository());
    Get.put(LoginViewModel());
    Get.put(UserProfileVM());
  }
}
