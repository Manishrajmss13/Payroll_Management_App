import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:payroll_system/screens/employee/my_attendance.dart';
import 'package:payroll_system/screens/employee/request_leave.dart';
import 'package:payroll_system/screens/employee/view_payslip.dart';
import 'package:payroll_system/screens/employee/profile.dart';
import 'package:payroll_system/screens/employee/viewall.dart';
import 'package:payroll_system/screens/welcome_screen.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmployeeHome extends StatelessWidget {
  const EmployeeHome({super.key});

  Future<Map<String, dynamic>> _fetchUserData() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    // Fetch data from the 'users' collection
    final DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    if (userSnapshot.exists) {
      return userSnapshot.data() as Map<String, dynamic>;
    } else {
      throw Exception("User data not found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchUserData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        final userData = snapshot.data!;
        final String name = userData['name'] ?? "No Name";
        final String designation = userData['role'] ?? "No Role";
        final String docId = FirebaseAuth.instance.currentUser!.uid;

        return CustomScaffold(
          apptitle: const Text(
            "Home",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actionWidget: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: () {

                },
              ),
              IconButton(
                icon: const Icon(Icons.logout, color: Colors.white),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (e) => const WelcomeScreen()),
                        (route) => false,
                  );
                },
              ),
            ],
          ),
          child: Column(
            children: [
              const Expanded(
                flex: 1,
                child: SizedBox(
                  height: 10,
                ),
              ),
              Expanded(
                flex: 7,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40.0),
                      topRight: Radius.circular(40.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        "Choose your options",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.lightBlueAccent,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      Expanded(
                        child: GridView(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.8,
                          ),
                          children: [
                            _buildGradientButton(
                              "My Attendance",
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const MyAttendancePage(),
                                ),
                              ),
                            ),
                            _buildGradientButton(
                              "Request Leave",
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const RequestLeavePage(),
                                ),
                              ),
                            ),
                            _buildGradientButton(
                              "View Payslip",
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const ViewPayslipPage(),
                                ),
                              ),
                            ),
                            _buildGradientButton(
                              "My Profile",
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewEmployee(
                                    employeeName: name,
                                    employeeRole: designation,
                                    employeeId: docId,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGradientButton(String label, {required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 23, 107, 204), // Dark blue
            Color.fromARGB(255, 145, 193, 233), // Light blue
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(150, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
