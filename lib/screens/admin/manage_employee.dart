import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:payroll_system/screens/admin/editemployee.dart';
import 'package:payroll_system/screens/admin/viewall.dart';  // Assuming you have this page
import 'package:payroll_system/widgets/custom_scaffold.dart';
class ManageEmployeePage extends StatefulWidget {
  const ManageEmployeePage({super.key});

  @override
  State<ManageEmployeePage> createState() => _ManageEmployeePageState();
}

class _ManageEmployeePageState extends State<ManageEmployeePage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No employees found.'));
                  }

                  // Filter out employees with the role 'admin'
                  final filteredDocs = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    return data['role'] != 'admin';  // Exclude 'admin' roles
                  }).toList();

                  if (filteredDocs.isEmpty) {
                    return const Center(child: Text('No employees available to display.'));
                  }

                  return SingleChildScrollView(
                    child: Column(
                      children: filteredDocs.map((doc) {
                        final data = doc.data() as Map<String, dynamic>;
                        return _buildEmployeeCard(
                          name: data['name'] ?? 'Unknown',
                          designation: data['role'] ?? 'No Role',
                          docId: doc.id,  // Passing the doc id to card
                          email: data['email'] ?? '',
                          onDelete: () => _deleteEmployee(doc.id, data['email'] ?? ''),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Function to delete the employee from both Firestore and Firebase Authentication
  void _deleteEmployee(String id, String email) async {
    try {
      // Delete from Firestore
      await _firestore.collection('users').doc(id).delete();

      // Delete from Firebase Authentication
      User? user = _auth.currentUser;
      if (user != null && user.email == email) {
        await user.delete();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Employee deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting employee: $e')),
      );
    }
  }

  Widget _buildEmployeeCard({
    required String name,
    required String designation,
    required String docId,  // Passing docId directly to navigate
    required String email,  // Pass email for authentication deletion
    required VoidCallback onDelete,
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewEmployee(
                              employeeName: name,
                              employeeRole: designation,
                              employeeId: docId,  // Pass the docId correctly
                            ),
                          ),
                        );
                      },
                    ),
                    _buildActionButton(
                      label: "Edit",
                      colors: [
                        const Color.fromARGB(255, 34, 193, 34),
                        const Color.fromARGB(255, 144, 238, 144),
                      ],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditEmployee(
                              employeeName: name, // Pass the employee name
                              employeeRole: designation, // Pass the employee role
                              employeeId: docId, // Pass the Firebase document ID
                            ),
                          ),
                        );
                      },
                    ),
                    _buildActionButton(
                      label: "Delete",
                      colors: [
                        const Color.fromARGB(255, 204, 0, 0),
                        const Color.fromARGB(255, 255, 99, 99),
                      ],
                      onTap: () {
                        // Assuming `name`, `designation`, and `docId` are already available dynamically
                        final FirebaseFirestore _firestore = FirebaseFirestore.instance;
                        final FirebaseAuth _auth = FirebaseAuth.instance;

                        // Fetch the employee's data from Firestore using employeeId (docId)
                        _firestore.collection('users').doc(docId).get().then((docSnapshot) {
                          if (docSnapshot.exists) {
                            var data = docSnapshot.data() as Map<String, dynamic>;

                            String employeeEmail = data['email']; // Extract the email directly

                            // Get the current user from Firebase Authentication
                            User? user = _auth.currentUser;

                            if (user != null && user.email == employeeEmail) {
                              // If current user's email matches the employee's email, delete the Firebase Authentication user
                              user.delete();
                            }

                            // Delete the user document from Firestore using employeeId
                            _firestore.collection('users').doc(docId).delete();

                            // Provide feedback to user after successful deletion
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Employee deleted successfully')),
                            );
                          } else {
                            // Handle case where document does not exist
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Employee not found!')),
                            );
                          }
                        }).catchError((e) {
                          // Handle any errors that occur during the process
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error deleting employee: $e')),
                          );
                        });
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
    VoidCallback? onTap,  // Ensuring onTap is used correctly for actions
  }) {
    return GestureDetector(
      onTap: onTap,
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
