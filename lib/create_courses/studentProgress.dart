import '../my_courses/course_progress_model.dart';
import '../userProfile/user_profile_model.dart';

class StudentProgress {
  final UserProfile user;

  final CourseProgressModel progress;

  StudentProgress({
    required this.user,
    required this.progress,
  });
}
