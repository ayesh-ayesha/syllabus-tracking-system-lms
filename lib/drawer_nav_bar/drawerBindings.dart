import 'package:get/get.dart';
import 'package:student_lms/userProfile/user_profile_repo.dart';

import '../userProfile/UserProfile_vm.dart';

class DrawerBindings extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => UserProfileVM());
    Get.lazyPut(() => UserProfileRepository());

  }

}