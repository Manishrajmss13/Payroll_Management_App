import 'package:flutter/material.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class ViewPayslipPage extends StatefulWidget {
  const ViewPayslipPage({super.key});

  @override
  State<ViewPayslipPage> createState() => _ViewPayslipPageState();
}

class _ViewPayslipPageState extends State<ViewPayslipPage> {
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
      child: Column(
        children: [
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
              child: ListView(
                children: [
                  // Basic Information
                  _buildPayslipRow('Name', 'John Doe'),
                  _buildPayslipRow('ID', 'EMP12345'),
                  _buildPayslipRow('Designation', 'Software Developer'),
                  _buildPayslipRow('Period', 'December 2024'),
                  const Divider(),

                  // Salary Components
                  _buildPayslipRow('Basic Pay', '₹50,000', isPositive: true),
                  _buildPayslipRow('House Rental Allowance', '₹20,000', isPositive: true),
                  _buildPayslipRow('Special Allowance', '₹2,500', isPositive: true),
                  _buildPayslipRow('Overtime Pay', '₹5,000', isPositive: true),
                  _buildPayslipRow('Bonus', '₹10,000', isPositive: true),
                  const Divider(),

                  // Deductions
                  _buildPayslipRow('Provident Fund', '₹2,500', isPositive: false),
                  _buildPayslipRow('Health Insurance', '₹1,000', isPositive: false),
                  _buildPayslipRow('Tax', '₹1,500', isPositive: false),
                  _buildPayslipRow('Attendance Deduction', '₹500', isPositive: false),
                  const Divider(),

                  // Gross Salary and Net Pay
                  _buildPayslipRow('Gross Salary', '₹87,500', isPositive: true),
                  _buildPayslipRow('Total Deductions', '₹5,500', isPositive: false),
                  _buildPayslipRow('Net Pay', '₹82,000', isPositive: true),
                  const Divider(),

                  // Date of Payment
                  _buildPayslipRow('Date of Payment', '23 Dec 2024'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build each payslip row
  Widget _buildPayslipRow(String label, String value, {bool isPositive = true}) {
    // Determine color based on whether the value is positive or negative
    Color textColor = isPositive ? Colors.green[700]! : Colors.red[700]!;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16,
                color: textColor, // Apply the color conditionally
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
