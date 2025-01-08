
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class MyAttendancePage extends StatefulWidget {
  const MyAttendancePage({super.key});

  @override
  State<MyAttendancePage> createState() => _MyAttendancePageState();
}

class _MyAttendancePageState extends State<MyAttendancePage> {
  int totalWorkingDays = 22;
  int presentDays = 0;
  int absentDays = 0;
  List<String> absentLog = [];
  int? _touchedIndex;

  final String jsonData = '''
    [
      {"name": "leodas", "userId": "PcR8Ai6KUJdlJpzdPPfzKj3fJrk1", "month": "december", "date": "2024-12-02", "status": "Present"},
      {"name": "akash", "userId": "rC13ZJsnp9UTJ4TL6qeTSFAfK3t2", "month": "december", "date": "2024-12-02", "status": "Absent"}
    ]
  ''';

  @override
  void initState() {
    super.initState();
    _processAttendanceData();
  }

Future<void> _processAttendanceData() async {
  final firestore = FirebaseFirestore.instance;

  for (final entry in jsonDecode(jsonData)) {
    final String userId = entry['userId'];
    final String month = entry['month'].toLowerCase();

    final attendanceDoc = firestore
        .collection('users')
        .doc(userId)
        .collection('attendance')
        .doc(month);

    try {
      final docSnapshot = await attendanceDoc.get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data()!;
        final absentsLog = List<String>.from(data['AbsentsLog'] ?? []);

        if (entry['status'] == 'Absent' && !absentsLog.contains(entry['date'])) {
          absentsLog.add(entry['date']);
        }

        final updatedData = {
          'PresentDays': entry['status'] == 'Present' ? (data['PresentDays'] ?? 0) + 1 : data['PresentDays'],
          'AbsentDays': entry['status'] == 'Absent' ? (data['AbsentDays'] ?? 0) + 1 : data['AbsentDays'],
          'AbsentsLog': absentsLog,
        };

        await attendanceDoc.update(updatedData);
      } else {
        final newData = {
          'PresentDays': entry['status'] == 'Present' ? 1 : 0,
          'AbsentDays': entry['status'] == 'Absent' ? 1 : 0,
          'AbsentsLog': entry['status'] == 'Absent' ? [entry['date']] : [],
        };

        await attendanceDoc.set(newData);
      }
    } catch (e) {
      print("Error updating attendance for user $userId: $e");
    }
  }

  _fetchAttendanceData();
}


  Future<void> _fetchAttendanceData() async {
    final firestore = FirebaseFirestore.instance;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final attendanceDoc = await firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .doc('december')
          .get();

      if (attendanceDoc.exists) {
        final data = attendanceDoc.data()!;
        setState(() {
          presentDays = data['PresentDays'] ?? 0;
          absentDays = data['AbsentDays'] ?? 0;
          absentLog = List<String>.from(data['AbsentsLog'] ?? []);
        });
      }
    } catch (e) {
      print("Error fetching attendance data: $e");
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              margin: const EdgeInsets.only(bottom: 5),
              child: const Text(
                "December 2024",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
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
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
