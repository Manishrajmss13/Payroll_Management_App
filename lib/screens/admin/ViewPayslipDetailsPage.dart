import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ViewPayslipDetailsPage extends StatelessWidget {
  final String payslipId;

  const ViewPayslipDetailsPage({super.key, required this.payslipId});

  @override
  Widget build(BuildContext context) {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payslip Details"),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore.collection('payslips').doc(payslipId).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('Payslip not found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;
          final employeeName = data['employeeName'] ?? 'Unknown';
          final amount = data['amount'] ?? 0.0;
          final status = data['status'] ?? 'pending';
          final payPeriod = data['payPeriod'] ?? 'N/A';
          final deductions = data['deductions'] ?? 0.0;
          final netSalary = amount - deductions;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Employee: $employeeName',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text('Amount: \$${amount.toStringAsFixed(2)}'),
                Text('Deductions: \$${deductions.toStringAsFixed(2)}'),
                Text('Net Salary: \$${netSalary.toStringAsFixed(2)}'),
                const SizedBox(height: 10),
                Text('Pay Period: $payPeriod'),
                const SizedBox(height: 10),
                Text('Status: $status'),
                const SizedBox(height: 20),
                if (status == 'pending') ...[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the details view
                    },
                    child: const Text("Back to List"),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
