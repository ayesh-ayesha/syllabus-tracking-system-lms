import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/create_courses/course_model.dart';
import 'package:student_lms/create_outline/outline_course_details_screen.dart';
import 'package:student_lms/my_courses/outline_progress_vm.dart';
import '../app_theme.dart';

class MyCourses extends GetView<OutlineProgressVM> {
  const MyCourses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Using the constant from your theme file
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('My Courses'),
        // AppBar style is already handled by your global theme (primaryColor)
      ),
      body: Obx(
         () {
          final currentStudentId =
              controller.userProfileVM.currentUser.value?.id;

          if (currentStudentId == null || currentStudentId.isEmpty) {
            return _buildEmptyState(
              icon: Icons.account_circle,
              title: 'No Profile Selected',
              message: 'Please select a user profile to view courses.',
            );
          }

          final enrollments = controller.enrollmentVM.enrollmentsList
              .where((e) => e.studentId == currentStudentId)
              .toList();

          if (enrollments.isEmpty) {
            return _buildEmptyState(
              icon: Icons.school,
              title: 'No Courses Yet',
              message: 'You are not enrolled in any courses.',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: enrollments.length,
            itemBuilder: (context, index) {
              final enrollment = enrollments[index];
              final course = controller.courseVM.coursesList.firstWhereOrNull(
                    (c) => c.id == enrollment.courseId,
              );

              if (course == null) return const SizedBox();

              return CourseTile(course: course);
            },
          );
        },
      ),
    );
  }

  // Helper for Empty States using your Palette
  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: backgroundColor, // Your Light Gray
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Icon(
                icon,
                size: 48,
                color: secondaryColor, // Your Teal
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor, // Your Deep Blue
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: textColor, // Your Body Text Color
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class CourseTile extends GetView<OutlineProgressVM> {
  final Course course;

  const CourseTile({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),

        /// ✅ CLICK / NAVIGATION IS HERE
        onTap: () {
          Get.toNamed('/CourseDetails', arguments: course);
        },

        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: secondaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.menu_book_rounded,
                        color: secondaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        course.courseName.capitalizeWords(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: primaryColor,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 16,
                      color: secondaryColor,
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// 🔥 THIS Obx IS THE MAGIC
                Obx(() {
                  final progressModel =
                  controller.courseProgressList.firstWhereOrNull(
                        (p) => p.courseId == course.id,
                  );

                  final percent =
                      progressModel?.progressPercentage ?? 0.0;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        percent >= 100
                            ? "Completed 🏆"
                            : "${percent.toStringAsFixed(0)}% Complete",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: percent >= 100
                              ? secondaryColor
                              : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: percent / 100,
                        minHeight: 6,
                        backgroundColor: Colors.grey.shade200,
                        color: secondaryColor,
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
