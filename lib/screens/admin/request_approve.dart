import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  DateTime? startDate = DateTime(2024, 12, 12); // Predefined start date
  DateTime? endDate = DateTime(2024, 12, 15); // Predefined end date

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "Leave Request Details",
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

                    // Predefined Reason for Leave (Admin Version)
                    _buildReasonField(),

                    const SizedBox(height: 20),

                    // From Label and Start Date (Static)
                    _buildDateLabel("From"),
                    _buildStaticDateDisplay(startDate),

                    const SizedBox(height: 20),

                    // To Label and End Date (Static)
                    _buildDateLabel("To"),
                    _buildStaticDateDisplay(endDate),

                    const SizedBox(height: 30),

                    // Accept or Reject Buttons (Admin Action)
                    _buildActionButtons(),
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

  // Method to build reason field (Pre-filled for Admin)
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
          controller: TextEditingController(
              text: "Personal reasons (family emergency)"),
          autocorrect: true,
          maxLines: null,
          readOnly: true, // Makes the field read-only for the admin
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: "Reason for Leave",
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  // Method to build the date label (From or To)
  Widget _buildDateLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Method to display static date (non-editable)
  Widget _buildStaticDateDisplay(DateTime? date) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          date != null
              ? DateFormat('dd/MM/yyyy').format(date)
              : "No date selected",
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  // Method to build action buttons for admin (Accept or Reject)
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Accept Button with green gradient
        Container(
          width: 140,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 34, 193, 34), // Green
                Color.fromARGB(255, 144, 238, 144), // Light Green
              ],
            ),
          ),
          child: ElevatedButton.icon(
            onPressed: _handleAccept,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            icon: const Icon(
              Icons.check,
              color: Colors.white,
            ),
            label: const Text(
              "Accept",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        // Reject Button with dark red gradient
        Container(
          width: 140,
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            gradient: const LinearGradient(
              colors: [
                Color.fromARGB(255, 204, 0, 0), // Dark Red
                Color.fromARGB(255, 255, 99, 99), // Light Red
              ],
            ),
          ),
          child: ElevatedButton.icon(
            onPressed: _handleReject,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            label: const Text(
              "Reject",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Method to handle Accept action
  void _handleAccept() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Leave Request Accepted!")),
    );
  }

  // Method to handle Reject action
  void _handleReject() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Leave Request Rejected!")),
    );
  }
}