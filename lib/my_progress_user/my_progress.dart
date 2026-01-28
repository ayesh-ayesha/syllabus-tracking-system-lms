import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/app_theme.dart';
import 'package:student_lms/create_outline/outline_course_details_screen.dart';
import 'package:student_lms/my_progress_user/my_progress_vm.dart';
import 'package:intl/intl.dart';

class MyProgress extends GetView<MyProgressVM> {
  const MyProgress({super.key});

  @override
  Widget build(BuildContext context) {
    // 1. Wrap in DefaultTabController for the tabs to work
    return DefaultTabController(
      length: 2, // We have 2 tabs: In Progress & Completed
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text('My Learning', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          centerTitle: true,
        ),
        body: Obx(() {
          // --- LOGIC: Filter the lists here (or use the controller getters) ---
          final completedList = controller.courseProgress;

          final inProgressList = controller.outlineProgressVM.courseProgressList
              .where((c) => c.completedAt == null).toList();

          return Column(
            children: [
              // --- SECTION 1: Top Stats ---
              Container(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 25),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatCard("Active", "${inProgressList.length}", Icons.hourglass_top),
                    Container(height: 40, width: 1, color: Colors.white24), // Vertical Divider
                    _buildStatCard("Done", "${completedList.length}", Icons.check_circle),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              // --- SECTION 2: Tab Bar ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0,2))]
                  ),
                  child: TabBar(
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        color: Theme.of(context).primaryColor.withValues(alpha:0.1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    tabs: const [
                      Tab(text: "In Progress"),
                      Tab(text: "Completed"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // --- SECTION 3: The Lists (TabBarView) ---
              Expanded(
                child: TabBarView(
                  children: [
                    // View 1: In Progress
                    _buildCourseList(inProgressList, isCompletedTab: false),

                    // View 2: Completed
                    _buildCourseList(completedList, isCompletedTab: true),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  // --- Reusable List Builder ---
  Widget _buildCourseList(List<dynamic> list, {required bool isCompletedTab}) {
    if (list.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isCompletedTab ? Icons.done_all : Icons.class_outlined, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text("No courses here yet", style: TextStyle(color: Colors.grey[400])),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final progressItem = list[index];

        // Find the course details
        final course = controller.courseVM.coursesList.firstWhere(
                (element) => element.id == progressItem.courseId,
            // orElse: () => null
        );

        // if (course == null) return const SizedBox();

        // --- DUMMY DATA FOR DESIGN ---
        // (Replace these with real variables from your model later)
        double progressPercent =progressItem.progressPercentage/100; // Dummy 65%
        String duration = course.courseDuration;    // Dummy Duration

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha:0.05), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Course Name
                Text(
                  course.courseName.capitalizeWords(),
                  style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 8),

                // Info Row: Duration & Start Date
                Row(
                  children: [
                    Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(duration, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                    const SizedBox(width: 15),
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
                    const SizedBox(width: 4),
                    Text(
                      progressItem.startedAt == null ? "N/A" : DateFormat('MMM d').format(progressItem.startedAt!),
                      style: TextStyle(color: Colors.grey[600], fontSize: 13),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // --- CONDITIONAL UI: Progress Bar OR Completed Date ---
                if (!isCompletedTab) ...[
                  // IN PROGRESS UI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Progress", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                      Text("${(progressPercent * 100).toInt()}%", style: const TextStyle(color: secondaryColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progressPercent,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      color: secondaryColor,
                    ),
                  ),
                ] else ...[
                  // COMPLETED UI
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha:0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, size: 16, color: Colors.green),
                        const SizedBox(width: 8),
                        Text(
                          "Completed on ${progressItem.completedAt == null ? '-' : DateFormat('yMMMd').format(progressItem.completedAt!)}",
                          style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                  )
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard(String label, String count, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(count, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(icon, color: Colors.white70, size: 14),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
          ],
        ),
      ],
    );
  }
}