import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/create_outline/outline_course_details_screen.dart';
import 'package:student_lms/enrollments/enrollment_VM.dart';
import 'package:student_lms/userProfile/user_profile_model.dart';
import '../app_theme.dart';

class UserDetailsScreen extends GetView<EnrollmentVM> {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final UserProfile user = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.userProfileVM.isActive.value = user.isActive;
    });


    return Scaffold(
      backgroundColor: Colors.grey[50], // Light background for contrast
      appBar: AppBar(
        title: const Text("Student Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Obx(() {
          // --- LOGIC (Kept exactly as we fixed it) ---
          final myEnrollments = controller.enrollmentsList
              .where((e) => e.studentId == user.id)
              .toList();

          final myCourseIds = myEnrollments.map((e) => e.courseId).toList();

          final myCourses = controller.courses
              .where((course) => myCourseIds.contains(course.id))
              .toList();

          return SingleChildScrollView(
            child: Column(
              children: [
                // --- 1. HEADER SECTION (Profile Card) ---
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withValues(alpha:0.5), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white,
                          child: Text(
                            user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : "U",
                            style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: primaryColor),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      // Name & Role
                      Text(
                        user.fullName,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha:0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.role.toUpperCase(),
                          style: const TextStyle(fontSize: 12, color: Colors.white, letterSpacing: 1),
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// ACTIVE / INACTIVE TOGGLE
                      Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.userProfileVM.isActive.value? "ACTIVE" : "INACTIVE",
                            style: TextStyle(
                              color: controller.userProfileVM.isActive.value ? backgroundColor : Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Switch(
                                value: controller.userProfileVM.isActive.value,
                                activeThumbColor: backgroundColor,
                                inactiveThumbColor: primaryColor,
                                  onChanged: (value) {
                                    controller.userProfileVM.toggleUserStatus(user, value);
                                  }
                              ),
                        ],
                      )),

                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- 2. PERSONAL INFO GRID ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Personal Details",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 15),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(color: Colors.grey.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),
                        child: Column(
                          children: [
                            _buildModernInfoRow(Icons.badge_outlined, "Student ID", user.studentId.toString(), secondaryColor),
                            const Divider(height: 25),
                            _buildModernInfoRow(Icons.email_outlined, "Email", user.email, secondaryColor),
                            const Divider(height: 25),
                            _buildModernInfoRow(Icons.phone_outlined, "Phone", user.phoneNumber.toString(), secondaryColor),
                            const Divider(height: 25),
                            _buildModernInfoRow(user.gender == 'Male' ? Icons.male_outlined : Icons.female_outlined, "Gender", user.gender.toString(), secondaryColor),
                            const Divider(height: 25),
                            _buildModernInfoRow(Icons.date_range_outlined, "Date Of Birth", user.dateOfBirth.toString(), secondaryColor),
                            const Divider(height: 25),
                            _buildModernInfoRow(Icons.calendar_today_outlined, "Joined",
                                user.enrollmentDate.toString().split(' ')[0], // Show only date part
                                secondaryColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                // --- 3. ENROLLED COURSES SECTION ---
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Enrolled Courses",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: secondaryColor.withValues(alpha:0.1), shape: BoxShape.circle),
                        child: Text(
                          "${myCourses.length}",
                          style: const TextStyle(color: secondaryColor, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                if (myCourses.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(Icons.school_outlined, size: 50, color: Colors.grey[300]),
                        const SizedBox(height: 10),
                        Text("No courses enrolled yet", style: TextStyle(color: Colors.grey[500])),
                      ],
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: myCourses.map((course) {
                        final specificEnrollment = myEnrollments.firstWhere((e) => e.courseId == course.id);

                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withValues(alpha:0.08), blurRadius: 10, offset: const Offset(0, 4)),
                            ],
                            border: Border.all(color: Colors.grey.shade100),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(15),
                            // Course Icon Box
                            leading: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: secondaryColor.withValues(alpha:0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.menu_book_rounded, color: secondaryColor),
                            ),
                            title: Text(
                              course.courseName.capitalizeWords(),
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                                    const SizedBox(width: 4),
                                    Text(course.courseDuration, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                                    const SizedBox(width: 15),
                                    Icon(Icons.monetization_on, size: 14, color: Colors.green[600]),
                                    const SizedBox(width: 4),
                                    Text("\$${course.courseFee}", style: TextStyle(fontSize: 12, color: Colors.green[600], fontWeight: FontWeight.bold)),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    "Enrolled: ${specificEnrollment.enrollmentDate.toString().split(' ')[0]}",
                                    style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                                  ),
                                ),
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete, color: secondaryColor, size: 20),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Delete Enrollment",
                                  titleStyle: const TextStyle(fontWeight: FontWeight.bold),
                                  middleText: "Are you sure you want to delete this student's enrollment of this course? This cannot be undone.",

                                  // Customizing the Cancel Button
                                  textCancel: "Cancel",
                                  cancelTextColor: Colors.black,

                                  // Customizing the Confirm Button
                                  textConfirm: "Delete",
                                  confirmTextColor: Colors.white,
                                  buttonColor: primaryColor, // Sets the background color of the 'Delete' button

                                  // Action to perform on confirmation
                                  onConfirm: () {
                                    controller.deleteEnrollment(specificEnrollment.enrollmentId);
                                    Get.back(); // Important: Closes the dialog after deleting
                                  },
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                const SizedBox(height: 30), // Bottom spacing
              ],
            ),
          );
        }),
      ),
    );
  }

  // --- HELPER: Modern Row with Icon ---
  Widget _buildModernInfoRow(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha:0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        const SizedBox(width: 15),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w500),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
      ],
    );
  }
}