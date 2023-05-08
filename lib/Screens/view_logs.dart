import 'package:flutter/material.dart';

class ViewLogsPage extends StatefulWidget {
  const ViewLogsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewLogsPageState createState() => _ViewLogsPageState();
}

class _ViewLogsPageState extends State<ViewLogsPage> {
  final List<Map<String, String>> logs = [
    {
      'timestamp': '2022-05-05 8:30:09',
      'action': 'Turned on',
      'status': 'On',
    },
    {
      'timestamp': '2022-05-05 8:25:21',
      'action': 'Set Brightness',
      'status': '50%',
    },
    {
      'timestamp': '2022-05-05 8:20:42',
      'action': 'Turned off',
      'status': 'Off',
    },
    {
      'timestamp': '2022-05-05 9:20:00',
      'action': 'Timer: 50 Minutes',
      'status': 'On',
    },
    {
      'timestamp': '2022-05-05 10:30:00',
      'action': 'Timer: 50 Minutes',
      'status': 'Off',
    },
  ];

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
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            DataTable(
              columns: [
                DataColumn(
                  label: Text(
                    'Timestamp',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontFamily: 'Poppins'),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontFamily: 'Poppins'),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: MediaQuery.of(context).size.height * 0.04,
                        fontFamily: 'Poppins'),
                  ),
                ),
              ],
              rows: logs
                  .map(
                    (log) => DataRow(
                      cells: [
                        DataCell(Text(log['timestamp']!)),
                        DataCell(Text(log['action']!)),
                        DataCell(Text(log['status']!)),
                      ],
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
