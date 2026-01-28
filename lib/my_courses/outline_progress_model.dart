class OutlineProgressModel {
  String id; // A unique ID for this specific progress record
  String userId;
  String courseId;
  String outlineId;
  bool isCompleted;
  DateTime? completedAt;

  OutlineProgressModel({
    required this.id,
    required this.userId,
    required this.courseId,
    required this.outlineId,
    required this.isCompleted,
    required this.completedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'courseId': courseId,
      'outlineId': outlineId,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  factory OutlineProgressModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OutlineProgressModel(
      id: documentId,
      userId: map['userId'],
      courseId: map['courseId'],
      outlineId: map['outlineId'],
      isCompleted: map['isCompleted'] ?? false,
      completedAt: map['completedAt'] != null ? DateTime.parse(map['completedAt']) : null,
    );
  }
}