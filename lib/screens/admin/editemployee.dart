import 'package:flutter/material.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditEmployee extends StatefulWidget {
  final String employeeId;
  final String employeeName;
  final String employeeRole;

  const EditEmployee({
    super.key,
    required this.employeeId,
    required this.employeeName,
    required this.employeeRole,
  });

  @override
  State<EditEmployee> createState() => _EditEmployeePageState();
}

class _EditEmployeePageState extends State<EditEmployee> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _basicPayController = TextEditingController();

  int _age = 30;
  String? _gender = "Male";
  String? _role = "Software Developer";

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _fetchEmployeeData();
  }

  Future<void> _fetchEmployeeData() async {
    try {
      DocumentSnapshot employeeSnapshot =
      await _firestore.collection('users').doc(widget.employeeId).get();

      if (employeeSnapshot.exists) {
        var data = employeeSnapshot.data() as Map<String, dynamic>;

        setState(() {
          _nameController.text = data['name'] ?? '';
          _emailController.text = data['email'] ?? '';
          _mobileController.text = data['mobile'] ?? '';
          _basicPayController.text = data['basicPay']?.toString() ?? '';
          _age = data['age'] ?? 30;
          _gender = data['gender'] ?? "Male";
          _role = data['role'] ?? "Software Developer";
        });
      } else {
        throw Exception('Employee not found');
      }
    } catch (e) {
      print("Error fetching employee data: $e");
    }
  }

  Future<void> _updateEmployeeData() async {
    try {
      await _firestore.collection('users').doc(widget.employeeId).update({
        'name': _nameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'basicPay': double.tryParse(_basicPayController.text) ?? 0.0,
        'age': _age,
        'gender': _gender,
        'role': _role,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Changes Applied Successfully!"),
        ),
      );
    } catch (e) {
      print("Error updating employee data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to apply changes. Please try again."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "Edit Employee",
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
                  hintText: "Full Name",
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
                  hintText: "Email Address",
                  keyboardType: TextInputType.emailAddress,
                  editable: false,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _mobileController,
                  hintText: "Mobile Number",
                  keyboardType: TextInputType.phone,
                  editable: false,
                ),
                const SizedBox(height: 15),
                _buildTextField(
                  controller: _basicPayController,
                  hintText: "Basic Pay",
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 30),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_nameController.text.isNotEmpty &&
                            _emailController.text.contains('@') &&
                            _mobileController.text.isNotEmpty &&
                            _basicPayController.text.isNotEmpty) {
                          _updateEmployeeData();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please fill in all required fields."),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        backgroundColor: const Color.fromARGB(255, 23, 107, 204),
                      ),
                      child: const Text(
                        "Apply Changes",
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
    bool editable = true,
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
      enabled: editable,
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
            _buildGenderRadioButton("Male"),
            _buildGenderRadioButton("Female"),
            _buildGenderRadioButton("Other"),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderRadioButton(String gender) {
    return Row(
      children: [
        Radio<String>(
          value: gender,
          groupValue: _gender,
          onChanged: (String? value) {
            setState(() {
              _gender = value;
            });
          },
        ),
        Text(gender),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    String? value,
    required void Function(String?) onChanged,
  }) {
    return Row(
      children: [
        const Text(
          "Role:",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: value,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }
}
