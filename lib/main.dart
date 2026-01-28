import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:student_lms/create_courses/all_courses_admin.dart';
import 'package:student_lms/create_courses/create_courses_screen.dart';
import 'package:student_lms/create_outline/outline_binding.dart';
import 'package:student_lms/create_outline/outline_course_details_screen.dart';
import 'package:student_lms/enrollments/enrollment_binding.dart';
import 'package:student_lms/my_courses/course_details.dart';
import 'package:student_lms/my_courses/my_courses.dart';
import 'package:student_lms/my_courses/outline_progress_binding.dart';
import 'package:student_lms/my_progress_user/my_progress.dart';
import 'package:student_lms/my_progress_user/my_progressBinding.dart';
import 'package:student_lms/userProfile/create_student.dart';
import 'package:student_lms/home_page/home_page_binding.dart';
import 'package:student_lms/userProfile/studentProfileScreen.dart';
import 'package:student_lms/userProfile/user_profile_binding.dart';
import 'all_users_admin/all_users_screen.dart';
import 'all_users_admin/user_details_screen.dart';
import 'app_theme.dart';
import 'authentication/login/login_binding.dart';
import 'authentication/login/login_screen.dart';
import 'authentication/resetPassword/reset_password_binding.dart';
import 'authentication/resetPassword/reset_password_screen.dart';
import 'authentication/signUP/signUp_binding.dart';
import 'authentication/signUP/signup_screen.dart';
import 'create_courses/course_binding.dart';
import 'create_outline/create_outline_screen.dart';
import 'enrollments/enroll_students_screen.dart';
import 'firebase_options.dart';
import 'home_page/my_home_page_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: buildLmsTheme(),
      navigatorKey: Get.key,
      debugShowCheckedModeBanner: false,
      initialBinding: LoginBinding(),
      initialRoute: '/login',
      getPages: [
        // Main App Routes (Outside BottomNavBar)
        GetPage(name: "/login", page: () => LoginScreen(), binding: LoginBinding()),
        GetPage(name: "/signup", page: () => SignUp(), binding: SignupDependency()),
        GetPage(name: "/forget_password", page: () => ResetPasswordPage(), binding: ResetPasswordBinding()),

        // Individual screens (can be accessed directly if needed)
        GetPage(name: "/home", page: () => MyHomePage(),binding: HomePageBinding()),
        GetPage(name: "/create_courses", page: () => CreateCoursesScreen(),binding: CourseBinding()),
        GetPage(name: "/all_users", page: () => AllUsersScreen(),binding: UserProfileBinding()),
        GetPage(name: "/user_details_screen", page: () => UserDetailsScreen(),binding: EnrollmentBinding()),
        GetPage(name: "/create_student", page: () => CreateStudentScreen(),),
        GetPage(name: "/create_outline", page: () => CreateOutlineScreen(),binding: OutlineBinding()),
        GetPage(name: "/all_courses", page: () => AllCoursesAdmin(),binding: CourseBinding()),
        GetPage(name: "/course_details", page: () => OutlineCourseDetailsScreen(),binding: OutlineBinding()),
        GetPage(name: "/enroll_students", page: () => EnrollStudentsScreen(),binding: EnrollmentBinding()),
        GetPage(name: "/my_courses", page: () => MyCourses(),binding: UserProgressBinding()),
        GetPage(name: "/CourseDetails", page: () => CourseDetails(),binding: UserProgressBinding()),
        GetPage(name: "/my_progress", page: () => MyProgress(),binding: MyProgressBinding()),
        GetPage(name: "/profile", page: () => StudentProfileScreen(),binding: UserProfileBinding()),

      ],
    );
  }
}