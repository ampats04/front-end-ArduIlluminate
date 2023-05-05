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
      'action': 'Set brightness',
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
      appBar: AppBar(
        title: const Text('View Logs'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Logs',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 16),
            DataTable(
              columns: const [
                DataColumn(
                  label: Text(
                    'Timestamp',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Action',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                DataColumn(
                  label: Text(
                    'Status',
                    style: TextStyle(fontWeight: FontWeight.bold),
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
