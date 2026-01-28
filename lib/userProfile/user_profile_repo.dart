import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:student_lms/userProfile/user_profile_model.dart';

class UserProfileRepository {
  late CollectionReference userProfileCollection;

  UserProfileRepository() {
    userProfileCollection = FirebaseFirestore.instance.collection(
      "userProfile",
    );
  }

  Future<void> addFieldToAllStudents() async {
    QuerySnapshot querySnapshot = await userProfileCollection.get();
    for(var doc in querySnapshot.docs){
      await doc.reference.update({
        'role': 'student',
        'isActive':true,
      });
      print("Updated user: ${doc.id}");
    }
    print("ALL DONE! You can now delete this button.");
  }

  Future<void> updateIsActiveUser(UserProfile userProfile) async {
    await userProfileCollection.doc(userProfile.id).update({
      'isActive': userProfile.isActive,
    });
  }


  Future<void> addUserProfile(UserProfile userProfile) async {
    var doc = userProfileCollection.doc(userProfile.id);
    return doc.set(userProfile.toMap());  }

  Stream<UserProfile?> getUserProfileStreamById(String? userProfileId) {
    // Check if the userProfileId is null or empty before making the Firestore call
    if (userProfileId == null || userProfileId.isEmpty) {
      // Return an empty stream or a stream with a single null value
      // to handle this gracefully without crashing
      return Stream.value(null);
    }

    // Proceed with the Firestore query only if the ID is valid
    return userProfileCollection.doc(userProfileId).snapshots().map((snapshot) {
      if (snapshot.exists) {
        return UserProfile.fromMap(snapshot.data() as Map<String, dynamic>, snapshot.id);
      }
      return null; // Return null if the document does not exist
    });
  }

    Future<void> deleteUserProfile(String uid) async {
    await userProfileCollection.doc(uid).delete();
  }




   Future<void> updateTokens(String uid, String token) async {
    await userProfileCollection.doc(uid).update({
      'fcmTokens': FieldValue.arrayUnion([token])
    });
  }


  Future<void> updateUserProfile(UserProfile userProfile) {
    return userProfileCollection.doc(userProfile.id).update(userProfile.toMap());
  }


  Future<bool> getUserIsActive(String uid) async {
    final doc = await userProfileCollection.doc(uid).get();

    return doc['isActive']; // "admin" or "user"
  }

  Stream<List<UserProfile>> getAllUsersStreams() {
    return userProfileCollection.snapshots().map((snapshot) {
      return convertToUser(snapshot);
    });
  }






  // utility function
  List<UserProfile> convertToUser(QuerySnapshot snapshot) {
    List<UserProfile> users = [];
    for (var snap in snapshot.docs) {
      users.add(UserProfile.fromMap(snap.data() as Map<String, dynamic>,snap.id));
    }
    return users;
  }


}
