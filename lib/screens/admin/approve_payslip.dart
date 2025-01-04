import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApprovePayslip extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ApprovePayslip({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Payslips"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No employees found.'));
          }

          final employees = snapshot.data!.docs.where((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return data['role'] != 'admin'; // Exclude admin roles
          }).toList();

          if (employees.isEmpty) {
            return const Center(child: Text('No employees available to manage payslips.'));
          }

          return ListView.builder(
            itemCount: employees.length,
            itemBuilder: (context, index) {
              final doc = employees[index];
              final data = doc.data() as Map<String, dynamic>;
              return _buildPayslipCard(
                context: context,
                employeeId: doc.id,
                name: data['name'] ?? 'Unknown',
                payslipStatus: data['payslipStatus'] ?? 'Pending',
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPayslipCard({
    required BuildContext context,
    required String employeeId,
    required String name,
    required String payslipStatus,
  }) {
    final isApproved = payslipStatus == "Approved";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("Payslip Status: $payslipStatus"),
        trailing: ElevatedButton(
          onPressed: () =>
              _togglePayslipStatus(context, employeeId, !isApproved),
          style: ElevatedButton.styleFrom(
            backgroundColor: isApproved ? Colors.red : Colors.green,
          ),
          child: Text(isApproved ? "Unapprove" : "Approve"),
        ),
      ),
    );
  }

  void _togglePayslipStatus(
      BuildContext context, String employeeId, bool approve) async {
    final newStatus = approve ? 'Approved' : 'Pending';

    try {
      await _firestore
          .collection('users')
          .doc(employeeId)
          .update({'payslipStatus': newStatus});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payslip status updated to $newStatus!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating payslip status: $e')),
      );
    }
  }
}
