import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/app_theme.dart';
import 'package:student_lms/create_courses/course_model.dart';
import 'package:student_lms/create_outline/outline_model.dart';
import 'package:student_lms/create_outline/outlines_repo.dart';

import '../create_courses/studentProgress.dart';

class OutlineVM extends GetxController {
  final OutlineRepository outlineRepository = Get.find();

  // 1. FOR EDITING: The Text Controllers
  var outlineControllers = <TextEditingController>[].obs;
  var outlineIds = <String?>[].obs;

  // 2. FOR VIEWING: The clean data list (Add this!)
  var dbOutlines = <OutlineModel>[].obs;

  var selectedCourse = ''.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // inside OutlineVM class...

  @override
  void onInit() {
    super.onInit();

    // --- FIX 1: Handle arguments safely ---
    // We check: Is it a Map? Is it a Course object? Or is it null?

    dynamic args = Get.arguments;
    String? initialCourseId;

    if (args is Map<String, dynamic>) {
      // If it came as a Map {'course': ...}
      final Course? c = args['course'];
      initialCourseId = c?.id;
    } else if (args is Course) {
      // If it came directly as a Course object
      initialCourseId = args.id;
    }
    // Do this in your GetX Controller or explicitly before passing to the list

    // --- Setup Listener ---
    ever(selectedCourse, (String courseId) {
      if (courseId.isNotEmpty) loadOutlinesForCourse(courseId);
    });

    // --- Trigger Load ---
    if (initialCourseId != null) {
      selectedCourse.value = initialCourseId;
    }
  }
  // --- LOAD DATA ---
// Inside OutlineVM

  Future<void> loadOutlinesForCourse(String courseId) async {
    try {
      // 1. CLEAR OLD DATA (So the UI shows "Loading..." temporarily)
      outlineControllers.clear();
      outlineIds.clear();

      // 2. CONNECT THE STREAM (Keeps 'dbOutlines' always up to date for deletions)
      dbOutlines.bindStream(outlineRepository.getOutlineByCourse(courseId));

      // 3. FETCH DATA ONCE FOR EDITING (The Critical Fix)
      // We use '.first' to wait for the data to arrive so we can create controllers.
      final outlines = await outlineRepository.getOutlineByCourse(courseId).first;

      // Sort them so they appear in order (1, 2, 3...)
      outlines.sort((a, b) => a.order.compareTo(b.order));

      // 4. FILL THE TEXT FIELDS
      if (outlines.isNotEmpty) {
        for (var outline in outlines) {
          outlineControllers.add(TextEditingController(text: outline.outline));
          outlineIds.add(outline.outlineId);
        }
      } else {
        // If it's a new course, add one empty field
        addField();
      }

      // 5. REFRESH UI (Not strictly needed with Obx, but safe)
      outlineControllers.refresh();

    } catch (e) {
      print("Error loading outlines: $e");
      // If error, add one field so the screen isn't blank
      addField();
    }
  }  // --- ACTIONS ---
  void addField() {
    outlineControllers.add(TextEditingController());
    outlineIds.add(null);
  }

  void removeField(int index) {
    outlineControllers[index].dispose();
    outlineControllers.removeAt(index);
    outlineIds.removeAt(index);
  }

  // --- SAVE ---
  Future<void> submitOutlines() async {
    if (!formKey.currentState!.validate()) return;

    try {
      // 1. Prepare the lists (The "Shopping Cart")
      List<OutlineModel> outlinesToAdd = [];
      List<OutlineModel> outlinesToUpdate = [];
      List<String> outlinesToDelete = [];

      // 2. Loop through UI Controllers to fill "Add" and "Update" lists
      for (int i = 0; i < outlineControllers.length; i++) {
        String text = outlineControllers[i].text.trim();
        String? id = outlineIds[i];

        // Create the model
        OutlineModel model = OutlineModel(
          outlineId: id ?? '', // Empty for now if new, actual ID if existing
          courseId: selectedCourse.value,
          outline: text,
          order: i + 1, // Save the current order index
        );

        if (id == null) {
          // No ID means it is NEW
          outlinesToAdd.add(model);
        } else {
          // Has ID means it is an UPDATE
          // Has ID means it is an UPDATE
          outlinesToUpdate.add(model);
        }
      }

      // 3. Loop through DB Data to find "Deletes"
      // If an ID exists in the Database but is NOT in your current UI list, it was deleted.
      for (var original in dbOutlines) {
        if (!outlineIds.contains(original.outlineId)) {
          outlinesToDelete.add(original.outlineId);
        }
      }

      // 4. ONE CALL to save everything (Add, Update, Delete)
      await outlineRepository.saveOutlinesBatch(
        toAdd: outlinesToAdd,
        toUpdate: outlinesToUpdate,
        toDeleteIds: outlinesToDelete,
      );

      // 5. Success Logic
      Get.snackbar('Success', 'Outlines saved successfully!' ,colorText: Colors.white,backgroundColor: secondaryColor,);

      // Optional: Force a refresh of controllers to ensure they now have the correct IDs
      // (Wait a moment for the Stream to update dbOutlines first)
      await Future.delayed(Duration(milliseconds: 200));
      syncControllersWithDb();

    } catch (e) {
      print("Error saving batch: $e");
      Get.snackbar('Error', 'Something went wrong',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
    }
  }

  // Inside OutlineVM ...

  void syncControllersWithDb() {
    // 1. Clear the current UI lists
    // We use .clear() so we don't duplicate items every time we sync
    outlineControllers.clear();
    outlineIds.clear();

    // 2. Check if we have data from the database
    if (dbOutlines.isNotEmpty) {
      // 3. Loop through the DB data and recreate the text fields
      for (var outline in dbOutlines) {
        // Create a controller with the text pre-filled
        outlineControllers.add(TextEditingController(text: outline.outline));

        // Store the ID so we know this is an "Update", not an "Add"
        outlineIds.add(outline.outlineId);
      }
    } else {
      // 4. If DB is empty, show one empty field so the user can start typing
      addField();
    }
  }
  void deleteOutline(String id){
    outlineRepository.deleteOutlineModel(id);
  }

  final RxList<StudentProgress> studentsProgress = <StudentProgress>[].obs;
  final RxBool isLoading = false.obs;

  StreamSubscription<List<StudentProgress>>? _subscription;

  void listenToStudentsProgress(String courseId) {
    isLoading.value = true;

    _subscription?.cancel();

    _subscription = outlineRepository
        .getStudentsProgressByCourse(courseId)
        .listen((data) {
      studentsProgress.assignAll(data);
      isLoading.value = false;
    });
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}

