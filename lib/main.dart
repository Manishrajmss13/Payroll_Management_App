import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:payroll_system/screens/admin/admin_home.dart';
import 'package:payroll_system/screens/employee/employee_home.dart';
import 'package:payroll_system/screens/welcome_screen.dart';
import 'firebase_options.dart'; // Import the generated firebase_options.dart file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the platform-specific options
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Payzo App",
      home: WelcomeScreen(),
    );
  }
}
