import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_lms/my_courses/outline_progress_model.dart';

class OutlineProgressRepo {
  late CollectionReference userProgressRepo;

  OutlineProgressRepo() {
    userProgressRepo = FirebaseFirestore.instance.collection(
      "outlineProgressModel",
    );
  }

  Future<void> addOutlineProgressModel(OutlineProgressModel outlineProgressModel) async {
    var doc = userProgressRepo.doc();
    outlineProgressModel.id = doc.id;
    return doc.set(outlineProgressModel.toMap());  }



  Future<OutlineProgressModel?> getOutlineProgressModelById(String outlineProgressModelId) async {
    DocumentSnapshot snapshot =
    await userProgressRepo.doc(outlineProgressModelId).get();

    if (snapshot.exists) {
      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      return OutlineProgressModel.fromMap(data, snapshot.id);
    }
    return null;
  }
  Future<List<OutlineProgressModel>> getAllOutlineProgressModels() async {
    try {
      QuerySnapshot querySnapshot = await userProgressRepo.get();
      List<OutlineProgressModel> users =
      querySnapshot.docs.map((doc) {
        return OutlineProgressModel.fromMap(
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

  Stream<OutlineProgressModel?> getOutlineProgressModelStreamById(String outlineProgressModelId) {
    return userProgressRepo.doc(outlineProgressModelId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        // Correctly pass the document ID to fromMap
        return OutlineProgressModel.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null; // Return null if the document does not exist
    });
  }
  Stream<List<OutlineProgressModel>> loadCurrentOutlineProgressModel(String userId) {
    // Use .where() on the database reference to filter on the server
    return userProgressRepo
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
      return convertToOutlineProgressModel(snapshot);
    });
  }


  Stream<List<OutlineProgressModel>> getAllOutlineProgressModelsStream() {
    return userProgressRepo.snapshots().map((snapshot) {
      return convertToOutlineProgressModel(snapshot);
    });
  }

  Future<void> deleteOutlineProgressModel(String uid) async {
    await userProgressRepo.doc(uid).delete();
  }
  
  Future<void> updateOutlineProgressModel(OutlineProgressModel outlineProgressModel) {
    return userProgressRepo.doc(outlineProgressModel.id).set(outlineProgressModel.toMap());
  }
  
  
  
  // utility function
  List<OutlineProgressModel> convertToOutlineProgressModel(QuerySnapshot snapshot) {
    List<OutlineProgressModel> outlineProgressModels = [];
    for (var snap in snapshot.docs) {
      outlineProgressModels.add(OutlineProgressModel.fromMap(snap.data() as Map<String, dynamic>,snap.id));
    }
    return outlineProgressModels;
  }
}
