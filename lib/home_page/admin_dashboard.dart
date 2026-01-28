import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'homePageVm.dart';
import 'package:student_lms/app_theme.dart';



class AdminDashboard extends GetView<HomePageVM> {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- HEADER ---
            const Text(
              "Admin Control Center",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: primaryColor // Matches Theme
              ),
            ),
            const SizedBox(height: 5),
            Text(
              "Manage your institute manually",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // --- SECTION 1: STATS (The Health Check) ---
             Row(
              children: [
                Expanded(
                    child: Obx(
                      () {
                        return StatCard(
                            title: "Total Students",
                            count: controller.totalStudents,
                            color: primaryColor, // Brand Blue
                            icon: Icons.people);
                      }
                    )),
                SizedBox(width: 15),
                Expanded(
                    child: Obx(
                       () {
                        return StatCard(
                            title: "Total Courses",
                            count: controller.totalCourses,
                            color: secondaryColor, // Brand Teal
                            icon: Icons.book);
                      }
                    )),
              ],
            ),

            const SizedBox(height: 30),

            // --- SECTION 2: QUICK ACTIONS ---
            const Text(
              "Quick Create",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor
              ),
            ),
            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(
                  child: BigActionButton(
                    title: "Add Student",
                    icon: Icons.person_add,
                    color: secondaryColor, // Action Color (Teal)
                    onTap: () => Get.toNamed('/create_student'),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: BigActionButton(
                    title: "Create Course",
                    icon: Icons.post_add,
                    color: secondaryColor, // Action Color (Teal)
                    onTap: () => Get.toNamed('/create_courses'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            // Single Full-Width Button for Enrollment
            InkWell(
              onTap: () => Get.toNamed('/enroll_students'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: primaryColor, // Main Structural Color (Blue)
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                        color: primaryColor.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4)
                    )
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.link, color: Colors.white, size: 28),
                    SizedBox(width: 15),
                    Text(
                        "Enroll Student to Course",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16
                        )
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // --- SECTION 3: VIEW LISTS ---
            const Text(
              "View Data",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor
              ),
            ),
            const SizedBox(height: 10),

            ManagementTile(
              title: "View All Students",
              icon: Icons.list_alt,
              onTap: () => Get.toNamed('/all_users'),
            ),
            ManagementTile(
              title: "View All Courses",
              icon: Icons.library_books,
              onTap: () => Get.toNamed('/all_courses'),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------
//       HELPER WIDGETS
// ------------------------------------------

class StatCard extends StatelessWidget {
  final String title;
  final String count;
  final Color color;
  final IconData icon;

  const StatCard({
    super.key,
    required this.title,
    required this.count,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 5,
              spreadRadius: 2
          )
        ],
        // The side bar uses the passed color
        border: Border(left: BorderSide(color: color, width: 5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                  count,
                  style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: color
                  )
              ),
              Icon(icon, color: color.withOpacity(0.5), size: 28),
            ],
          ),
          const SizedBox(height: 5),
          Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500
              )
          ),
        ],
      ),
    );
  }
}

class BigActionButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const BigActionButton({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 8,
                offset: const Offset(0, 4)
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 30),
            const SizedBox(height: 8),
            Text(
                title,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15
                )
            ),
          ],
        ),
      ),
    );
  }
}

class ManagementTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const ManagementTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.white,
          // Using Primary Color for icons to keep it clean
          child: Icon(icon, color: primaryColor, size: 22),
        ),
        title: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        onTap: onTap,
      ),
    );

  }
}