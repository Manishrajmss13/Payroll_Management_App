import 'package:flutter/material.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class ProfilePage extends StatefulWidget {
  final String employeeName;

  const ProfilePage({super.key, required this.employeeName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "My Profile",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 0.0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(
                  height:
                      20), // Add gap between the app bar and the white screen
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
                    _buildProfileRow('ID', '007'),
                    _buildProfileRow('Name', widget.employeeName),
                    _buildProfileRow('Age', '20'),
                    _buildProfileRow('Gender', 'Male'),
                    _divider(),
                    const SizedBox(height: 20),
                    _buildProfileRow('Role', 'Employee'),
                    _buildProfileRow('Designation', 'Developer'),
                    _divider(),
                    const SizedBox(height: 20),
                    _buildProfileRow('Gmail', 'johndoe@gmail.com'),
                    _buildProfileRow('Mobile No', '123-456-7890'),
                    _divider(),
                    const SizedBox(height: 1000),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build each profile row with consistent container size
  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        children: [
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
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
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
