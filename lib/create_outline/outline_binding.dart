import 'package:get/get.dart';
import 'package:student_lms/create_courses/course_VM.dart';
import 'package:student_lms/create_courses/course_repo.dart';
import 'outline_VM.dart';
import 'outlines_repo.dart';

class OutlineBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>OutlineVM());
    Get.lazyPut(()=>CourseVM());
    Get.lazyPut(()=>OutlineRepository());
    Get.lazyPut(()=>CourseRepository());

  }

}