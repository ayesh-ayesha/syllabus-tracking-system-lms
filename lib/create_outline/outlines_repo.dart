import 'package:cloud_firestore/cloud_firestore.dart';

import '../create_courses/studentProgress.dart';
import '../my_courses/course_progress_model.dart';
import '../userProfile/user_profile_model.dart';
import 'outline_model.dart';


class OutlineRepository {
  late CollectionReference outlineModelCollection;

  OutlineRepository() {
    outlineModelCollection = FirebaseFirestore.instance.collection(
      "outlineModel",
    );
  }

  Future<void> addOutlineModelsBatch(List<OutlineModel> outlinesList) async {
    // 1. Create the "Cart"
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // 2. Loop through your list and add each one to the cart
    for (var outline in outlinesList) {
      // Create a new document reference (get a new ID)
      var doc = outlineModelCollection.doc();

      // Assign that new ID to your model
      outline.outlineId = doc.id;

      // Add the "set" operation to the batch
      batch.set(doc, outline.toMap());
    }

    // 3. Commit (Save everything at once)
    await batch.commit();
  }

  Future<OutlineModel?> getOutlineModelById(String outlineModelId) async {
    DocumentSnapshot snapshot =
    await outlineModelCollection.doc(outlineModelId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return OutlineModel.fromMap(data, snapshot.id);
    }
    return null;
  }
  Future<List<OutlineModel>> getAllOutlineModels() async {
    try {
      QuerySnapshot querySnapshot = await outlineModelCollection.get();
      List<OutlineModel> users =
      querySnapshot.docs.map((doc) {
        return OutlineModel.fromMap(
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

  Stream<OutlineModel?> getOutlineModelStreamById(String outlineModelId) {
    return outlineModelCollection.doc(outlineModelId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        // Correctly pass the document ID to fromMap
        return OutlineModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null; // Return null if the document does not exist
    });
  }

  Stream<List<OutlineModel>> getAllOutlineModelsStream() {
    return outlineModelCollection.snapshots().map((snapshot) {
      return convertToOutlineModel(snapshot);
    });
  }

  Future<void> deleteOutlineModel(String uid) async {
    await outlineModelCollection.doc(uid).delete();
  }

  Future<void> updateOutlineModelsBatch(List<OutlineModel> outlines) async {
    // 1. Create the Batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // 2. Add every outline in the list to the batch
    for (var outline in outlines) {
      DocumentReference docRef = outlineModelCollection.doc(outline.outlineId);

      // We use 'update' so it only modifies existing documents.
      // (If you want to create them if they don't exist, use batch.set(docRef, outline.toMap()))
      batch.update(docRef, outline.toMap());
    }

    // 3. Commit all updates at once
    await batch.commit();
  }

  Stream<List<OutlineModel>> getOutlineByCourse(String courseId) {
    return outlineModelCollection.where('courseId', isEqualTo: courseId).snapshots().map((snapshot) {
      return convertToOutlineModel(snapshot);
    });

    }

  Future<void> saveOutlinesBatch({
    required List<OutlineModel> toAdd,
    required List<OutlineModel> toUpdate,
    required List<String> toDeleteIds,
  }) async {
    // 1. Initialize the Batch
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // 2. Queue "Add" Operations
    for (var outline in toAdd) {
      // Generate a new document reference so we get an ID
      DocumentReference docRef = outlineModelCollection.doc();

      // Assign that generated ID to the model
      outline.outlineId = docRef.id;

      // Add to batch
      batch.set(docRef, outline.toMap());
    }

    // 3. Queue "Update" Operations
    for (var outline in toUpdate) {
      DocumentReference docRef = outlineModelCollection.doc(outline.outlineId);

      // Update the existing document
      batch.update(docRef, outline.toMap());
    }

    // 4. Queue "Delete" Operations
    for (var id in toDeleteIds) {
      DocumentReference docRef = outlineModelCollection.doc(id);

      // Delete the document
      batch.delete(docRef);
    }

    // 5. Commit (Execute all operations at once)
    await batch.commit();
  }
  Stream<List<StudentProgress>> getStudentsProgressByCourse(String courseId){
    final enrollmentCollection = FirebaseFirestore.instance.collection('enrollment');
    final courseProgressCollection = FirebaseFirestore.instance.collection('courseProgressModel');
    final usersCollection = FirebaseFirestore.instance.collection('userProfile');

    return enrollmentCollection
        .where('courseId', isEqualTo: courseId)
        .snapshots()
        .asyncMap((enrollmentSnapshot) async {

      List<StudentProgress> result = [];

      for (var enrollmentDoc in enrollmentSnapshot.docs) {
        final studentId = enrollmentDoc['studentId'];

        // Fetch course progress
        final progressQuery = await courseProgressCollection
            .where('courseId', isEqualTo: courseId)
            .where('userId', isEqualTo: studentId)
            .limit(1)
            .get();

        if (progressQuery.docs.isEmpty) continue;

        final progressDoc = progressQuery.docs.first;
        final courseProgress = CourseProgressModel.fromMap(
          progressDoc.data(),
          progressDoc.id,
        );

        // Fetch user profile
        final userDoc = await usersCollection.doc(studentId).get();
        if (!userDoc.exists) continue;

        final user = UserProfile.fromMap(
          userDoc.data() as Map<String, dynamic>,
          userDoc.id,
        );

        result.add(
          StudentProgress(
            user: user,
            progress: courseProgress,
          ),
        );
      }

      return result;
    });
  }



}


  // utility function
  List<OutlineModel> convertToOutlineModel(QuerySnapshot snapshot) {
    List<OutlineModel> outlineModels = [];
    for (var snap in snapshot.docs) {
      outlineModels.add(OutlineModel.fromMap(snap.data() as Map<String, dynamic>,snap.id));
    }
    return outlineModels;
  }
