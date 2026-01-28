import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'enrollment_VM.dart';
import 'package:student_lms/app_theme.dart';

class EnrollStudentsScreen extends GetView<EnrollmentVM> {
  const EnrollStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enroll Students")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // --- HEADER ---
              const Text(
                "New Enrollment",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: primaryColor),
              ),
              const SizedBox(height: 5),
              Text(
                "Link a student to a course below.",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 30),

              // --- STEP 1: SELECT STUDENT ---
              _buildSectionHeader(Icons.person, "Step 1: Select Student"),
              const SizedBox(height: 15),

              Obx(() {
                if (controller.users.isEmpty) {
                  return const Text("No students available",
                      style: TextStyle(color: Colors.red));
                }

                return DropdownButtonFormField<String>(
                  isExpanded: true, // <--- CRITICAL FIX 1: Prevents Overflow
                  decoration: _inputDecoration("Search Student Name"),
                  hint: const Text("Choose a Student"),
                  items: controller.users.map((user) {
                    return DropdownMenuItem<String>(
                      value: user.id,
                      child: Text(
                        user.fullName,
                        overflow: TextOverflow.ellipsis, // <--- CRITICAL FIX 2: Handles long names
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.studentId.value = newValue;
                    }
                  },
                );
              }),

              // --- STUDENT CONFIRMATION CARD ---
              Obx(() {
                if (controller.studentId.value.isEmpty) {
                  return const SizedBox.shrink();
                }

                final selectedUser = controller.users.firstWhere(
                      (u) => u.id == controller.studentId.value,
                  orElse: () => controller.users.first,
                );

                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.blue.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: secondaryColor),
                      const SizedBox(width: 10),
                      Expanded( // <--- Fix: Allow text to wrap if screen is small
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedUser.fullName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              selectedUser.email,
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),

              const SizedBox(height: 30),

              // --- STEP 2: SELECT COURSE ---
              _buildSectionHeader(Icons.book, "Step 2: Select Course"),
              const SizedBox(height: 15),

              Obx(() {
                if (controller.courses.isEmpty) {
                  return const Text("No courses available",
                      style: TextStyle(color: Colors.red));
                }

                return DropdownButtonFormField<String>(
                  isExpanded: true, // <--- CRITICAL FIX 1
                  decoration: _inputDecoration("Select Course"),
                  hint: const Text("Choose a Course"),
                  items: controller.courses.map((course) {
                    return DropdownMenuItem<String>(
                      value: course.id,
                      child: Text(
                        course.courseName,
                        overflow: TextOverflow.ellipsis, // <--- CRITICAL FIX 2
                        maxLines: 1,
                      ),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    if (newValue != null) {
                      controller.courseId.value = newValue;
                    }
                  },
                );
              }),

              // --- COURSE CONFIRMATION CARD ---
              Obx(() {
                if (controller.courseId.value.isEmpty) {
                  return const SizedBox.shrink();
                }

                final selectedCourse = controller.courses.firstWhere(
                      (c) => c.id == controller.courseId.value,
                  orElse: () => controller.courses.first,
                );

                return Container(
                  margin: const EdgeInsets.only(top: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: secondaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: secondaryColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline,
                          color: secondaryColor),
                      const SizedBox(width: 10),
                      Expanded( // <--- Fix: Allow text to wrap
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              selectedCourse.courseName,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text("Fee: ${selectedCourse.courseFee}",
                                style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              }),

              const SizedBox(height: 50),

              // --- ENROLL BUTTON ---
              Obx(() {
                bool isReady = controller.studentId.value.isNotEmpty &&
                    controller.courseId.value.isNotEmpty;

                return SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isReady ? primaryColor : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: isReady ? () => controller.addEnrollment() : null,
                    child: const Text("Confirm Enrollment",
                        style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // --- HELPER WIDGETS ---
  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: primaryColor, size: 24),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
      ],
    );
  }
}