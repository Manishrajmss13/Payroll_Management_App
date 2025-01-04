import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class ViewPayslipPage extends StatefulWidget {
  final String employeeId; // Passed from the previous screen
  const ViewPayslipPage({super.key, required this.employeeId});

  @override
  State<ViewPayslipPage> createState() => _ViewPayslipPageState();
}

class _ViewPayslipPageState extends State<ViewPayslipPage> {
  Stream<DocumentSnapshot>? _userStream;
  Stream<QuerySnapshot>? _payslipStream;

  @override
  void initState() {
    super.initState();
    // Initialize the streams
    _userStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.employeeId)
        .snapshots();

    _payslipStream = FirebaseFirestore.instance
        .collection('users')
        .doc(widget.employeeId)
        .collection('payslips')
        .orderBy('dateOfPayment', descending: true)
        .limit(1)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "View Payslip",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: _userStream,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (userSnapshot.hasError) {
            return Center(
              child: Text('Error: ${userSnapshot.error}'),
            );
          }
          if (!userSnapshot.hasData) {
            return const Center(child: Text('User data not available.'));
          }

          var userData = userSnapshot.data!.data() as Map<String, dynamic>;
          String payslipStatus = userData['payslipStatus'] ?? 'Pending';

          if (payslipStatus != 'Approved') {
            return const Center(
              child: Text(
                'Your payslip is not approved by the admin yet.',
                style: TextStyle(fontSize: 18, color: Colors.redAccent),
              ),
            );
          }

          return StreamBuilder<QuerySnapshot>(
            stream: _payslipStream,
            builder: (context, payslipSnapshot) {
              if (payslipSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (payslipSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${payslipSnapshot.error}'),
                );
              }
              if (!payslipSnapshot.hasData || payslipSnapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No payslip data available.'));
              }

              var payslipData = payslipSnapshot.data!.docs.first.data() as Map<String, dynamic>;

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Payslip Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                          const Divider(),
                          _buildSectionHeader('Earnings'),
                          _buildPayslipRow(
                            'Basic Pay',
                            '₹${payslipData['basicPay'] ?? '0'}',
                            isPositive: true,
                          ),
                          _buildPayslipRow(
                            'House Rental Allowance',
                            '₹${payslipData['houseRentalAllowance'] ?? '0'}',
                            isPositive: true,
                          ),
                          _buildPayslipRow(
                            'Special Allowance',
                            '₹${payslipData['specialAllowance'] ?? '0'}',
                            isPositive: true,
                          ),
                          _buildPayslipRow(
                            'Overtime Pay',
                            '₹${payslipData['overtimePay'] ?? '0'}',
                            isPositive: true,
                          ),
                          _buildPayslipRow(
                            'Bonus',
                            '₹${payslipData['bonus'] ?? '0'}',
                            isPositive: true,
                          ),
                          const SizedBox(height: 16),
                          _buildSectionHeader('Deductions'),
                          _buildPayslipRow(
                            'Provident Fund',
                            '₹${payslipData['providentFund'] ?? '0'}',
                            isPositive: false,
                          ),
                          _buildPayslipRow(
                            'Health Insurance',
                            '₹${payslipData['healthInsurance'] ?? '0'}',
                            isPositive: false,
                          ),
                          _buildPayslipRow(
                            'Tax',
                            '₹${payslipData['tax'] ?? '0'}',
                            isPositive: false,
                          ),
                          _buildPayslipRow(
                            'Attendance Deduction',
                            '₹${payslipData['attendanceDeduction'] ?? '0'}',
                            isPositive: false,
                          ),
                          const SizedBox(height: 16),
                          _buildSectionHeader('Summary'),
                          _buildPayslipRow(
                            'Gross Salary',
                            '₹${payslipData['grossSalary'] ?? '0'}',
                            isPositive: true,
                          ),
                          _buildPayslipRow(
                            'Total Deductions',
                            '₹${payslipData['totalDeductions'] ?? '0'}',
                            isPositive: false,
                          ),
                          _buildPayslipRow(
                            'Net Pay',
                            '₹${payslipData['netPay'] ?? '0'}',
                            isPositive: true,
                          ),
                          const Divider(),
                          _buildPayslipRow(
                            'Date of Payment',
                            payslipData['dateOfPayment'] ?? 'N/A',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildPayslipRow(String label, String value, {bool isPositive = true}) {
    Color textColor = isPositive ? Colors.green[700]! : Colors.red[700]!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
