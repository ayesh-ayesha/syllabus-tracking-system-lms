import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/authentication/login/login_vm.dart';
import 'package:student_lms/userProfile/user_profile_model.dart';
import 'package:student_lms/userProfile/user_profile_repo.dart';
import '../app_theme.dart';
import '../authentication/auth_repo.dart';

class UserProfileVM extends GetxController {
  UserProfileRepository userProfileRepository = Get.find();
  AuthRepository authRepository = Get.find();
  LoginViewModel loginVm = Get.find();

  var usersProfiles = <UserProfile>[].obs;
  Rxn<UserProfile> currentUser = Rxn<UserProfile>();
  final filteredUsersProfiles = <UserProfile>[].obs;

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var gender = 'Male'.obs;
  // Existing code...

  /// Student active/inactive state
  RxBool isActive = true.obs;



  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController studentIdController = TextEditingController();
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentEmailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();
  TextEditingController enrollmentDateController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool get isCurrentUserAdmin => currentUser.value?.isAdmin ?? false;


  // String get currentUserId => authRepository.getLoggedInUser()?.uid ?? '';


  @override
  void onInit() {
    super.onInit();
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        // User just logged in (or app started) -> Fetch Data!
        fetchUserByIdStream();
      } else {
        // User just logged out -> Clear Data
        currentUser.value = null;
      }
    });
    fetchAllUsersStream();
    ever(usersProfiles, (_) {
      filteredUsersProfiles.assignAll(usersProfiles);
    });
  }


  @override
  void onClose() {
    studentIdController.dispose();
    studentNameController.dispose();
    studentEmailController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    enrollmentDateController.dispose();
    passwordController.dispose();
    super.onClose();
  }


  void clearFields() {
    studentNameController.clear();
    studentEmailController.clear();
    phoneNumberController.clear();
    dateOfBirthController.clear();
    enrollmentDateController.clear();
    passwordController.clear();
    gender.value = 'Male';
  }


  Future<void> addUserProfile() async {
    // Auto-generate studentId before checking duplicates

    if (usersProfiles.any((element) =>
    element.studentId == studentIdController.text)) {
      Get.snackbar('Error', 'Student already exists with the same ID',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
      isLoading.value = false;
      return;
    }
    if (usersProfiles.any((element) =>
    element.email == studentEmailController.text)) {
      Get.snackbar('Error', 'Student with this email already exists',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
      isLoading.value = false;
      return;
    }

    try {
      UserCredential credential = await authRepository.signUp(
          studentEmailController.text, passwordController.text);
      String uid = credential.user!.uid;

      UserProfile userProfile = UserProfile(
        id: uid,
        studentId: studentIdController.text,
        // Auto-generated ID
        fullName: studentNameController.text,
        email: studentEmailController.text,
        phoneNumber: phoneNumberController.text,
        gender: gender.value,
        dateOfBirth: dateOfBirthController.text,
        enrollmentDate: DateTime.parse(enrollmentDateController.text),
        role: 'student',
        password: passwordController.text,);
      await userProfileRepository.addUserProfile(userProfile);
      Get.snackbar('Success', 'Student is created',backgroundColor: secondaryColor,colorText: Colors.white);
      isLoading.value = false;
      clearFields();
    } catch (e) {
      debugPrint('Error adding user: $e');
      Get.snackbar('Error', 'Failed to add user: ${e.toString()}',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
    }
  }
  // Inside UserProfileVM class


  Future<void> updateProfile(UserProfile user) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      UserProfile updatedProfile = UserProfile(
        id: user.id,
        studentId: studentIdController.text,
        fullName: studentNameController.text,
        email: studentEmailController.text,
        phoneNumber: phoneNumberController.text,
        gender: gender.value,
        dateOfBirth: dateOfBirthController.text,
        enrollmentDate: DateTime.parse(enrollmentDateController.text),
        password: passwordController.text,);
      await userProfileRepository.updateUserProfile(updatedProfile);
      Get.back();
      clearFields();
      Get.snackbar('Success', 'Student is updated',backgroundColor: secondaryColor,colorText: Colors.white);
    } catch (e) {
      debugPrint('Error updating user: $e');
      Get.snackbar('Error', 'Failed to update user: ${e.toString()}',backgroundColor: errorColor.withValues(alpha: 0.5),colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void fetchUserByIdStream() async {
    final uid = authRepository.getLoggedInUser()?.uid;
    if (uid == null ) {
      currentUser.value = null;
      return;
    }
    // if(currentUser.value!.isActive==false){
    //   print("your is account is not active please concern with admin");
    //   return;
    // }
    try {
      isLoading.value = true;
      errorMessage.value = '';

      currentUser.bindStream(
        userProfileRepository.getUserProfileStreamById(uid),);
    } catch (e) {
      print('Error fetching user: $e');
      errorMessage.value = 'Failed to fetch user: ${e.toString()}';
      currentUser.value = null;
    } finally {
      isLoading.value = false;
    }
  }


  void fetchAllUsersStream() {
    userProfileRepository.getAllUsersStreams().listen((data) {
      usersProfiles.value =
          data.where((element) => element.isAdmin == false).toList();
    });
  }



  void clearUser() {
    currentUser.value = null;
  }

// 2. The List actually shown on the screen

  void filterUsers(String val) {
    if (val.isEmpty) {
      // If search is empty, show everyone again
      filteredUsersProfiles.assignAll(usersProfiles);
    } else {
      // Filter from 'allUsers', but save the result into 'displayedUsers'
      final filtered = usersProfiles.where((user) {
        final nameMatch = user.fullName.toLowerCase().contains(val.toLowerCase());
        final emailMatch = user.email.toLowerCase().contains(val.toLowerCase());
        return nameMatch || emailMatch;
      }).toList();

      filteredUsersProfiles.assignAll(filtered);
    }
  }

  void addField(){
    userProfileRepository.addFieldToAllStudents();
  }

  /// Toggle function
  void toggleUserStatus(UserProfile user, bool value) async {
    // 1️⃣ Update the Switch's watcher IMMEDIATELY (Visual feedback)
    // This makes the switch move instantly without waiting for the internet.
    isActive.value = value;

    // 2️⃣ Update the local model
    user.isActive = value;

    // 3️⃣ Update Firestore (Do this in the background)
    // We use 'await' here, but since we updated the UI in step 1,
    // the user doesn't feel any lag.
    await userProfileRepository.updateIsActiveUser(user);

    // 4️⃣ Refresh lists to keep everything in sync
    usersProfiles.refresh();
    filteredUsersProfiles.refresh();
  }



}