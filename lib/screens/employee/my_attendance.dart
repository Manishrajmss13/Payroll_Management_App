import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class MyAttendancePage extends StatefulWidget {
  const MyAttendancePage({super.key});

  @override
  State<MyAttendancePage> createState() => _MyAttendancePageState();
}

class _MyAttendancePageState extends State<MyAttendancePage> {
  // Sample data for attendance
  final int totalDaysInYear = 365;
  final int daysWorked = 320;
  final int daysLeaveTaken = 45;
  final int yearlyLeaveAllowance = 50;

  // Store selected chart section
  int? _touchedIndex;

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
      child: Column(
        children: [
          // "December 2024" Heading
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
          Expanded(
            child: Container(
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
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
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
                            _buildLegend(Colors.teal, "Days Worked"),
                            const SizedBox(width: 10),
                            _buildLegend(Colors.orangeAccent, "Days Leave"),
                          ],
                        ),
                      ],
                    ),
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
                        _buildSummaryRow(Icons.calendar_today, "Total Days in Year", totalDaysInYear.toString()),
                        _buildSummaryRow(Icons.beach_access, "Leave Taken in Year", daysLeaveTaken.toString()),
                        _buildSummaryRow(Icons.check_circle, "Remaining Leave",
                            (yearlyLeaveAllowance - daysLeaveTaken).toString()),
                        _buildSummaryRow(Icons.work, "Remaining Working Days",
                            (totalDaysInYear - (daysWorked + daysLeaveTaken)).toString()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Helper function to create Pie Chart sections
  List<PieChartSectionData> _buildChartSections() {
    return [
      PieChartSectionData(
        color: Colors.teal,
        value: daysWorked.toDouble(),
        title: _touchedIndex == 0
            ? "$daysWorked Days"
            : "${((daysWorked / totalDaysInYear) * 100).toStringAsFixed(1)}%",
        radius: _touchedIndex == 0 ? 70 : 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      PieChartSectionData(
        color: Colors.orangeAccent,
        value: daysLeaveTaken.toDouble(),
        title: _touchedIndex == 1
            ? "$daysLeaveTaken Days"
            : "${((daysLeaveTaken / totalDaysInYear) * 100).toStringAsFixed(1)}%",
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
