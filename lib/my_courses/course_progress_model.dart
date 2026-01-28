class CourseProgressModel {
  String id;
  String userId;
  String courseId;
  int completedOutlinesCount;
  int totalOutlinesCount;
  bool isCompleted;
  double progressPercentage;
  DateTime? startedAt; // Tracks when the course was started
  DateTime? completedAt; // Tracks when the course was finished

  CourseProgressModel({
    required this.id,
    required this.userId,
    required this.courseId,
    this.completedOutlinesCount = 0,
    required this.totalOutlinesCount,
    this.isCompleted = false,
    this.progressPercentage = 0.0,
    this.startedAt,
    this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'courseId': courseId,
      'completedOutlinesCount': completedOutlinesCount,
      'totalOutlinesCount': totalOutlinesCount,
      'isCompleted': isCompleted,
      'progressPercentage': progressPercentage,
      // Convert DateTime to a string for storage. Null is handled automatically.
      'startedAt': startedAt?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory CourseProgressModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CourseProgressModel(
      id: documentId,
      userId: map['userId'],
      courseId: map['courseId'],
      completedOutlinesCount: map['completedOutlinesCount'] ?? 0,
      totalOutlinesCount: map['totalOutlinesCount'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      progressPercentage: (map['progressPercentage'] ?? 0).toDouble(),
      // Safely parse the string to a DateTime or return null if not present
      startedAt: map['startedAt'] != null ? DateTime.parse(map['startedAt']) : null,
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
    );
  }
}