import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:payroll_system/screens/admin/request_approve.dart';

class ManageRequestPage extends StatelessWidget {
  const ManageRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Leave Requests')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('LeaveRequest').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final requests = snapshot.data!.docs;

          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              return ListTile(
                title: Text(request['name']),
                subtitle: Text('Dates: ${request['dates']}\nReason: ${request['reason']}'),
                trailing: Text(request['status']),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RequestApprovePage(requestId: request.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

