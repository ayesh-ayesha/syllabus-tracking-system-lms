import 'package:get/get.dart';
import 'package:student_lms/create_courses/course_VM.dart';
import 'package:student_lms/enrollments/enrollment_VM.dart';
import 'package:student_lms/enrollments/enrollment_repo.dart';
import 'package:student_lms/my_courses/course_progress_repo.dart';
import 'package:student_lms/my_courses/outline_progress_repo.dart';
import 'package:student_lms/my_courses/outline_progress_vm.dart';

import '../create_courses/course_repo.dart';
import '../create_outline/outline_VM.dart';
import '../create_outline/outlines_repo.dart';

class UserProgressBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>OutlineVM());
    Get.lazyPut(()=>CourseVM());
    Get.lazyPut(()=>OutlineProgressVM());
    Get.lazyPut(()=>EnrollmentVM());
    Get.lazyPut(()=>CourseProgressRepo());
    Get.lazyPut(()=>EnrollmentRepository());
    Get.lazyPut(()=>OutlineProgressRepo());
    Get.lazyPut(()=>CourseRepository());
    Get.lazyPut(()=>OutlineRepository());
  }

}