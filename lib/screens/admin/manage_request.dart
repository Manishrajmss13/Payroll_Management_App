import 'package:flutter/material.dart';
import 'package:payroll_system/screens/admin/request_approve.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';


class ManageRequestPage extends StatefulWidget {
  const ManageRequestPage({super.key});

  @override
  State<ManageRequestPage> createState() => _ManageRequestPageState();
}

class _ManageRequestPageState extends State<ManageRequestPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "Manage Requests",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        children: [
          const Expanded(
            flex: 0,
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Heading: "Leave Requests"

                    // Call the custom widget for each request
                    _buildRequestCard(
                      name: "John Doe",
                      fromDate: "12.12.24",
                      toDate: "15.12.24",
                    ),
                    _buildRequestCard(
                      name: "Jane Smith",
                      fromDate: "10.11.24",
                      toDate: "13.11.24",
                    ),
                    _buildRequestCard(
                      name: "Mark Johnson",
                      fromDate: "05.10.24",
                      toDate: "08.10.24",
                    ),
                    _buildRequestCard(
                      name: "Alice Brown",
                      fromDate: "01.12.24",
                      toDate: "04.12.24",
                    ),
                    _buildRequestCard(
                      name: "Bob White",
                      fromDate: "20.11.24",
                      toDate: "22.11.24",
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

  Widget _buildRequestCard({
    required String name,
    required String fromDate,
    required String toDate,
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
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  'From: $fromDate',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(
                  height: 4.0,
                ),
                Text(
                  'To: $toDate',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                ),
              ],
            ),
          ),
          // Gradient button for "View"
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequestPage(),
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
                    Color.fromARGB(255, 145, 193, 233),
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