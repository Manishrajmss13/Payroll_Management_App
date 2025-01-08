import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';
import 'package:payroll_system/screens/admin/eachemployeeatt.dart';

class ViewAttendancePage extends StatefulWidget {

   
  const ViewAttendancePage({super.key});

  @override
  State<ViewAttendancePage> createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  List<Map<String, dynamic>> attendanceData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAttendanceData();
  }

  Future<void> _fetchAttendanceData() async {
    try {
      final firestore = FirebaseFirestore.instance;
      final usersCollection = await firestore.collection('users').get();

      List<Map<String, dynamic>> fetchedData = [];

      for (var userDoc in usersCollection.docs) {
        final userId = userDoc.id;

        final monthDoc = await firestore
            .collection('users')
            .doc(userId)
            .collection('attendance')
            .doc('december')
            .get();

        if (monthDoc.exists) {
          final data = monthDoc.data();
          fetchedData.add({
            'userId': userId,
            'name': userDoc.data()['name'] ?? 'Unknown User',
            'role': userDoc.data()['role'] ?? 'Unknown Role',
            'presentDays': data?['PresentDays'] ?? 0,
            'absentDays': data?['AbsentDays'] ?? 0,
          });
        }
      }

      setState(() {
        attendanceData = fetchedData;
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching attendance data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "View Attendance",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.fromLTRB(25.0, 60.0, 25.0, 20.0),
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 249, 249, 249),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40.0),
                          topRight: Radius.circular(40.0),
                        ),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: attendanceData.length,
                        itemBuilder: (context, index) {
                          final user = attendanceData[index];
                          return AttendanceCard(
                            name: user['name'],
                            role: user['role'],
                            attendancePercentage: _calculateAttendancePercentage(
                              user['presentDays'],
                              user['absentDays'],
                            ),
                            isCheckedIn: user['presentDays'] > user['absentDays'],
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EmployeeAttendancePage(userId: user['userId'] ,  month: 'december'),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  String _calculateAttendancePercentage(int presentDays, int absentDays) {
    final totalDays = presentDays + absentDays;
    if (totalDays == 0) return '0%';
    final percentage = (presentDays / totalDays) * 100;
    return '${percentage.toStringAsFixed(1)}%';
  }
}

class AttendanceCard extends StatelessWidget {
  final String name;
  final String role;
  final String attendancePercentage;
  final bool isCheckedIn;
  final VoidCallback onTap;

  const AttendanceCard({
    super.key,
    required this.name,
    required this.role,
    required this.attendancePercentage,
    required this.isCheckedIn,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    "Attendance: $attendancePercentage",
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              Icon(
                isCheckedIn ? Icons.check_circle : Icons.cancel,
                color: isCheckedIn ? Colors.green : Colors.red,
                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
