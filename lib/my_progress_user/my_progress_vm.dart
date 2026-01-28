import 'package:get/get.dart';
import 'package:student_lms/enrollments/enrollment_VM.dart';
import 'package:student_lms/my_courses/course_progress_repo.dart';
import 'package:student_lms/my_courses/outline_progress_vm.dart';

import '../create_courses/course_VM.dart';
import '../my_courses/course_progress_model.dart';
import '../userProfile/UserProfile_vm.dart';

class MyProgressVM extends GetxController{

  CourseVM courseVM=Get.find();
  CourseProgressRepo courseProgressRepo=Get.find();
  OutlineProgressVM outlineProgressVM=Get.find();
  EnrollmentVM enrollmentVM=Get.find();

  String get totalEnrollments=> enrollmentVM.enrollmentsOfCurrentStudentList.length.toString();

  List<CourseProgressModel> get courseProgress=> outlineProgressVM.courseProgressList.where((element)=>element.isCompleted==true).toList();





}