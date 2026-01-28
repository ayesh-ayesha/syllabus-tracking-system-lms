import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:student_lms/app_theme.dart';
import 'package:student_lms/userProfile/UserProfile_vm.dart';

class StudentProfileScreen extends GetView<UserProfileVM> {
  const StudentProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FB),
      appBar: AppBar(
        title: const Text("My Profile"),
      ),
      body: Obx(() {
        final user = controller.currentUser.value;

        if (user == null) {
          return const Center(child: CircularProgressIndicator());
        }

        String formatDate(dynamic date) {
          try {
            return DateFormat('dd MMM yyyy').format(DateTime.parse(date.toString()));
          } catch (_) {
            return "-";
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              // ===== PROFILE HEADER =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: width * 0.12,
                      backgroundColor: secondaryColor.withValues(alpha: 0.1),
                      child: Icon(Icons.person, size: width * 0.12, color: secondaryColor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      user.fullName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 10),
                    Chip(
                      label: Text(user.role.toUpperCase()),
                      backgroundColor: primaryColor,
                      labelStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ===== DETAILS CARD =====
              _infoCard(
                title: "Personal Information",
                children: [
                  _infoRow(Icons.badge, "Student ID", user.studentId ?? "-"),
                  _infoRow(Icons.email, "Email", user.email ?? "-"),
                  _infoRow(Icons.phone, "Phone Number", user.phoneNumber ?? "-"),
                  _infoRow(Icons.wc, "Gender", user.gender ?? "-"),
                  _infoRow(Icons.cake, "Date of Birth", formatDate(user.dateOfBirth)),
                ],
              ),

              const SizedBox(height: 16),

              _infoCard(
                title: "Account Information",
                children: [
                  _infoRow(Icons.calendar_today, "Enrollment Date", formatDate(user.enrollmentDate)),
                  _infoRow(Icons.verified_user, "Active Status", user.isActive ? "Active" : "Inactive"),
                ],
              ),

              const SizedBox(height: 30),

              // ===== LOGOUT BUTTON =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    controller.loginVm.logout();
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Log Out"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ===== REUSABLE WIDGETS =====

  Widget _infoCard({required String title, required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: secondaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
