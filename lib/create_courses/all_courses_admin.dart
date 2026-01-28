import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/app_theme.dart'; // Your theme
import 'package:student_lms/create_outline/outline_course_details_screen.dart';
import 'course_VM.dart';
import 'course_model.dart';

class AllCoursesAdmin extends GetView<CourseVM> {
  const AllCoursesAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.filterCourses("");
    });
    return Scaffold(
      backgroundColor: Colors.grey[50], // Very light/clean background
      appBar: AppBar(
        title: const Text('Course Management'),
        centerTitle: true,
      ),

      // --- FAB (Styled) ---
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed('/create_courses'),
        backgroundColor: primaryColor,
        elevation: 6,
        icon: const Icon(Icons.add_circle_outline, color: Colors.white),
        label: const Text("Create Course", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),

      body: Column(
        children: [
          // --- 1. SEARCH BAR (Clean & Floating) ---
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: TextField(
                onChanged: (val) {
                  controller.filterCourses(val);
                },
                decoration: InputDecoration(
                  hintText: "Search courses...",
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: const Icon(Icons.search, color: primaryColor),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ),

          // --- 2. THE LIST ---
          Expanded(
            child: Obx(() {
              if (controller.filteredCourses.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 80), // Bottom padding for FAB
                itemCount: controller.filteredCourses.length,
                separatorBuilder: (context, index) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  final course = controller.filteredCourses[index];
                  return _buildModernCard(course);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- WIDGET: The Modern Course Card ---
  Widget _buildModernCard(Course course) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100), // Subtle border
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.toNamed('/course_details', arguments: course),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // TOP ROW: Icon + Name + Fee Badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Stylish Icon Container
                    // 1. Stylish Icon Container (Replaced)
              Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient( // A subtle gradient looks very premium
                  colors: [secondaryColor.withValues(alpha: 0.3), secondaryColor.withValues(alpha: 0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                // color: secondaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(
                Icons.menu_book_rounded, // A clean "Open Book" icon
                color: secondaryColor,
                size: 26,
              ),
            ),
                    const SizedBox(width: 15),

                    // 2. Name & Duration
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            course.courseName.capitalizeWords(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: textColor,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                              const SizedBox(width: 4),
                              Text(
                                course.courseDuration,
                                style: TextStyle(color: Colors.grey[500], fontSize: 13),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // 3. Price Badge (Green Pill)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: secondaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: secondaryColor.withValues(alpha: 0.2))
                      ),
                      child: Text(
                        "\$${course.courseFee}",
                        style: const TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),
                const Divider(height: 1, color: Colors.grey),
                const SizedBox(height: 10),

                // BOTTOM ROW: Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Edit Button
                    TextButton.icon(
                      onPressed: () => Get.toNamed('/create_courses', arguments: course),
                      icon: const Icon(Icons.edit, size: 18, color: secondaryColor),
                      label: const Text("Edit", style: TextStyle(color: secondaryColor)),
                      style: TextButton.styleFrom(
                        backgroundColor: secondaryColor.withValues(alpha: 0.05),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Delete Button
                    TextButton.icon(
                      onPressed: () => _showDeleteDialog(course.id),
                      icon: const Icon(Icons.delete_outline, size: 18, color: primaryColor),
                      label: const Text("Remove", style: TextStyle(color: textColor)),
                      style: TextButton.styleFrom(
                        backgroundColor: primaryColor.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET: Empty State (Better Illustration) ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha:0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.class_outlined, size: 60, color: primaryColor.withValues(alpha:0.5)),
          ),
          const SizedBox(height: 20),
          Text(
            "No Courses Yet",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blueGrey[800]),
          ),
          const SizedBox(height: 8),
          Text(
            "Start by adding a new course to the list.",
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  // --- LOGIC: Delete Dialog ---
  void _showDeleteDialog(String docId) {
    Get.defaultDialog(
      title: "Delete Course?",
      titlePadding: const EdgeInsets.only(top: 20),
      contentPadding: const EdgeInsets.all(20),
      middleText: "This action cannot be undone.",
      confirm: ElevatedButton(
        onPressed: () {
          controller.deleteCourse(docId);
        },
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
        child: const Text("Delete", style: TextStyle(color: Colors.white)),
      ),
      cancel: TextButton(
        onPressed: () => Get.back(),
        child: const Text("Cancel",style: TextStyle(color: textColor),),
      ),
    );
  }
}