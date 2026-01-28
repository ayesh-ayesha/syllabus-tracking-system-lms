import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/create_courses/course_VM.dart';
import 'outline_VM.dart';

class CreateOutlineScreen extends GetView<OutlineVM> {
  const CreateOutlineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We don't need to manually find the controller if we extend GetView<OutlineVM>
    // But if you prefer your way, ensure OutlineVM is put() before this screen.

    return Scaffold(
      appBar: AppBar(title: const Text("Create Course Outline")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: CourseInfoWidget(),
            ),
          ),
          Expanded(child: OutlinePointsWidget()),
        ],
      ),
    );
  }
}

// 1. DROPDOWN WIDGET
class CourseInfoWidget extends GetView<CourseVM> {
  const CourseInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final OutlineVM outlineController = Get.find();

    return Obx(() {
      // Create menu items
      final menuEntries = controller.coursesList
          .map((course) => DropdownMenuEntry<String>(
        value: course.id,
        label: course.courseName,
      ))
          .toList();

      // Calculate initial selection safely
      // We look at what the OutlineVM currently has selected
      final currentSelection = outlineController.selectedCourse.value;

      // If list is empty, return empty
      if (menuEntries.isEmpty) return const SizedBox();

      return DropdownMenu<String>(
        initialSelection: currentSelection.isNotEmpty ? currentSelection : null,
        label: const Text("Select Course"),
        onSelected: (String? value) {
          if (value != null) {
            // Just update the variable.
            // The 'ever' listener in VM will handle loading outlines!
            outlineController.selectedCourse.value = value;
          }
        },
        dropdownMenuEntries: menuEntries,
      );
    });
  }
}

// 2. OUTLINE LIST WIDGET
class OutlinePointsWidget extends GetView<OutlineVM> {
  const OutlinePointsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // REMOVED: All the "addPostFrameCallback" logic.
    // The VM handles data loading now.

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: controller.formKey,
        child: Column(
          children: [
            // List View
            Expanded(
              child: Obx(() {
                // If loading, you could show a spinner here
                if(controller.outlineControllers.isEmpty) {
                  return const Center(child: Text("No outlines or Loading..."));
                }

                return ListView.builder(
                  itemCount: controller.outlineControllers.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              // Bind directly to the controller list
                              controller: controller.outlineControllers[index],
                              decoration: InputDecoration(
                                labelText: 'Outline ${index + 1}',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Required';
                                }
                                return null;
                              },
                            ),
                          ),
                          // Only show delete button if more than 1 item
                          if (controller.outlineControllers.length > 1)
                            IconButton(
                              onPressed: () => controller.removeField(index),
                              icon: const Icon(Icons.close),
                            ),
                        ],
                      ),
                    );
                  },
                );
              }),
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: controller.addField,
                    child: const Text('Add Input'),
                  ),
                  ElevatedButton(
                    // Calls the smart submit function
                    onPressed: controller.submitOutlines,
                    child: const Text('Save / Update'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}