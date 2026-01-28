import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

// 1. IMPORT YOUR THEME FILE HERE
import 'package:student_lms/app_theme.dart';

// Assuming these exist in your project
import '../create_courses/course_model.dart';
import '../create_courses/studentProgress.dart';
import 'outline_VM.dart';

class OutlineCourseDetailsScreen extends GetView<OutlineVM> {
  const OutlineCourseDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic args = Get.arguments;
    late final Course course;

    if (args is Course) {
      course = args;
    } else if (args is Map && args['course'] is Course) {
      course = args['course'];
    } else {
      return const Scaffold(
          body: Center(child: Text("Error: Course arguments missing")));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.selectedCourse.value = course.id;
      controller.listenToStudentsProgress(course.id);
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Soft gray background
      appBar: AppBar(
        title: Text(
          "Course Overview",

        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Get.toNamed('/create_outline', arguments: {'course': course});
        },
        backgroundColor: primaryColor, // Using Theme Secondary Color
        elevation: 4,
        icon: const Icon(Icons.edit_note, color: Colors.white),
        label: const Text(
          "Manage Curriculum",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        final outlines = controller.dbOutlines;
        outlines.sort((a, b) => a.order.compareTo(b.order));

        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // --- HEADER SECTION ---
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withValues(alpha:0.08), // Subtle shadow using primary color
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.courseName.capitalizeWords(),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: primaryColor, // Primary Color
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Stats Row (Fee & Duration)
                    Row(
                      children: [
                        _buildInfoBadge(Icons.attach_money, course.courseFee),
                        const SizedBox(width: 12),
                        _buildInfoBadge(Icons.access_time_rounded, course.courseDuration),
                      ],
                    ),

                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: Divider(height: 1),
                    ),

                    const Text(
                      "About this Course",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: primaryColor), // Primary Color
                    ),
                    const SizedBox(height: 8),
                    Text(
                      toBeginningOfSentenceCase(course.courseDescription) ?? "",
                      style: TextStyle(
                          color: Colors.grey[700],
                          height: 1.6,
                          fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),

            // --- CURRICULUM HEADER ---
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Row(
                  children: [
                    const Icon(Icons.library_books, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    const Text(
                      "Curriculum",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // --- CURRICULUM LIST ---
            if (outlines.isEmpty)
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(40),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Icon(Icons.folder_open, size: 48, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("No topics added yet",
                          style: TextStyle(color: Colors.grey[400])),
                    ],
                  ),
                ),
              )
            else
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final item = outlines[index];
                    return _buildOutlineItem(
                      index + 1,
                      toBeginningOfSentenceCase(item.outline) ?? "",
                      item.outlineId,
                    );
                  },
                  childCount: outlines.length,
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // --- STUDENT PROGRESS HEADER & LIST ---
            SliverToBoxAdapter(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: CircularProgressIndicator(),
                      ));
                }

                if (controller.studentsProgress.isEmpty) {
                  return const SizedBox();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      initiallyExpanded: true,
                      tilePadding: EdgeInsets.zero,
                      childrenPadding: EdgeInsets.zero,
                      title: Row(
                        children: [
                          const Icon(Icons.people_alt, size: 20, color: primaryColor),
                          const SizedBox(width: 8),
                          const Text(
                            "Student Performance",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                        ],
                      ),
                      children: controller.studentsProgress.map((item) {
                        return _buildStudentProgressItem(item);
                      }).toList(),
                    ),
                  ),
                );
              }),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        );
      }),
    );
  }

  // --- WIDGET HELPER: INFO BADGE (Fee/Duration) ---
  // Uses Secondary Color for Highlights
  Widget _buildInfoBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: secondaryColor.withValues(alpha:0.1), // Light Teal Background
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: secondaryColor), // Teal Icon
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: secondaryColor, // Teal Text
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: OUTLINE ITEM ---
  Widget _buildOutlineItem(int number, String title, String id) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha:0.15)),
      ),
      child: Row(
        children: [
          // Number Badge - Primary Color
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: secondaryColor.withValues(alpha:0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              "$number",
              style: const TextStyle(
                  color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          const SizedBox(width: 16),
          // Title
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          // Delete Action
          IconButton(
            icon: Icon(Icons.delete_outline, size: 22, color: secondaryColor),
            onPressed: () {
              Get.defaultDialog(
                title: "Delete Topic",
                titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor),
                middleText: "Are you sure? This action cannot be undone.",
                textCancel: "Cancel",
                textConfirm: "Delete",
                confirmTextColor: Colors.white,
                buttonColor: primaryColor,
                cancelTextColor: primaryColor,
                onConfirm: () {
                  controller.deleteOutline(id);
                  Get.back();
                },
              );
            },
          )
        ],
      ),
    );
  }

  // --- WIDGET HELPER: STUDENT PROGRESS ITEM ---
  // MATCHES THE THEME OF THE CURRICULUM ITEM
  Widget _buildStudentProgressItem(StudentProgress data) {
    final double progressPercent = data.progress.progressPercentage.clamp(0.0, 100.0);
    final bool isCompleted = progressPercent >= 100;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.05),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withValues(alpha:0.15)),
      ),
      child: Row(
        children: [
          // Avatar - Uses Secondary Color
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: secondaryColor.withValues(alpha:0.1),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              data.user.fullName.isNotEmpty ? data.user.fullName[0].toUpperCase() : "?",
              style: const TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Name and Bar
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      data.user.fullName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      "${progressPercent.toInt()}%",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        // Green if done, otherwise Teal (Secondary)
                        color: isCompleted ? Colors.green : secondaryColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progressPercent / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                        isCompleted ? Colors.green : secondaryColor
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension StringExtensions on String {
  String capitalizeWords() {
    if (isEmpty) return "";
    return split(' ').map((word) {
      if (word.isEmpty) return "";
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }
}