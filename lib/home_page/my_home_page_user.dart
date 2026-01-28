import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/home_page/admin_dashboard.dart';
import 'package:student_lms/home_page/homePageVm.dart';
import 'package:student_lms/home_page/student_dashboard.dart';
import 'package:student_lms/userProfile/UserProfile_vm.dart';
import '../drawer_nav_bar/drawer_nav.dart';

class MyHomePage extends GetView<HomePageVM> {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Ideally, find the controller once outside the build or Obx if possible,
    // but putting it inside Obx is also safe.
    final UserProfileVM userProfileVM = Get.find<UserProfileVM>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: const DrawerNavBar(),
      body: Obx(() {
        // Handle the loading state first!
        if (userProfileVM.currentUser.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return userProfileVM.isCurrentUserAdmin
            ? AdminDashboard()  // If true
            : StudentDashboard();
      }),
    );
  }
}