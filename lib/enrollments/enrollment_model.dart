
class Enrollment{
  String enrollmentId;
  String courseId;
  String studentId;
  String enrollmentDate;

  Enrollment({
    required this.enrollmentId,
    required this.courseId,
    required this.studentId,
    required this.enrollmentDate,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': enrollmentId,
      'courseId': courseId,
      'studentId': studentId,
      'enrollmentDate': enrollmentDate,
    };
  }

  factory Enrollment.fromMap(Map<String, dynamic> map, String documentId) {
      return Enrollment(
        enrollmentId: documentId,
        courseId: map['courseId'],
        studentId: map['studentId'],
        enrollmentDate: map['enrollmentDate'],

      );

  }
}
