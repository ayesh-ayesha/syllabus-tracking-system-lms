
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';

class AuthRepository {
  Future<UserCredential> login(String email, String password) async {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp(String email, String password) async {
    FirebaseApp? secondaryApp;
    try{
      secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase
            .app()
            .options,
      );
      UserCredential userCredential = await FirebaseAuth.instanceFor(
          app: secondaryApp)
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;

    }catch(e){
      print("Error creating student: $e");
      rethrow;
    }finally{
      if (secondaryApp != null) {
        await secondaryApp.delete();
      }
    }
  }

  bool isEmailVerified() {
    User? user = getLoggedInUser();
    if (user == null) return false;
    return user.emailVerified;
  }

  User? getLoggedInUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> resetPassword(String email) {
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword(String newPassword) {
    User? user = getLoggedInUser();
    if (user == null) return Future.value();
    return user.updatePassword(newPassword);
  }

  Future<void> changeName(String name) {
    User? user = getLoggedInUser();
    if (user == null) return Future.value();
    return user.updateDisplayName(name);
  }

  Future<void> deleteCurrentUser() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.delete();
        print("User account deleted successfully!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('Requires recent login. Reauthenticate the user before deleting.');
        // Handle reauthentication
      } else {
        print("Error deleting account: ${e.message}");
      }
    }
  }


  Future<void> updateCurrentUserEmail(String newEmail) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // CORRECT: Use the Firebase SDK method, not a recursive call
        await user.verifyBeforeUpdateEmail(newEmail);
        debugPrint("Email updated successfully!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        debugPrint('Requires recent login. Reauthenticate the user.');
        // Handle reauthentication, e.g., prompt user for credentials
      } else {
        debugPrint("Error updating email: ${e.message}");
      }
    }
  }
  Future<void> updateCurrentUserPassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        print("Password updated successfully!");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        print('Requires recent login. Reauthenticate the user.');
        // Handle reauthentication
      } else {
        print("Error updating password: ${e.message}");
      }
    }
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}
