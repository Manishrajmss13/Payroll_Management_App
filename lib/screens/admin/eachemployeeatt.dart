import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore import

class EmployeeAttendancePage extends StatefulWidget {
  final String userId;
  final String month;
  const EmployeeAttendancePage({super.key, required this.userId, required this.month});

  @override
  State<EmployeeAttendancePage> createState() => _EmployeeAttendancePageState();
}

class _EmployeeAttendancePageState extends State<EmployeeAttendancePage> {
  int totalWorkingDays = 22;
  int presentDays = 0;
  int absentDays = 0;
  List<String> absentLog = [];
  int? _touchedIndex;

  @override
  void initState() {
    super.initState();
    // Load attendance data from Firestore
    _loadAttendanceData();
  }

  // Fetch attendance data from Firestore
  Future<void> _loadAttendanceData() async {
    // Access the user's attendance document for the specified month
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('attendance')
        .doc(widget.month)
        .get();

    if (snapshot.exists) {
      var data = snapshot.data() as Map<String, dynamic>;

      setState(() {
        // Parse the data and update the state
        presentDays = data['PresentDays'] ?? 0;
        absentDays = data['AbsentDays'] ?? 0;
        absentLog = List<String>.from(data['AbsentsLog'] ?? []);
      });
    } else {
      print("No attendance data found for this user in the specified month.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text(
        "My Attendance",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Month Heading
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.only(bottom: 5),
              child: Text(
                widget.month, // Use the month passed in the constructor
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // Content Section
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Donut Chart with Legend
                  Column(
                    children: [
                      SizedBox(
                        height: 300,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 60,
                            sections: _buildChartSections(),
                            pieTouchData: PieTouchData(
                              touchCallback: (FlTouchEvent event, PieTouchResponse? response) {
                                setState(() {
                                  if (!event.isInterestedForInteractions || response == null) {
                                    _touchedIndex = null;
                                    return;
                                  }
                                  _touchedIndex = response.touchedSection?.touchedSectionIndex;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegend(Colors.green, "Days Worked"),
                          const SizedBox(width: 10),
                          _buildLegend(Colors.redAccent, "Days Leave"),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Summary Section
                  Container(
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSummaryRow(Icons.calendar_today, "Total Working Days", totalWorkingDays.toString()),
                        _buildSummaryRow(Icons.beach_access, "No of days present", presentDays.toString()),
                        _buildSummaryRow(Icons.check_circle, "No of days Absent", absentDays.toString()),
                        _buildSummaryRow(Icons.work, "Remaining Working Days",
                            (totalWorkingDays - presentDays).toString()),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Absent Log Button
                  ElevatedButton(
                    onPressed: _showAbsentLog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "View Absent Log",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show Absent Log Popup
  void _showAbsentLog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Absent Log"),
        content: SizedBox(
          height: 200,
          child: ListView.builder(
            itemCount: absentLog.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.circle, color: Colors.redAccent),
                title: Text(absentLog[index]),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildChartSections() {
    return [
      PieChartSectionData(
        color: Colors.green,
        value: presentDays.toDouble(),
        title: _touchedIndex == 0
            ? "$presentDays Days"
            : "${((presentDays / totalWorkingDays) * 100).toStringAsFixed(1)}%",
        radius: _touchedIndex == 0 ? 70 : 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.redAccent,
        value: absentDays.toDouble(),
        title: _touchedIndex == 1
            ? "$absentDays Days"
            : "${((absentDays / totalWorkingDays) * 100).toStringAsFixed(1)}%",
        radius: _touchedIndex == 1 ? 70 : 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ];
  }

  // Helper function to build summary rows
  Widget _buildSummaryRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to build legends
  Widget _buildLegend(Color color, String title) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
      ],
    );
  }
}
