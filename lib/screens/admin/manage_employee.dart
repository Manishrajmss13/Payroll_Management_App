import 'package:flutter/material.dart';
import 'package:payroll_system/screens/admin/editemployee.dart';
import 'package:payroll_system/screens/admin/viewall.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class ManageEmployeePage extends StatefulWidget {
  const ManageEmployeePage({super.key});

  @override
  State<ManageEmployeePage> createState() => _ManageEmployeePageState();
}

class _ManageEmployeePageState extends State<ManageEmployeePage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "Manage Employees",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        children: [
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(15.0, 20.0, 15.0, 10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildEmployeeCard(
                      name: "John Doe",
                      designation: "Software Engineer",
                    ),
                    _buildEmployeeCard(
                      name: "Jane Smith",
                      designation: "UI/UX Designer",
                    ),
                    _buildEmployeeCard(
                      name: "Mark Johnson",
                      designation: "Project Manager",
                    ),
                    _buildEmployeeCard(
                      name: "Alice Brown",
                      designation: "Data Analyst",
                    ),
                    _buildEmployeeCard(
                      name: "Paul White",
                      designation: "System Administrator",
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

  Widget _buildEmployeeCard({
    required String name,
    required String designation,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blueAccent,
            child: Text(
              name[0].toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5.0),
                Text(
                  designation,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildActionButton(
                      label: "View",
                      colors: [
                        const Color.fromARGB(255, 23, 107, 204),
                        const Color.fromARGB(255, 145, 193, 233),
                      ],
                      npage: const ViewEmployee(employeeName: 'John'),
                    ),
                    _buildActionButton(
                      label: "Edit",
                      colors: [
                        const Color.fromARGB(255, 34, 193, 34),
                        const Color.fromARGB(255, 144, 238, 144),
                      ],
                      npage:  EditEmployee(),
                    ),
                    _buildActionButton(
                      label: "Delete",
                      colors: [
                        const Color.fromARGB(255, 204, 0, 0),
                        const Color.fromARGB(255, 255, 99, 99),
                      ],
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("$name has been deleted"),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required List<Color> colors,
    Widget? npage,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        } else if (npage != null) {
          Navigator.push(context, MaterialPageRoute(builder: (e) => npage));
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
