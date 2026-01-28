import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/app_theme.dart';
// Ensure this import points to your actual file
import 'package:student_lms/create_outline/outline_course_details_screen.dart';
import '../my_courses/my_courses.dart';
import 'homePageVm.dart';

class StudentDashboard extends GetView<HomePageVM> {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Obx(() {
            // Safety check: If user is loading
            if (controller.userProfileVM.currentUser.value == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final user = controller.userProfileVM.currentUser.value!;
            // Helper to check if we have courses
            final hasCourses = controller.enrollmentVM.enrollmentsOfCurrentStudentList.isNotEmpty;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // ---------------------------------------------------------
                // 1. 👋 GREETING + NAME
                // ---------------------------------------------------------
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, ${user.fullName.split(' ')[0] ?? "Student"}",
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Let's learn something new today!",
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    // Profile Icon (Static visual)
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, size: 28, color: Colors.black87),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                // ---------------------------------------------------------
                // 2. 📊 PROGRESS / MOTIVATION (Status Card)
                // ---------------------------------------------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: user.isActive
                        ? const LinearGradient(colors: [primaryColor, secondaryColor])
                        : null,
                    color: user.isActive ? null : Colors.red[50],
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      if (user.isActive)
                        BoxShadow(
                          color: primaryColor.withValues(alpha:0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                    ],
                    border: user.isActive ? null : Border.all(color: Colors.red),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user.isActive ? "Keep it up!" : "Account Inactive",
                              style: TextStyle(
                                color: user.isActive ? Colors.white : Colors.red[800],
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              user.isActive
                                  ? "Glad to see you! You are doing great."
                                  : "Please contact your teacher to reactivate access.",
                              style: TextStyle(
                                color: user.isActive ? Colors.white.withValues(alpha:0.9) : Colors.red[800],
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (user.isActive)
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha:0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.trending_up, color: Colors.white),
                        )
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ---------------------------------------------------------
                // 3. 📚 MY COURSES (Short List)
                // ---------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "My Courses",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed('/my_courses'),
                      child: const Text(
                        'View All',
                        style: TextStyle(color: primaryColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                if (!hasCourses)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: const Text("You are not enrolled in any courses yet.", textAlign: TextAlign.center),
                  )
                else
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    // Logic: Cap at 2 items
                    itemCount: (controller.enrollmentVM.enrollmentsOfCurrentStudentList.length < 2)
                        ? controller.enrollmentVM.enrollmentsOfCurrentStudentList.length
                        : 2,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15.0,
                      mainAxisSpacing: 15.0,
                      childAspectRatio: 0.9,
                    ),
                    itemBuilder: (context, index) {
                      final enrollment = controller.enrollmentVM.enrollmentsOfCurrentStudentList[index];
                      final matchingCourses = controller.courseVM.coursesList
                          .where((element) => element.id == enrollment.courseId);

                      if (matchingCourses.isEmpty) return const SizedBox();
                      final courseData = matchingCourses.first;

                      // CLICKABLE CARD
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha:0.08),
                              spreadRadius: 2,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => Get.toNamed('/CourseDetails', arguments: courseData),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: secondaryColor.withValues(alpha:0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.book, color: secondaryColor, size: 28),
                                ),
                                const SizedBox(height: 12),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: Text(
                                    courseData.courseName,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  courseData.courseDuration,
                                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 30),

                // ---------------------------------------------------------
                // 4. ➡ CONTINUE LEARNING
                // ---------------------------------------------------------
                if (hasCourses && controller.activeCoursesDetails.isNotEmpty) ...[
                  const Text(
                    "Continue Learning",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor),
                  ),
                  const SizedBox(height: 15),
                  // Using your existing CourseTile
                  CourseTile(course: controller.activeCoursesDetails.first),
                  const SizedBox(height: 30),
                ],

                // ---------------------------------------------------------
                // END OF PAGE PADDING
                // ---------------------------------------------------------
                const SizedBox(height: 50),
              ],
            );
          }),
        ),
      ),
    );
  }
}