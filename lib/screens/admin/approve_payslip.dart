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
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _showDateInputDialog(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                child: const Text("Update All Payment Dates"),
              ),
              ElevatedButton(
                onPressed: () => _approveAllPayslips(context),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text("Approve All"),
              ),
            ],
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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
                  return const Center(
                      child: Text('No employees available to manage payslips.'));
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
          ),
        ],
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () =>
                  _togglePayslipStatus(context, employeeId, !isApproved),
              style: ElevatedButton.styleFrom(
                backgroundColor: isApproved ? Colors.red : Colors.green,
              ),
              child: Text(isApproved ? "Unapprove" : "Approve"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => _showEditPayslipDialog(context, employeeId),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              child: const Text("Edit"),
            ),
          ],
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

  void _showEditPayslipDialog(BuildContext context, String employeeId) async {
    try {
      final payslipsSnapshot =
      await _firestore.collection('users/$employeeId/payslips').get();

      if (payslipsSnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No payslip data found to edit.")),
        );
        return;
      }

      final payslipDoc = payslipsSnapshot.docs.first;
      final payslipData = payslipDoc.data();

      // Initialize controllers
      TextEditingController grossSalaryController =
      TextEditingController(text: payslipData['grossSalary'].toString());
      TextEditingController basicPayController =
      TextEditingController(text: payslipData['basicPay'].toString());
      TextEditingController hraController =
      TextEditingController(text: payslipData['hra'].toString());
      TextEditingController specialAllowanceController =
      TextEditingController(
          text: payslipData['specialAllowance'].toString());
      TextEditingController overtimePayController =
      TextEditingController(text: payslipData['overtimePay'].toString());
      TextEditingController bonusController =
      TextEditingController(text: payslipData['bonus'].toString());
      TextEditingController providentFundController =
      TextEditingController(text: payslipData['providentFund'].toString());
      TextEditingController healthInsuranceController =
      TextEditingController(
          text: payslipData['healthInsurance'].toString());
      TextEditingController taxController =
      TextEditingController(text: payslipData['tax'].toString());
      TextEditingController attendanceDeductionController =
      TextEditingController(
          text: payslipData['attendanceDeduction'].toString());
      TextEditingController netPayController =
      TextEditingController(text: payslipData['netPay'].toString());

      // Function to calculate payslip components
      void _calculatePayslipComponents() {
        double grossSalary = double.tryParse(grossSalaryController.text) ?? 0.0;
        double temp = grossSalary / 12;

        // Percentages
        const double basicPayPercentage = 0.5;
        const double hraPercentage = 0.2;
        const double specialAllowancePercentage = 0.1;
        const double providentFundPercentage = 0.05;
        const double healthInsurancePercentage = 0.02;
        const double taxPercentage = 0.03;

        // Editable fields
        double bonus = double.tryParse(bonusController.text) ?? 0.0;
        double overtimePay = double.tryParse(overtimePayController.text) ?? 0.0;
        double attendanceDeduction =double.tryParse(overtimePayController.text) ??
             0.0;

        // Calculations
        basicPayController.text = (temp * basicPayPercentage).truncate().toString();
        hraController.text = (temp * hraPercentage).truncate().toString();
        specialAllowanceController.text =
            (temp * specialAllowancePercentage).truncate().toString();
        providentFundController.text =
            (temp * providentFundPercentage).truncate().toString();
        healthInsuranceController.text =
            (temp * healthInsurancePercentage).truncate().toString();
        taxController.text = (temp * taxPercentage).truncate().toString();

        // Total deductions and net pay
        int totalDeductions = (double.tryParse(providentFundController.text) ?? 0).round() +
            (double.tryParse(healthInsuranceController.text) ?? 0).round() +
            (double.tryParse(taxController.text) ?? 0).round() +
            attendanceDeduction.round();

        double netPay = temp + bonus + overtimePay - totalDeductions;
        netPayController.text = netPay.truncate().toString();
      }

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Edit Payslip Details"),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      // Gross Salary Field
                      TextField(
                        controller: grossSalaryController,
                        decoration: const InputDecoration(labelText: "Gross Salary"),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() => _calculatePayslipComponents());
                        },
                      ),

                      // Basic Pay
                      TextField(
                        controller: basicPayController,
                        decoration: const InputDecoration(labelText: "Basic Pay"),
                        readOnly: true,
                      ),

                      // HRA
                      TextField(
                        controller: hraController,
                        decoration: const InputDecoration(labelText: "HRA"),
                        readOnly: true,
                      ),

                      // Special Allowance
                      TextField(
                        controller: specialAllowanceController,
                        decoration:
                        const InputDecoration(labelText: "Special Allowance"),
                        readOnly: true,
                      ),

                      // Overtime Pay (Editable)
                      TextField(
                        controller: overtimePayController,
                        decoration: const InputDecoration(labelText: "Overtime Pay"),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() => _calculatePayslipComponents());
                        },
                      ),

                      // Bonus (Editable)
                      TextField(
                        controller: bonusController,
                        decoration: const InputDecoration(labelText: "Bonus"),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() => _calculatePayslipComponents());
                        },
                      ),

                      // Provident Fund
                      TextField(
                        controller: providentFundController,
                        decoration:
                        const InputDecoration(labelText: "Provident Fund"),
                        readOnly: true,
                      ),

                      // Health Insurance
                      TextField(
                        controller: healthInsuranceController,
                        decoration:
                        const InputDecoration(labelText: "Health Insurance"),
                        readOnly: true,
                      ),

                      // Tax
                      TextField(
                        controller: taxController,
                        decoration: const InputDecoration(labelText: "Tax"),
                        readOnly: true,
                      ),

                      // Attendance Deduction (Editable)
                      TextField(
                        controller: attendanceDeductionController,
                        decoration:
                        const InputDecoration(labelText: "Attendance Deduction"),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() => _calculatePayslipComponents());
                        },
                      ),

                      // Net Pay
                      TextField(
                        controller: netPayController,
                        decoration: const InputDecoration(labelText: "Net Pay"),
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final updatedData = {
                        'grossSalary': double.tryParse(grossSalaryController.text) ?? 0.0,
                        'basicPay': int.tryParse(basicPayController.text) ?? 0,
                        'hra': int.tryParse(hraController.text) ?? 0,
                        'specialAllowance':
                        int.tryParse(specialAllowanceController.text) ?? 0,
                        'overtimePay': double.tryParse(overtimePayController.text) ?? 0.0,
                        'bonus': double.tryParse(bonusController.text) ?? 0.0,
                        'providentFund':
                        int.tryParse(providentFundController.text) ?? 0,
                        'healthInsurance':
                        int.tryParse(healthInsuranceController.text) ?? 0,
                        'tax': int.tryParse(taxController.text) ?? 0,
                        'attendanceDeduction':
                        double.tryParse(attendanceDeductionController.text) ?? 0.0,
                        'netPay': double.tryParse(netPayController.text) ?? 0.0,
                      };

                      _updatePayslipDetails(
                          context, employeeId, payslipDoc.id, updatedData);
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            },
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading payslip details: $e")),
      );
    }
  }


  void _updatePayslipDetails(
      BuildContext context,
      String employeeId,
      String payslipId,
      Map<String, dynamic> updatedData,
      ) async {
    try {
      await _firestore
          .collection('users/$employeeId/payslips')
          .doc(payslipId)
          .update(updatedData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payslip details updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating payslip details: $e")),
      );
    }
  }

  void _showDateInputDialog(BuildContext context) {
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Enter New Payment Date"),
          content: TextField(
            controller: dateController,
            decoration: const InputDecoration(
              hintText: "december",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final newDate = dateController.text.trim();
                if (newDate.isNotEmpty) {
                  _updateAllPaymentDates(context, newDate);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a valid date!")),
                  );
                }
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void _updateAllPaymentDates(BuildContext context, String month) async {
    final firestore = FirebaseFirestore.instance;

    try {
      // Retrieve all users from the Firestore "users" collection
      QuerySnapshot userSnapshots = await firestore.collection("users").get();

      for (var userDoc in userSnapshots.docs) {
        final userRef = userDoc.reference;

        // Access the payslips collection and fetch the relevant document for the given month
        QuerySnapshot payslipSnapshots = await userRef
            .collection("payslips")
            .where("dateOfPayment", isEqualTo: month.toLowerCase())
            .get();

        if (payslipSnapshots.docs.isNotEmpty) {
          // Get the first payslip document (assuming one document per month)
          final payslipData = payslipSnapshots.docs.first.data() as Map<String, dynamic>;

          // Extract grossSalary and other payslip components
          double grossSalary = payslipData["grossSalary"] ?? 0.0;
          double bonus = payslipData["bonus"] ?? 0.0;
          double overtimePay = payslipData["overtimePay"] ?? 0.0;

          // Percentages for deductions and calculations
          const double basicPayPercentage = 0.5;
          const double hraPercentage = 0.2;
          const double specialAllowancePercentage = 0.1;
          const double providentFundPercentage = 0.05;
          const double healthInsurancePercentage = 0.02;
          const double taxPercentage = 0.03;

          // Base salary calculation (grossSalary / 12)
          double baseSalary = grossSalary / 12;

          // Calculated fields
          double basicPay = baseSalary * basicPayPercentage;
          double hra = baseSalary * hraPercentage;
          double specialAllowance = baseSalary * specialAllowancePercentage;
          double providentFund = baseSalary * providentFundPercentage;
          double healthInsurance = baseSalary * healthInsurancePercentage;
          double tax = baseSalary * taxPercentage;

          // Access the attendance document for the given month
          DocumentReference attendanceRef = userRef.collection("attendance").doc(month.toLowerCase());
          DocumentSnapshot attendanceSnapshot = await attendanceRef.get();

          double attendanceDeduction = 0.0;
          if (attendanceSnapshot.exists) {
            final attendanceData = attendanceSnapshot.data() as Map<String, dynamic>;
            int absentDays = attendanceData["AbsentDays"] ?? 0;

            // Calculate attendance deduction
            if (absentDays > 8) {
              attendanceDeduction = 0.01 * grossSalary;
            }
          }

          // Total deductions
          double totalDeductions = providentFund + healthInsurance + tax + attendanceDeduction;

          // Net Pay calculation
          double netPay = baseSalary + bonus + overtimePay - totalDeductions;

          // Update the payslips collection with the calculated values
          await payslipSnapshots.docs.first.reference.update({
            "basicPay": basicPay.round(),
            "hra": hra.round(),
            "specialAllowance": specialAllowance.round(),
            "providentFund": providentFund.round(),
            "healthInsurance": healthInsurance.round(),
            "tax": tax.round(),
            "attendanceDeduction": attendanceDeduction.round(),
            "totalDeductions": totalDeductions.round(),
            "netPay": netPay.round(),
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating attendance: $e")),
      );
    }
  }

  void _approveAllPayslips(BuildContext context) async {
    try {
      final usersSnapshot = await _firestore.collection('users').get();

      WriteBatch batch = _firestore.batch();

      for (var userDoc in usersSnapshot.docs) {
        final data = userDoc.data() as Map<String, dynamic>;
        if (data['role'] != 'admin') {
          batch.update(
            _firestore.collection('users').doc(userDoc.id),
            {'payslipStatus': 'Approved'},
          );
        }
      }

      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All payslips approved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving all payslips: $e')),
      );
    }
  }
}
