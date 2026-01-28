import 'package:get/get.dart';

import 'course_VM.dart';
import 'course_repo.dart';

class CourseBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(()=>CourseVM());
    Get.lazyPut(()=>CourseRepository());
  }

}