import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/create_courses/course_VM.dart';
import 'package:student_lms/enrollments/enrollment_repo.dart';
import 'package:student_lms/my_courses/outline_progress_repo.dart';
import 'package:student_lms/userProfile/UserProfile_vm.dart';
import 'package:student_lms/userProfile/user_profile_model.dart';
import '../app_theme.dart';
import '../create_courses/course_model.dart';
import 'enrollment_model.dart';

class EnrollmentVM extends GetxController {
  EnrollmentRepository enrollmentRepository = Get.find();
  UserProfileVM userProfileVM = Get.find();
  CourseVM courseVM = Get.find();
  OutlineProgressRepo userProgressRepo = Get.find();


  var enrollmentsList = <Enrollment>[].obs;
  var enrollmentsOfCurrentStudentList = <Enrollment>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  late List<UserProfile> users;
  late List<Course> courses;

  var courseId = ''.obs;
  var studentId = ''.obs;

  // Inside EnrollmentVM


  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController enrollmentDateController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    fetchAllEnrollmentsStream();
    getCurrentStudentsEnrollmentStream();
    users=userProfileVM.usersProfiles;
    courses=courseVM.coursesList;
  }


  Future<void> addEnrollment() async {
    if (courseId.isEmpty) {
      debugPrint('studentId is empty');
      return;
    }
    if (studentId.isEmpty) {
      debugPrint('courseId is empty');
      return;
    }
    if (enrollmentsList.any((element) =>
    element.courseId == courseId.value &&
        element.studentId == studentId.value)) {
      Get.snackbar('Error', 'Student is already enrolled in this course', backgroundColor: errorColor.withValues(alpha:0.5), colorText: Colors.white);
      return;
    }


    try {
      Enrollment enrollment = Enrollment(enrollmentId: '',
          courseId: courseId.value,
          studentId: studentId.value,
          enrollmentDate: DateTime.now().toString());
      await enrollmentRepository.addEnrollment(enrollment);

      Get.snackbar('Success', 'Student is enrolled', backgroundColor: secondaryColor, colorText: Colors.white);
      isLoading.value = false;
      debugPrint('Enrollment added successfully ${enrollmentsList.length}');
    } catch (e) {
      debugPrint('Error adding enrollment: $e');
      Get.snackbar('Error', 'Failed to add enrollment: ${e.toString()},backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white',
        backgroundColor: errorColor.withValues(alpha:0.5), colorText: Colors.white);
    }
  }
  void fetchAllEnrollmentsStream() {
    enrollmentRepository.getAllEnrollmentsStream().listen((data) {
      enrollmentsList.value = data;
    });
  }

  void getCurrentStudentsEnrollmentStream(){
    enrollmentRepository.loadCurrentStudentCourses(userProfileVM.currentUser.value?.id).listen((data)
    {
      enrollmentsOfCurrentStudentList.value=data;
    });

  }

  void deleteEnrollment(id) {
    enrollmentRepository.deleteEnrollment(id);
    Get.snackbar('Success', 'Enrollment is deleted', backgroundColor: secondaryColor, colorText: Colors.white);
    Get.back();

  }

}
