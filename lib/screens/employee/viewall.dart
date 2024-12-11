import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class ViewEmployee extends StatefulWidget {
  final String employeeId;  // Passed from the previous screen
  final String employeeName;  // Passed from the previous screen
  final String employeeRole;  // Passed from the previous screen

  const ViewEmployee({
    super.key,
    required this.employeeId,
    required this.employeeName,
    required this.employeeRole,
  });

  @override
  State<ViewEmployee> createState() => _ViewEmployeeState();
}

class _ViewEmployeeState extends State<ViewEmployee> {
  Future<Map<String, dynamic>>? employeeData;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    employeeData = _fetchEmployeeData();
  }

  // Fetch employee data from Firestore
  Future<Map<String, dynamic>> _fetchEmployeeData() async {
    try {
      DocumentSnapshot employeeSnapshot = await _firestore.collection('users').doc(widget.employeeId).get();

      if (employeeSnapshot.exists) {
        var data = employeeSnapshot.data() as Map<String, dynamic>;
        return data;
      } else {
        throw Exception('Employee not found');
      }
    } catch (e) {
      print("Error fetching employee data: $e");
      throw Exception('Failed to fetch employee data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "Employee Profile",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: SingleChildScrollView(
          child: FutureBuilder<Map<String, dynamic>>(
            future: employeeData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              if (!snapshot.hasData) {
                return const Center(child: Text('No employee data available.'));
              }

              var data = snapshot.data!;

              // Using nullable types, so no LateInitializationError
              String? employeeEmail = data['email'];
              String? employeeMobile = data['mobile'];
              int? employeeAge = data['age'];
              double? employeeBasicPay = data['basicPay'];

              return Column(
                children: [
                  const SizedBox(height: 20), // Add gap between the app bar and the white screen
                  Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 60.0, 25.0, 20.0),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 249, 249, 249),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProfileCard(
                          label: "Name",
                          value: widget.employeeName,
                          icon: Icons.person,
                        ),
                        _buildProfileCard(
                          label: "Role",
                          value: widget.employeeRole,
                          icon: Icons.work,
                        ),
                        _divider(),
                        _buildProfileCard(
                          label: "Age",
                          value: employeeAge?.toString() ?? 'N/A',
                          icon: Icons.calendar_today,
                        ),
                        _buildProfileCard(
                          label: "Basic Pay",
                          value: employeeBasicPay?.toString() ?? 'N/A',
                          icon: Icons.attach_money,
                        ),
                        _divider(),
                        _buildProfileCard(
                          label: "Email",
                          value: employeeEmail ?? 'No email available',
                          icon: Icons.email,
                        ),
                        _divider(),
                        _buildProfileCard(
                          label: "Mobile",
                          value: employeeMobile ?? 'No mobile available',
                          icon: Icons.phone,
                        ),
                        const SizedBox(height: 100), // Spacing at the bottom
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  // Method to build each profile card with consistent container size
  Widget _buildProfileCard({required String label, required String value, required IconData icon}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 30,
            color: Colors.blueAccent,
          ),
          const SizedBox(width: 16.0),
          SizedBox(
            width: 100, // Fixed width for label
            child: Text(
              "$label:",
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Divider with consistent styling
  Widget _divider() {
    return const Divider(color: Colors.black, thickness: 1);
  }
}
