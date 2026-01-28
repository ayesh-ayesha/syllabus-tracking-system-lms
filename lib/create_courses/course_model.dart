
class Course{
  String id;
  String courseName;
  String courseFee;
  String courseDuration;
  String courseDescription;


  Course({
    required this.id,
    required this.courseName,
    required this.courseFee,
    required this.courseDuration,
    required this.courseDescription,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseName': courseName,
      'courseFee': courseFee,
      'courseDuration': courseDuration,
      'courseDescription': courseDescription,
    };
  }

  factory Course.fromMap(Map<String, dynamic> map, String documentId) {
      return Course(
        id: documentId,
        courseName: map['courseName']??'',
        courseFee: map['courseFee']??'',
        courseDuration: map['courseDuration']??'',
        courseDescription: map['courseDescription']??'',

      );

  }
}
