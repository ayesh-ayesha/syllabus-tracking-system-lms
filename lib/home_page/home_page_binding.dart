import 'package:get/get.dart';
import 'package:student_lms/authentication/auth_repo.dart';
import 'package:student_lms/authentication/login/login_vm.dart';
import 'package:student_lms/create_courses/course_VM.dart';
import 'package:student_lms/create_courses/course_repo.dart';
import 'package:student_lms/create_outline/outlines_repo.dart';
import 'package:student_lms/enrollments/enrollment_VM.dart';
import 'package:student_lms/enrollments/enrollment_repo.dart';
import 'package:student_lms/home_page/homePageVm.dart';
import 'package:student_lms/my_courses/course_progress_repo.dart';
import 'package:student_lms/my_courses/outline_progress_repo.dart';
import 'package:student_lms/my_courses/outline_progress_vm.dart';
import 'package:student_lms/userProfile/UserProfile_vm.dart';
import 'package:student_lms/userProfile/user_profile_repo.dart';


class HomePageBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=>HomePageVM());
    Get.lazyPut(()=>CourseVM());
    Get.lazyPut(()=>OutlineProgressVM());
    Get.lazyPut(()=>EnrollmentVM());
    Get.lazyPut(()=>UserProfileVM());
    Get.lazyPut(()=>CourseRepository());
    Get.lazyPut(()=>OutlineRepository());
    Get.lazyPut(()=>CourseProgressRepo());
    Get.lazyPut(()=>EnrollmentRepository());
    Get.lazyPut(()=>OutlineProgressRepo());


  }

}