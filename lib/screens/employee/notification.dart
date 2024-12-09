import 'package:flutter/material.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class EmployeeNotificationPage extends StatefulWidget {
  const EmployeeNotificationPage({super.key});

  @override
  State<EmployeeNotificationPage> createState() =>
      _EmployeeNotificationPageState();
}

class _EmployeeNotificationPageState extends State<EmployeeNotificationPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "Notifications",
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notifications displayed as grey cards
                    _buildNotificationCard(
                      message:
                          "Your leave request from 12.12.2024 to 15.12.2024 has been accepted.",
                      statusColor: Colors.green,
                    ),
                    _buildNotificationCard(
                      message:
                          "Your leave request from 20.12.2024 to 22.12.2024 has been rejected.",
                      statusColor: Colors.red,
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

  // Function to build notification card
  Widget _buildNotificationCard({
    required String message,
    required Color statusColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon to indicate status
          Icon(
            Icons.circle,
            color: statusColor,
            size: 12,
          ),
          const SizedBox(width: 10.0),
          // Notification message
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
