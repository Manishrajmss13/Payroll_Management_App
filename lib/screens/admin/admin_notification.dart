import 'package:flutter/material.dart';
import 'package:payroll_system/screens/admin/manage_request.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart'; // Assuming this is the page for employee leave requests

class ManageNotificationPage extends StatefulWidget {
  const ManageNotificationPage({super.key});

  @override
  State<ManageNotificationPage> createState() => _ManageNotificationPageState();
}

class _ManageNotificationPageState extends State<ManageNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "Manage Notifications",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 10),
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Notifications will be displayed here
                    _buildNotificationCard(
                      notificationTitle: "Leave Request from John Doe",
                      notificationDate: "12.12.2024",
                    ),
                    _buildNotificationCard(
                      notificationTitle: "Leave Request from Jane Smith",
                      notificationDate: "10.11.2024",
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Reusable function for building each notification card
  Widget _buildNotificationCard({
    required String notificationTitle,
    required String notificationDate,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notificationTitle,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'Date: $notificationDate', // Only showing the notification date
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ],
            ),
          ),
          // Gradient button for "View"
          GestureDetector(
            onTap: () {
              // Navigate to the NotificationDetailPage or a similar page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ManageRequestPage(), // Replace with the actual details page
                ),
              );
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 23, 107, 204), // Dark blue
                    Color.fromARGB(255, 145, 193, 233), // Light blue
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: const Text(
                'View',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}