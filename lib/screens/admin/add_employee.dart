import 'package:flutter/material.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddEmployeePage extends StatefulWidget {
  const AddEmployeePage({super.key});
  @override
  State<AddEmployeePage> createState() => _AddEmployeePageState();
}

class _AddEmployeePageState extends State<AddEmployeePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _basicPayController = TextEditingController();

  int _age = 25;
  String? _gender = "Male";
  String? _role = "Software Developer";

  Future<void> addEmployee() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _mobileController.text.trim(),
      );

      String userId = userCredential.user?.uid ?? "";

      double basicPay = double.parse(_basicPayController.text.trim());
      Map<String, dynamic> payslipDetails = _calculatePayslip(basicPay);

      await firestore.collection('users').doc(userId).set({
        'name': _nameController.text.trim(),
        'age': _age,
        'gender': _gender,
        'role': _role,
        'email': _emailController.text.trim(),
        'mobile': _mobileController.text.trim(),
        'basicPay': basicPay,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await firestore
          .collection('users')
          .doc(userId)
          .collection('payslips')
          .add(payslipDetails);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Employee added successfully! User ID: $userId')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  Map<String, dynamic> _calculatePayslip(double grossSalary) {
    // Define percentages of the gross salary
    double temp = grossSalary / 12;
    double basicPayPercentage = 0.5; // Basic Pay = 50% of Gross Salary
    double hraPercentage = 0.2; // HRA = 20% of Gross Salary
    double specialAllowancePercentage = 0.1; // Special Allowance = 10% of Gross Salary
    double overtimePayPercentage = 0.05; // Overtime = 5% of Gross Salary
    double bonusPercentage = 0.05; // Bonus = 5% of Gross Salary
    double providentFundPercentage = 0.05; // Provident Fund = 5% of Gross Salary
    double healthInsurancePercentage = 0.02; // Health Insurance = 2% of Gross Salary
    double taxPercentage = 0.03; // Tax = 3% of Gross Salary
    double attendanceDeductionPercentage = 0.01; // Attendance Deduction = 1% of Gross Salary

    // Calculate individual components
    int basicPay = (temp * basicPayPercentage).truncate();
    int hra = (temp * hraPercentage).truncate();
    int specialAllowance = (temp * specialAllowancePercentage).truncate();
    int overtimePay = (temp * overtimePayPercentage).truncate();
    int bonus = (temp * bonusPercentage).truncate();
    int providentFund = (temp * providentFundPercentage).truncate();
    int healthInsurance = (temp * healthInsurancePercentage).truncate();
    int tax = (temp * taxPercentage).truncate();
    int attendanceDeduction = (temp * attendanceDeductionPercentage).truncate();

    // Calculate totals
    int totalDeductions = providentFund + healthInsurance + tax + attendanceDeduction;
    int netPay = (temp - totalDeductions).truncate();

    return {
      'grossSalary': grossSalary.truncate(),
      'basicPay': basicPay,
      'houseRentalAllowance': hra,
      'specialAllowance': specialAllowance,
      'overtimePay': overtimePay,
      'bonus': bonus,
      'providentFund': providentFund,
      'healthInsurance': healthInsurance,
      'tax': tax,
      'attendanceDeduction': attendanceDeduction,
      'totalDeductions': totalDeductions,
      'netPay': netPay,
      'dateOfPayment': '23 Dec 2024', // Example date
      'adminApproval': false, // Default value for admin approval
    };
  }




  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "Add Employee",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 50, 30, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTextField(
                  controller: _nameController,
                  hintText: "Enter Full Name",
                ),
                const SizedBox(height: 15),
                _buildAgeSelector(),
                const SizedBox(height: 15),
                _buildGenderSelector(),
                const SizedBox(height: 15),
                _buildDropdown(
                  label: "Role",
                  items: const [
                    "Software Developer",
                    "UI Designer",
                    "Tester",
                    "Security Engineer",
                    "Data Analyst",
                    "Cloud Architect",
                    "Product Manager"
                  ],
                  value: _role,
                  onChanged: (value) {
                    setState(() {
                      _role = value;
                    });
                  },
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _emailController,
                  hintText: "Enter Email Address",
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _mobileController,
                  hintText: "Enter Mobile Number",
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _basicPayController,
                  hintText: "Enter Gross Pay",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                Center(
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      gradient: const LinearGradient(colors: [
                        Color.fromARGB(255, 23, 107, 204), // Dark blue
                        Color.fromARGB(255, 145, 193, 233),
                      ]),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isNotEmpty &&
                            _emailController.text.contains('@') &&
                            _mobileController.text.isNotEmpty &&
                            _basicPayController.text.isNotEmpty) {
                          addEmployee();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill in all required fields."),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      child: const Text(
                        "Add Employee",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey[300],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildAgeSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Age:",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                if (_age > 0) {
                  setState(() {
                    _age--;
                  });
                }
              },
              icon: const Icon(Icons.remove),
            ),
            Text(
              "$_age",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _age++;
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Gender:",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Male", style: TextStyle(fontSize: 14)),
                value: "Male",
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text("Female", style: TextStyle(fontSize: 14)),
                value: "Female",
                groupValue: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label:",
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[300],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide.none,
            ),
          ),
          value: value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 14)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
