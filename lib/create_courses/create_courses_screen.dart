import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/app_theme.dart'; // Ensure correct path
import 'course_VM.dart';
import 'course_model.dart';

class CreateCoursesScreen extends GetView<CourseVM> {
  const CreateCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Course? course = Get.arguments;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.clearFields();
      if (course != null && controller.courseNameController.text.isEmpty) {
        controller.courseNameController.text = course.courseName;
        controller.courseFeeController.text = course.courseFee;
        controller.courseDurationController.text = course.courseDuration ?? "";
        controller.courseDescriptionController.text = course.courseDescription ?? "";
      } else if (course == null && controller.courseNameController.text.isEmpty) {
        controller.clearFields();
      }
    });

    return Scaffold(
      backgroundColor: Colors.grey[100], // Light grey background for contrast
      // 1. REMOVED 'extendBodyBehindAppBar' so they don't overlap

      appBar: AppBar(
        // 2. FIXED: AppBar is now Primary Color (Brand Standard)
        // iconTheme:  IconThemeData(color: Colors.white),
        title: Text(
          course == null ? 'Create Course' : 'Edit Course',
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // --- 3. THE FLOATING HEADER (Secondary Color) ---
            Container(
              width: double.infinity,
              height: 180,
              // 4. ADDED MARGIN: This creates the "Gap" so it is not attached to AppBar
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryColor, // The "Action" color
                // 5. ROUNDED ALL CORNERS: Makes it look like a distinct block
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: secondaryColor.withOpacity(0.4),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                      course == null ? Icons.add_to_photos : Icons.edit_note,
                      size: 50,
                      color: Colors.white
                  ),
                  const SizedBox(height: 10),
                  Text(
                    course == null ? "Start a New Class" : "Update Details",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  Text(
                    "Fill the form below",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 14
                    ),
                  ),
                ],
              ),
            ),

            // --- 4. THE FORM ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Course Details",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 15),

                    _buildModernInput(
                      controller: controller.courseNameController,
                      label: "Course Name",
                      icon: Icons.school,
                    ),
                    const SizedBox(height: 15),

                    _buildModernInput(
                      controller: controller.courseFeeController,
                      label: "Course Fee",
                      icon: Icons.monetization_on,
                      isNumber: true,
                    ),
                    const SizedBox(height: 15),

                    _buildModernInput(
                      controller: controller.courseDurationController,
                      label: "Duration (e.g. 3 Months)",
                      icon: Icons.timer,
                    ),
                    const SizedBox(height: 15),

                    _buildModernInput(
                      controller: controller.courseDescriptionController,
                      label: "Description",
                      icon: Icons.description,
                      maxLines: 4,
                    ),

                    const SizedBox(height: 30),

                    // --- BUTTON (Primary Color to match AppBar) ---
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor, // Matches AppBar
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 2,
                        ),
                        onPressed: () {
                          if (course == null) {
                            controller.addCourse();
                          } else {
                            controller.updateCourse(course);
                          }
                        },
                        child: Text(
                          course == null ? "Create Now" : "Save Changes",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30), // Bottom padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isNumber = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      validator: (value) => (value == null || value.isEmpty) ? "Required" : null,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        prefixIcon: Icon(icon, color: secondaryColor.withValues(alpha: 0.7)), // Icon uses primary color too
        filled: true,
        fillColor: Colors.white, // White box on Grey background
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: secondaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}