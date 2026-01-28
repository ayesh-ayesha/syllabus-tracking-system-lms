import 'package:get/get.dart';
import 'package:student_lms/create_courses/course_VM.dart';
import 'package:student_lms/enrollments/enrollment_VM.dart';
import 'package:student_lms/my_courses/outline_progress_vm.dart';
import 'package:student_lms/userProfile/UserProfile_vm.dart';

import '../create_courses/course_model.dart';
import '../my_courses/course_progress_model.dart';

class HomePageVM extends GetxController{
  UserProfileVM userProfileVM=Get.find();
  CourseVM courseVM=Get.find();
  EnrollmentVM enrollmentVM=Get.find();
  OutlineProgressVM outlineProgressVM=Get.find();

  String get totalCourses => courseVM.coursesList.length.toString();
  String get totalStudents => userProfileVM.usersProfiles.length.toString();
  String get totalEnrollments=> enrollmentVM.enrollmentsOfCurrentStudentList.length.toString();
  List<CourseProgressModel> get inProgressList => outlineProgressVM.courseProgressList
      .where((c) => c.completedAt == null).toList();
  List<Course> get activeCoursesDetails {
    // Get all IDs from your progress list
    final activeIds = inProgressList.map((e) => e.courseId).toSet();

    // Find the actual Course objects that match those IDs
    return courseVM.coursesList
        .where((course) => activeIds.contains(course.id))
        .toList();
  }

}