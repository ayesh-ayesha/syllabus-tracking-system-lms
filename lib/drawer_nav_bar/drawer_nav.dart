import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/app_theme.dart'; // Make sure this is imported
import 'package:student_lms/authentication/login/login_vm.dart';
import '../userProfile/UserProfile_vm.dart';

class DrawerNavBar extends GetView<UserProfileVM> {
  const DrawerNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // 1. ROUNDED CORNERS for a modern feel
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Obx(() {
        final user = controller.currentUser.value;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // --- 2. BEAUTIFUL GRADIENT HEADER ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              decoration: BoxDecoration(
                // gradient: LinearGradient(
                //   colors: [primaryColor, secondaryColor], // Brand Gradient
                //   begin: Alignment.topLeft,
                //   end: Alignment.bottomRight,
                // ),
                color: primaryColor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  // User Name
                  Text(
                    user.fullName.toUpperCase(),
                    style:  TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // User Email
                  Text(
                    user.email,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Role Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      controller.isCurrentUserAdmin ? "Admin Dashboard" : "Student Portal",
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  )
                ],
              ),
            ),

            // --- 3. MENU ITEMS (Scrollable) ---
            Expanded(
              child: Obx(
                 () {
                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    children: controller.isCurrentUserAdmin
                        ? _buildAdminMenu()
                        : controller.currentUser.value!.isActive?_buildStudentMenu():List.empty(growable: false),
                  );
                }
              ),
            ),

            // --- 4. LOGOUT BUTTON (Fixed at bottom) ---
            Padding(
              padding: const EdgeInsets.all(20),
              child: InkWell(
                onTap: () {
                  final LoginViewModel loginVM = Get.find();
                  loginVM.logout();
                },
                borderRadius: BorderRadius.circular(15),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, color: Colors.white),
                      const SizedBox(width: 10),
                      Text(
                        "Logout",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // --- HELPER: Admin Menu Items ---
  List<Widget> _buildAdminMenu() {
    return [
      _buildSectionTitle("User Management"),
      _buildDrawerItem(Icons.group, "All Users", () => Get.toNamed('/all_users')),
      _buildDrawerItem(Icons.person_add, "Create Student", () => Get.toNamed('/create_student')),
      _buildDrawerItem(Icons.how_to_reg, "Enroll Student", () => Get.toNamed('/enroll_students')),

      const Divider(indent: 20, endIndent: 20),

      _buildSectionTitle("Course Management"),
      _buildDrawerItem(Icons.library_books, "All Courses", () => Get.toNamed('/all_courses')),
      _buildDrawerItem(Icons.add_to_photos, "Create Course", () => Get.toNamed('/create_courses')),
      // Combined 'Create Outline' into 'All Courses' flow usually, but keeping it here as requested
      _buildDrawerItem(Icons.list_alt, "Create Outline", () => Get.toNamed('/create_outline')),
    ];
  }

  // --- HELPER: Student Menu Items ---
  List<Widget> _buildStudentMenu() {
    return [
      _buildSectionTitle("Learning"),
      _buildDrawerItem(Icons.menu_book, "My Courses", () => Get.toNamed('/my_courses')),
      _buildDrawerItem(Icons.bar_chart, "My Progress", () => Get.toNamed('/my_progress')),

      const Divider(indent: 20, endIndent: 20),

      _buildSectionTitle("Account"),
      _buildDrawerItem(Icons.person, "My Profile", () => Get.toNamed('/profile')),
    ];
  }

  // --- WIDGET: Reusable Drawer Item ---
  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return Padding(
      // 1. Add spacing so items don't touch each other
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        onTap: () {
          Get.back();
          onTap();
        },
        // 2. Round the corners of the click effect
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

        // 3. THE "HINT": Wrap the icon in a soft colored box
        leading: Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            color: secondaryColor.withValues(alpha: 0.1), // This gives the soft hint
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
              icon,
              color: secondaryColor, // Stronger color for the icon itself
              size: 20
          ),
        ),

        title: Text(
          title,
          style: TextStyle(
            color: Colors.grey[800], // Dark text for readability
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),

        // 4. (Optional) Tiny arrow on the right for balance
        trailing: Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey[300]),

        horizontalTitleGap: 15,
        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      ),
    );
  }
  // --- WIDGET: Section Title ---
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 15, 0, 10),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: primaryColor.withValues(alpha: 0.7),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}