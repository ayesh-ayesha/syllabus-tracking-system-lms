import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../app_theme.dart';
import 'course_model.dart';
import 'course_repo.dart';

class CourseVM extends GetxController {
  CourseRepository courseRepository = Get.find();

  var coursesList = <Course>[].obs;
  final filteredCourses = <Course>[].obs;

  var isLoading =false.obs;
  var errorMessage = ''.obs;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController courseNameController = TextEditingController();
  TextEditingController courseFeeController = TextEditingController();
  TextEditingController courseDurationController = TextEditingController();
  TextEditingController courseDescriptionController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchAllCoursesStream();
    ever(coursesList, (_) {
      filteredCourses.assignAll(coursesList);
    });
    // checkForIncomingArguments();
  }

  @override
  void onClose() {
    courseNameController.dispose();
    courseFeeController.dispose();
    courseDurationController.dispose();
    courseDescriptionController.dispose();
    courseFeeController.dispose();
    super.onClose();
  }

  void clearFields() {
    courseFeeController.clear();
    courseNameController.clear();
    courseDescriptionController.clear();
    courseFeeController.clear();
    courseDescriptionController.clear();
  }

  Future<void> addCourse() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    try {
      Course course = Course(
        id: '',
        courseName: courseNameController.text,
        courseFee: courseFeeController.text,
        courseDuration: courseDurationController.text,
        courseDescription:  courseDescriptionController.text,
      );
      await courseRepository.addCourse(course);
      Get.snackbar('Success', 'Course is added', backgroundColor: secondaryColor, colorText: Colors.white);
      isLoading.value = false;
      clearFields();
    } catch (e) {
      debugPrint('Error adding course: $e');
      Get.snackbar('Error', 'Failed to add course: ${e.toString()}',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
    }
  }

  Future<void> updateCourse(Course course) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      Course updatedProfile = Course(
        id: course.id,
        courseName: courseNameController.text,
        courseFee: courseFeeController.text,
        courseDuration: courseDurationController.text,
        courseDescription:  courseDescriptionController.text,
      );
      await courseRepository.updateCourse(updatedProfile);
      Get.back();
      clearFields();
      Get.snackbar('Success', 'Course is updated',backgroundColor: secondaryColor,colorText: Colors.white);
    } catch (e) {
      debugPrint('Error updating user: $e');
      Get.snackbar('Error', 'Failed to update user: ${e.toString()}',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
  void fetchAllCoursesStream() {
    // isLoading.value = true; // Optional: Turn on loading

    courseRepository.getAllCoursesStream().listen((data) {
      // FIX IS HERE: Use assignAll instead of .value =
      coursesList.assignAll(data);

      // isLoading.value = false; // Turn off loading
      print("Data Arrived: ${coursesList.length}"); // Now you will see the count!
    });
  }

  void deleteCourse(id) {
    courseRepository.deleteCourseWithOutlines(id);
    Get.back();
    Get.snackbar('Success', 'Course is deleted',backgroundColor: secondaryColor,colorText: Colors.white);
    clearFields();
  }

  void filterCourses(String val) {
    if (val.isEmpty) {
      filteredCourses.assignAll(coursesList);
    } else {
      final filteredList = coursesList.where((course) {
        return course.courseName.toLowerCase().contains(val.toLowerCase());
      }).toList();
      filteredCourses.assignAll(filteredList);
      }
    }
  }

