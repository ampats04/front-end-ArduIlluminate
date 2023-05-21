import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ViewLogsPage extends StatefulWidget {
  const ViewLogsPage({Key? key}) : super(key: key);

  @override
  _ViewLogsPageState createState() => _ViewLogsPageState();
}

String uid = Auth().currentUser!.uid;

class _ViewLogsPageState extends State<ViewLogsPage> {
  final ref = FirebaseDatabase.instance.ref("post/uid/$uid");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.08),
        child: AppBar(
          title: Text(
            'View Logs',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: MediaQuery.of(context).size.width * 0.06,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              defaultChild: const Center(child: CircularProgressIndicator()),
              itemBuilder: ((context, snapshot, animation, index) {
                final action = snapshot.child('action').value.toString();
                final timestamp = snapshot.child('timestamp').value.toString();

                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Action')),
                    DataColumn(label: Text('Timestamp')),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text(action)),
                      DataCell(Text(timestamp)),
                    ]),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
