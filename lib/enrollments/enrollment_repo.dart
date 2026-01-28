
import 'package:cloud_firestore/cloud_firestore.dart';

import 'enrollment_model.dart';

class EnrollmentRepository {
  late CollectionReference enrollmentCollection;

  EnrollmentRepository() {
    enrollmentCollection = FirebaseFirestore.instance.collection(
      "enrollment",
    );
  }

  Future<void> addEnrollment(Enrollment enrollment) async {
    var doc = enrollmentCollection.doc();
    enrollment.enrollmentId = doc.id;
    return doc.set(enrollment.toMap());  }

  Future<Enrollment?> getEnrollmentById(String enrollmentId) async {
    DocumentSnapshot snapshot =
    await enrollmentCollection.doc(enrollmentId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return Enrollment.fromMap(data, snapshot.id);
    }
    return null;
  }

  Future<List<Enrollment>> getAllEnrollments() async {
    try {
      QuerySnapshot querySnapshot = await enrollmentCollection.get();
      List<Enrollment> users =
      querySnapshot.docs.map((doc) {
        return Enrollment.fromMap(
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

  Stream<Enrollment?> getEnrollmentStreamById(String enrollmentId) {
    return enrollmentCollection.doc(enrollmentId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        // Correctly pass the document ID to fromMap
        return Enrollment.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null; // Return null if the document does not exist
    });
  }

  Stream<List<Enrollment>> getAllEnrollmentsStream() {
    return enrollmentCollection.snapshots().map((snapshot) {
      return convertToEnrollment(snapshot);
    });
  }
  Stream<List<Enrollment>> loadCurrentStudentCourses(String? studentId) {
    return enrollmentCollection.where('studentId', isEqualTo: studentId).snapshots().map((snapshot) {
      return convertToEnrollment(snapshot);
    });
  }

// You need these imports

  Future<void> deleteEnrollment(String enrollmentId) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final WriteBatch batch = firestore.batch();

    try {
      // STEP 1: Get the Enrollment Data first
      // We need this to know the 'studentId' and 'courseId'
      final enrollmentDoc = await enrollmentCollection.doc(enrollmentId).get();

      if (!enrollmentDoc.exists) {
        print("Enrollment not found!");
        return;
      }

      // Extract IDs (Make sure your keys match your DB exactly)
      final data = enrollmentDoc.data() as Map<String, dynamic>;
      final String studentId = data['studentId'];
      final String courseId = data['courseId'];

      // STEP 2: Add "Delete Enrollment" to the batch
      batch.delete(enrollmentCollection.doc(enrollmentId));

      // STEP 3: Find and Delete Course Progress
      // (Query the OTHER collection for this student + course)
      final courseProgressSnapshot = await firestore
          .collection('courseProgressModel') // ⚠️ CHECK YOUR COLLECTION NAME
          .where('userId', isEqualTo: studentId)
          .where('courseId', isEqualTo: courseId)
          .get();

      for (var doc in courseProgressSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // STEP 4: Find and Delete Outline Progress
      // (Query the OTHER collection for this student + course)
      final outlineProgressSnapshot = await firestore
          .collection('outlineProgressModel') // ⚠️ CHECK YOUR COLLECTION NAME
          .where('userId', isEqualTo: studentId)
          .where('courseId', isEqualTo: courseId)
          .get();

      for (var doc in outlineProgressSnapshot.docs) {
        batch.delete(doc.reference);
      }

      // STEP 5: Commit (Send all deletions to DB at once)
      await batch.commit();
      print("Successfully deleted enrollment and all progress!");

    } catch (e) {
      print("Error deleting enrollment batch: $e");
      rethrow;
    }
  }
  
  Future<void> updateEnrollment(Enrollment enrollment) {
    return enrollmentCollection.doc(enrollment.enrollmentId).set(enrollment.toMap());
  }

  
  
  // utility function
  List<Enrollment> convertToEnrollment(QuerySnapshot snapshot) {
    List<Enrollment> enrollments = [];
    for (var snap in snapshot.docs) {
      enrollments.add(Enrollment.fromMap(snap.data() as Map<String, dynamic>,snap.id));
    }
    return enrollments;
  }
}
