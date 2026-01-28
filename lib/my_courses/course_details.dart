import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/create_outline/outline_VM.dart';
import 'package:student_lms/create_outline/outline_course_details_screen.dart';
import 'package:student_lms/create_outline/outline_model.dart';
import '../app_theme.dart';
import '../create_courses/course_model.dart';
import 'package:student_lms/my_courses/outline_progress_vm.dart';


class CourseDetails extends GetView<OutlineVM> {
  const CourseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final Course course = Get.arguments as Course;
    final OutlineProgressVM progressVM = Get.find();
    final currentStudentId = progressVM.userProfileVM.currentUser.value?.id;

    // Load outlines
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadOutlinesForCourse(course.id);
    });

    return Scaffold(
      backgroundColor: backgroundColor, // From your theme
      appBar: AppBar(
        title: Text(course.courseName.capitalizeWords()),
        // AppBar styling is handled by your global theme (primaryColor background)
      ),
      body: Obx(() {
        if (controller.dbOutlines.isEmpty) {
          return _buildEmptyState();
        }

        // Sort outlines
        final sortedOutlines = List<OutlineModel>.from(controller.dbOutlines)
          ..sort((a, b) => a.order.compareTo(b.order));

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Optional: A nice header showing the count
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
              child: Text(
                "Course Content (${sortedOutlines.length} Chapters)",
                style: const TextStyle(
                  color: primaryColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // The List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: sortedOutlines.length,
                itemBuilder: (context, index) {
                  final outline = sortedOutlines[index];

                  return Obx(() {
                    final isCompleted = progressVM.outlineProgressList.any((p) =>
                    p.outlineId == outline.outlineId &&
                        p.userId == currentStudentId);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isCompleted
                              ? secondaryColor.withValues(alpha: 0.5)
                              : Colors.transparent,
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha:0.05),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CheckboxListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4
                        ),
                        activeColor: secondaryColor, // Your Teal Brand Color
                        checkboxShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),

                        // Title Styling
                        title: Text(
                          "${outline.order}. ${outline.outline.capitalizeFirst}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isCompleted
                                ? Colors.grey
                                : primaryColor, // Deep Blue
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),

                        // Bind Value
                        value: isCompleted,

                        // Interaction Logic
                        onChanged: (bool? val) {
                          if (currentStudentId == null) {
                            Get.snackbar("Error", "No student selected",backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
                            return;
                          }

                          if (val == true) {
                            progressVM.addOutlineProgress(userId: currentStudentId, courseId: course.id, outlineId: outline.outlineId);
                          } else {
                            final progressRecord = progressVM.outlineProgressList
                                .firstWhereOrNull((p) =>
                            p.outlineId == outline.outlineId &&
                                p.userId == currentStudentId);

                            if (progressRecord != null) {
                              progressVM.removeOutlineProgress(progressRecord.id);
                            }
                          }
                        },
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.edit_note, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          const Text(
            'No Content Yet',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'This course has no outlines available.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}