import 'package:cloud_firestore/cloud_firestore.dart';

import 'course_progress_model.dart';

class CourseProgressRepo {
  late CollectionReference courseProgressRepo;

  CourseProgressRepo() {
    courseProgressRepo = FirebaseFirestore.instance.collection(
      "courseProgressModel",
    );
  }

  Future<void> addCourseProgressModel(CourseProgressModel courseProgressModel) async {
    var doc = courseProgressRepo.doc();
    courseProgressModel.id = doc.id;
    return doc.set(courseProgressModel.toMap());  }

  Future<CourseProgressModel?> getCourseProgressModelById(String courseProgressModelId) async {
    DocumentSnapshot snapshot =
    await courseProgressRepo.doc(courseProgressModelId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return CourseProgressModel.fromMap(data, snapshot.id);
    }
    return null;
  }
  Future<List<CourseProgressModel>> getAllCourseProgressModels() async {
    try {
      QuerySnapshot querySnapshot = await courseProgressRepo.get();
      List<CourseProgressModel> users =
      querySnapshot.docs.map((doc) {
        return CourseProgressModel.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();
      return users;
    } catch (e) {
      return [];
    }
  }

  Stream<CourseProgressModel?> getCourseProgressModelStreamById(String courseProgressModelId) {
    return courseProgressRepo.doc(courseProgressModelId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        // Correctly pass the document ID to fromMap
        return CourseProgressModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null; // Return null if the document does not exist
    });
  }
  Stream<List<CourseProgressModel>> loadCurrentCourseProgressModel(String userId) {
    // Use .where() on the database reference to filter on the server
    return courseProgressRepo
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return convertToCourseProgressModel(snapshot);
    });
  }


  Stream<List<CourseProgressModel>> getAllCourseProgressModelsStream() {
    return courseProgressRepo.snapshots().map((snapshot) {
      return convertToCourseProgressModel(snapshot);
    });
  }

  Future<void> deleteCourseProgressModel(String uid) async {
    await courseProgressRepo.doc(uid).delete();
  }

  Future<void> updateCourseProgressModel(CourseProgressModel courseProgressModel) {
    return courseProgressRepo.doc(courseProgressModel.id).set(courseProgressModel.toMap());
  }



  // utility function
  List<CourseProgressModel> convertToCourseProgressModel(QuerySnapshot snapshot) {
    List<CourseProgressModel> courseProgressModels = [];
    for (var snap in snapshot.docs) {
      courseProgressModels.add(CourseProgressModel.fromMap(snap.data() as Map<String, dynamic>,snap.id));
    }
    return courseProgressModels;
  }
}
