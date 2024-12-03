import 'package:flutter/material.dart';
import 'package:payroll_system/widgets/custom_scaffold.dart';

class ApprovePayslipPage extends StatefulWidget {
  const ApprovePayslipPage({super.key});

  @override
  State<ApprovePayslipPage> createState() => _ApprovePayslipPageState();
}

class _ApprovePayslipPageState extends State<ApprovePayslipPage> {
  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      apptitle: const Text("My Profile",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          )),
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(
              height: 10,
            ),
          ),
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
            ),
          ),
        ],
      ),
    );
  }
}
