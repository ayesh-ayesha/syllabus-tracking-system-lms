import 'package:flutter/material.dart';

// --- Color Palette Definitions ---
// The main brand colors for the LMS.
const Color primaryColor = Color(0xFF2C3E50); // Deep, professional blue
const Color secondaryColor = Color(0xFF1ABC9C); // Vibrant cyan/teal

const Color backgroundColor = Color(0xFFF5F5F5); // Light gray for backgrounds
const Color textColor = Color(0xFF333333); // Dark gray for body text

// --- Snackbar Colors ---
// Standard colors for success and error messages.
const Color successColor = Colors.green;
const Color errorColor = Colors.red;

// --- MaterialColor for primarySwatch ---
// Flutter requires a MaterialColor for primarySwatch.
// This function generates a MaterialColor from a single color.
MaterialColor getMaterialColor(Color color) {
  final int red = color.red;
  final int green = color.green;
  final int blue = color.blue;
  final int alpha = color.alpha;

  Map<int, Color> shades = {
    50: Color.fromARGB(alpha, red, green, blue),
    100: Color.fromARGB(alpha, red, green, blue),
    200: Color.fromARGB(alpha, red, green, blue),
    300: Color.fromARGB(alpha, red, green, blue),
    400: Color.fromARGB(alpha, red, green, blue),
    500: Color.fromARGB(alpha, red, green, blue),
    600: Color.fromARGB(alpha, red, green, blue),
    700: Color.fromARGB(alpha, red, green, blue),
    800: Color.fromARGB(alpha, red, green, blue),
    900: Color.fromARGB(alpha, red, green, blue),
  };
  return MaterialColor(color.value, shades);
}

// --- App Theme Definition ---
ThemeData buildLmsTheme() {
  // Generate a MaterialColor for the primarySwatch
  final MaterialColor primaryMaterialColor = getMaterialColor(primaryColor);

  return ThemeData(
    // The main color swatch for the app. Used for widgets that don't have their own color.
    primarySwatch: primaryMaterialColor,
    primaryColor: primaryColor,

    // The main background color for the Scaffold.
    scaffoldBackgroundColor: backgroundColor,

    // The theme for the AppBar at the top of the screen.
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto', // You can change this to your preferred font
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
      ),
    ),

    // The theme for text throughout the app.
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: textColor),
      bodyMedium: TextStyle(color: textColor),
      headlineLarge: TextStyle(color: textColor),
      // Set other text styles as needed
    ),

    // The theme for all snackbars (temporary messages at the bottom of the screen).
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: successColor, // This will be the default background, we'll override it for errors
      actionTextColor: secondaryColor, // Use the accent color for action buttons
      contentTextStyle: TextStyle(color: Colors.white),
      behavior: SnackBarBehavior.floating, // To make the snackbar float above the bottom navigation bar
    ),

    // The theme for elevated buttons.
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    // The theme for floating action buttons.
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: secondaryColor,
      foregroundColor: Colors.white,
    ),

    // The theme for all input fields, like TextFields.
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: primaryColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: const BorderSide(color: secondaryColor, width: 2.0),
      ),
      labelStyle: const TextStyle(color: primaryColor),
    ),

    // The theme for progress indicators (like loading spinners).
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: secondaryColor,
    ),
  );
}
