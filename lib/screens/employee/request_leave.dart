import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting
import 'package:payroll_system/widgets/custom_scaffold.dart';

class RequestLeavePage extends StatefulWidget {
  const RequestLeavePage({super.key});

  @override
  State<RequestLeavePage> createState() => _RequestLeavePageState();
}

class _RequestLeavePageState extends State<RequestLeavePage> {
  final TextEditingController reasonController = TextEditingController();
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "Request Leave",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 30.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Name and Role Section
                    _buildCenteredText("John Wick", Colors.blue, 20.0),
                    const SizedBox(height: 5),
                    _buildCenteredText("Designer", Colors.blueAccent, 18.0),
                    const SizedBox(height: 20),

                    // Reason for Leave
                    _buildReasonField(),

                    const SizedBox(height: 20),

                    // Start Date Selector
                    _buildDateSelector(
                      label: "Start Date",
                      selectedDate: startDate,
                      onTap: () async {
                        final pickedDate = await _selectDate();
                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 20),

                    // End Date Selector
                    _buildDateSelector(
                      label: "End Date",
                      selectedDate: endDate,
                      onTap: () async {
                        final pickedDate = await _selectDate();
                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    _buildSubmitButton(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Method to build centered text
  Widget _buildCenteredText(String text, Color color, double fontSize) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // Method to build reason field
  Widget _buildReasonField() {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: TextField(
          controller: reasonController,
          autocorrect: true,
          maxLines: null,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Reason for Leave",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  // Method to build date selector
  Widget _buildDateSelector({
    required String label,
    required DateTime? selectedDate,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(Icons.calendar_today),
            ),
            Text(
              selectedDate != null
                  ? DateFormat('dd/MM/yyyy').format(selectedDate)
                  : "Select $label",
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  // Method to build submit button
  Widget _buildSubmitButton() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 23, 107, 204), // Dark blue
            Color.fromARGB(255, 145, 193, 233), // Light blue
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: const Text(
          "Request Leave",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // Method to handle form submission
  void _handleSubmit() {
    if (reasonController.text.isNotEmpty &&
        startDate != null &&
        endDate != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Leave Requested Successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
    }
  }

  // Helper method to select a date
  // Helper method to select a date
  Future<DateTime?> _selectDate() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(), // Prevent selecting dates before today
      lastDate: DateTime(2100),
    );
  }
}
