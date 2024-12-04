import 'package:flutter/material.dart';
import 'package:payroll_system/screens/admin/admin_home.dart';
import 'package:payroll_system/screens/employee/employee_home.dart';
import 'package:payroll_system/screens/employee/profile.dart';
import 'package:payroll_system/screens/welcome_screen.dart';
void main()
{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget
{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context)
  {
    return const MaterialApp
    (
      debugShowCheckedModeBanner: false,
      title:"Payzo App",
      home: WelcomeScreen(),
    );
  }
}