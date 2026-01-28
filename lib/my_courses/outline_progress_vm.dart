import 'package:get/get.dart';
import '../create_courses/course_VM.dart';
import '../enrollments/enrollment_VM.dart';
import '../my_courses/course_progress_model.dart';
import '../my_courses/course_progress_repo.dart';
import '../my_courses/outline_progress_model.dart';
import '../my_courses/outline_progress_repo.dart';
import '../create_outline/outline_model.dart';
import '../create_outline/outlines_repo.dart';
import '../userProfile/UserProfile_vm.dart';

class OutlineProgressVM extends GetxController {
  // ---- DEPENDENCIES ----
  final OutlineProgressRepo outlineProgressRepo = Get.find();
  final CourseProgressRepo courseProgressRepo = Get.find();
  final OutlineRepository outlineRepository = Get.find();

  final UserProfileVM userProfileVM = Get.find();
  final CourseVM courseVM = Get.find();
  final EnrollmentVM enrollmentVM = Get.find();

  // ---- STATE (ONLY WHAT THIS VM OWNS) ----
  final outlineProgressList = <OutlineProgressModel>[].obs;
  final courseProgressList = <CourseProgressModel>[].obs;
  final allEnrolledOutlines = <OutlineModel>[].obs;

  // ---- COMPUTED GETTERS (NO COPIES) ----
  String? get currentUserId => userProfileVM.currentUser.value?.id;




  // ---- LIFECYCLE ----
  @override
  void onInit() {
    super.onInit();

    // React when user changes
    ever(userProfileVM.currentUser, (_) {
      reloadAll();
    });

    // React when enrollments load/change
    ever(enrollmentVM.enrollmentsList, (_) {
      loadEnrolledOutlines();
    });

    reloadAll();
  }

  void reloadAll() {
    if (currentUserId == null) return;
    readCurrentOutlineProgress();
    readCurrentCourseProgress();
    loadEnrolledOutlines();
  }

  // --------------------------------------------------
  // LOAD OUTLINES FOR ENROLLED COURSES
  // --------------------------------------------------
  Future<void> loadEnrolledOutlines() async {
    final userId = currentUserId;
    if (userId == null) return;

    final enrollments = enrollmentVM.enrollmentsList
        .where((e) => e.studentId == userId)
        .toList();

    if (enrollments.isEmpty) {
      allEnrolledOutlines.clear();
      return;
    }

    final List<OutlineModel> collected = [];

    for (final e in enrollments) {
      final outlines =
      await outlineRepository.getOutlineByCourse(e.courseId).first;
      collected.addAll(outlines);
    }

    allEnrolledOutlines.assignAll(collected);
  }

  // --------------------------------------------------
  // ADD OUTLINE PROGRESS
  // --------------------------------------------------
  Future<void> addOutlineProgress({
    required String userId,
    required String courseId,
    required String outlineId,
  }) async {
    // 1. Add the specific outline as completed to the DB
    await outlineProgressRepo.addOutlineProgressModel(
      OutlineProgressModel(
        id: '',
        userId: userId,
        courseId: courseId,
        outlineId: outlineId,
        isCompleted: true,
        completedAt: DateTime.now(),
      ),
    );

    // 2. Immediately update the Course Progress with +1logic
    await _updateCourseProgressMath(userId, courseId,);
  }

  // --------------------------------------------------
  // REMOVE OUTLINE PROGRESS
  // --------------------------------------------------
  Future<void> removeOutlineProgress(String outlineProgressId) async {
    final progress = outlineProgressList
        .firstWhereOrNull((p) => p.id == outlineProgressId);

    if (progress == null) return;

    // 1. Remove from DB
    await outlineProgressRepo.deleteOutlineProgressModel(outlineProgressId);

    // 2. Immediately update the Course Progress with -1 logic
    await _updateCourseProgressMath(progress.userId, progress.courseId, );
  }
  // --------------------------------------------------
  // COURSE PROGRESS CALCULATION (SINGLE SOURCE OF TRUTH)
  // --------------------------------------------------
  Future<void> _updateCourseProgressMath(
      String userId,
      String courseId,
      ) async {
    // 1. Total outlines for this course
    final totalOutlines = allEnrolledOutlines
        .where((o) => o.courseId == courseId)
        .length;

    if (totalOutlines == 0) return; // ⛔ wait until loaded

    // 2. Completed outlines from DB (single truth)
    final completedCount = outlineProgressList
        .where((p) =>
    p.courseId == courseId &&
        p.userId == userId &&
        p.isCompleted)
        .length;

    final percentage = (completedCount / totalOutlines) * 100;
    final isCompleted = completedCount == totalOutlines;

    final existingModel = courseProgressList.firstWhereOrNull(
          (p) => p.courseId == courseId && p.userId == userId,
    );

    final updatedModel = CourseProgressModel(
      id: existingModel?.id ?? '',
      userId: userId,
      courseId: courseId,
      totalOutlinesCount: totalOutlines,
      completedOutlinesCount: completedCount,
      progressPercentage: percentage,
      isCompleted: isCompleted,
      startedAt: existingModel?.startedAt ?? DateTime.now(),
      completedAt: isCompleted ? DateTime.now() : null,
    );

    if (existingModel == null) {
      await courseProgressRepo.addCourseProgressModel(updatedModel);
    } else {
      await courseProgressRepo.updateCourseProgressModel(updatedModel);
    }
  }

  // --------------------------------------------------
  // STREAM READERS
  // --------------------------------------------------
  void readCurrentOutlineProgress() {
    outlineProgressRepo
        .loadCurrentOutlineProgressModel(currentUserId!)
        .listen(outlineProgressList.assignAll);
  }

  void readCurrentCourseProgress() {
    courseProgressRepo
        .loadCurrentCourseProgressModel(currentUserId!)
        .listen(courseProgressList.assignAll);
  }
}
