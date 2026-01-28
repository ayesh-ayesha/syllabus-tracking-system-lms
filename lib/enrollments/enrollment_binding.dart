import 'package:get/get.dart';
import 'package:student_lms/create_courses/course_repo.dart';
import 'package:student_lms/enrollments/enrollment_VM.dart';
import 'package:student_lms/enrollments/enrollment_repo.dart';
import 'package:student_lms/my_courses/outline_progress_repo.dart';
import 'package:student_lms/userProfile/UserProfile_vm.dart';
import 'package:student_lms/userProfile/user_profile_repo.dart';
import '../create_courses/course_VM.dart';

class EnrollmentBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>CourseVM());
    Get.lazyPut(()=>UserProfileVM());
    Get.lazyPut(()=>EnrollmentVM());


    Get.lazyPut(()=>CourseRepository());
    Get.lazyPut(()=>UserProfileRepository());
    Get.lazyPut(()=>EnrollmentRepository());
    Get.lazyPut(()=>OutlineProgressRepo());

  }

}