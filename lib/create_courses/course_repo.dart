import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_lms/create_courses/studentProgress.dart';
import 'package:student_lms/my_courses/course_progress_model.dart';

import '../userProfile/user_profile_model.dart';
import 'course_model.dart';

class CourseRepository {
  late CollectionReference courseCollection;

  CourseRepository() {
    courseCollection = FirebaseFirestore.instance.collection(
      "course",
    );
  }

  Future<void> addCourse(Course course) async {
    var doc = courseCollection.doc();
    course.id = doc.id;
    return doc.set(course.toMap());  }

  Future<Course?> getCourseById(String courseId) async {
    DocumentSnapshot snapshot =
    await courseCollection.doc(courseId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Course.fromMap(data, snapshot.id);
    }
    return null;
  }
  Future<List<Course>> getAllCourses() async {
    try {
      QuerySnapshot querySnapshot = await courseCollection.get();
      List<Course> users =
      querySnapshot.docs.map((doc) {
        return Course.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
      return users;
    } catch (e) {
      print('Error fetching users: $e');
      return [];
    }
  }



  Stream<List<Course>> getAllCoursesStream() {
    return courseCollection.snapshots().map((snapshot) {
      return convertToCourse(snapshot);
    });
  }

  Future<void> deleteCourseWithOutlines(String courseId) async {
    // 1. START THE BATCH
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // ---------------------------------------------
    // A. QUEUE COURSE DELETION
    // ---------------------------------------------
    batch.delete(courseCollection.doc(courseId));

    // ---------------------------------------------
    // B. FIND AND QUEUE OUTLINES
    // ---------------------------------------------
    var outlinesSnapshot = await FirebaseFirestore.instance
        .collection('outlineModel')
        .where('courseId', isEqualTo: courseId)
        .get();

    for (var doc in outlinesSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // ---------------------------------------------
    // C. FIND AND QUEUE ENROLLMENTS (New Part)
    // ---------------------------------------------
    // IMPORTANT: Make sure 'enrollments' matches your actual collection name!
    var enrollmentsSnapshot = await FirebaseFirestore.instance
        .collection('enrollment')
        .where('courseId', isEqualTo: courseId)
        .get();

    for (var doc in enrollmentsSnapshot.docs) {
      batch.delete(doc.reference);
    }

    // ---------------------------------------------
    // 4. COMMIT EVERYTHING
    // ---------------------------------------------
    await batch.commit();
  }
  Future<void> updateCourse(Course course) {
    return courseCollection.doc(course.id).set(course.toMap());
  }
  
  
  // utility function
  List<Course> convertToCourse(QuerySnapshot snapshot) {
    List<Course> courses = [];
    for (var snap in snapshot.docs) {
      courses.add(Course.fromMap(snap.data() as Map<String, dynamic>,snap.id));
    }
    return courses;
  }
}
