import 'package:flutter/material.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';
import 'package:payroll_system/screens/admin/eachemployeeatt.dart';
class ViewAttendancePage extends StatefulWidget {
  const ViewAttendancePage({super.key});

  @override
  State<ViewAttendancePage> createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                  height: 20), // Add gap between the app bar and the content
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
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return AttendanceCard(
                      name: "John Doe $index",
                      role: "Developer",
                      attendancePercentage: "${90 - index}%",
                      isCheckedIn: index % 2 == 0,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const EmployeeAttendancePage(),
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