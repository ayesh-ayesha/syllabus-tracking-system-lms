import 'package:get/get.dart';
import 'package:student_lms/create_courses/course_repo.dart';
import 'package:student_lms/my_courses/course_progress_repo.dart';
import 'package:student_lms/my_progress_user/my_progress_vm.dart';

import '../create_courses/course_VM.dart';
import '../enrollments/enrollment_VM.dart';
import '../enrollments/enrollment_repo.dart';
import '../my_courses/outline_progress_repo.dart';
import '../my_courses/outline_progress_vm.dart';

class MyProgressBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
   Get.lazyPut(()=>MyProgressVM());
   Get.lazyPut(()=>CourseVM());
   Get.lazyPut(()=>OutlineProgressVM ());
   Get.lazyPut(()=>EnrollmentVM());
   Get.lazyPut(()=>CourseProgressRepo());
   Get.lazyPut(()=>CourseRepository());
   Get.lazyPut(()=>OutlineProgressRepo());
   Get.lazyPut(()=>EnrollmentRepository());

  }

}