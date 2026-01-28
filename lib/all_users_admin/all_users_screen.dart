import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/app_theme.dart';
import 'package:student_lms/userProfile/UserProfile_vm.dart';
import 'package:student_lms/userProfile/user_profile_model.dart';
import 'package:intl/intl.dart' show toBeginningOfSentenceCase;

class AllUsersScreen extends GetView<UserProfileVM> {
  const AllUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.filterUsers("");
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('People Directory',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          // --- 1. SEARCH HEADER (Unchanged) ---
          Container(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
            decoration: const BoxDecoration(
              color: primaryColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: "Search users...",
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: const Icon(Icons.search, color: secondaryColor),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (val) {
                    controller.filterUsers(val);
                  },
                ),
                const SizedBox(height: 15),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.people_alt_outlined,
                        color: Colors.white70, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      "${controller.usersProfiles.length} Total Users",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ],
                )),
              ],
            ),
          ),

          // --- 2. USER LIST ---
          Expanded(
            child: Obx(() {
              if (controller.filteredUsersProfiles.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_off_outlined,
                          size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      Text("No users found",
                          style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                itemCount: controller.filteredUsersProfiles.length,
                separatorBuilder: (c, i) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final user = controller.filteredUsersProfiles[index];
                  return _buildUserCard(user);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(UserProfile user) {
    final isStudent = user.role.toLowerCase().contains("student");
    final roleColor = isStudent ? secondaryColor : Colors.orange;

    // --- NEW: Determine Status Color ---
    // Assuming your UserProfile model has an 'isActive' boolean. 
    // If it doesn't, you need to add it to your model!
    final bool isActive = user.isActive ;
    final statusColor = isActive ? Colors.green : Colors.red;
    final statusText = isActive ? "Active" : "Inactive";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha:0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // Navigate to details screen where the toggle will live
          onTap: () => Get.toNamed('/user_details_screen', arguments: user),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // 1. Avatar
                Container(
                  height: 55,
                  width: 55,
                  decoration: BoxDecoration(
                    color: secondaryColor.withValues(alpha:0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      user.fullName.isNotEmpty
                          ? user.fullName[0].toUpperCase()
                          : "#",
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: secondaryColor),
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // 2. Name, Role & Status
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        toBeginningOfSentenceCase(user.fullName) ?? "",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          // Role Badge
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 8, vertical: 2),
                          //   decoration: BoxDecoration(
                          //     color: roleColor.withValues(alpha:0.1),
                          //     borderRadius: BorderRadius.circular(6),
                          //   ),
                          //   child: Text(
                          //     user.role.toUpperCase(),
                          //     style: TextStyle(
                          //       fontSize: 10,
                          //       fontWeight: FontWeight.bold,
                          //       color: roleColor,
                          //     ),
                          //   ),
                          // ),

                          // const SizedBox(width: 8),

                          // --- NEW: Status Badge ---
                      Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  border: Border.all(color: statusColor, width: 1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isActive ? Icons.check_circle : Icons.cancel,
                                      size: 10,
                                      color: statusColor,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      statusText,
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 3. Edit Action
                IconButton(
                  icon: const Icon(Icons.edit_outlined,
                      color: secondaryColor, size: 20),
                  onPressed: () {
                    Get.toNamed('/create_student', arguments: user);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}