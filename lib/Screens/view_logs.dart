// main.dart
import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class ViewLogsPage extends StatefulWidget {
  const ViewLogsPage({Key? key}) : super(key: key);

  @override
  State<ViewLogsPage> createState() => _ViewLogsPageState();
}

class _ViewLogsPageState extends State<ViewLogsPage> {
  late Future<List<Map<String, dynamic>>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchData();
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    List<Map<String, dynamic>> data = [];

    Stream<DatabaseEvent> stream = ctrRef.child('ctr').onValue;
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("post/uid/${Auth().currentUser!.uid}/2");

    DatabaseReference date = ref.child('date');
    DatabaseReference action = ref.child('action');
    DatabaseReference time = ref.child('time');

    DatabaseEvent actionRef = await action.once();
    DatabaseEvent timeRef = await time.once();
    DatabaseEvent dateRef = await date.once();

    String actionValue = actionRef.snapshot.value.toString();
    String timeValue = timeRef.snapshot.value.toString();
    String dateValue = dateRef.snapshot.value.toString();

    for (int index = 0; index < 2000; index++) {
      data.add({
        "date": dateValue,
        "action": actionValue,
        "time": timeValue,
      });
    }

    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Logs'),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: futureData,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final data = snapshot.data!;

              return PaginatedDataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Action')),
                  DataColumn(label: Text('Time'))
                ],
                source: MyData(data),
                columnSpacing: 40,
                rowsPerPage: 10,
              );
            }
          },
        ),
      ),
    );
  }
}

void _test() {
  Stream<DatabaseEvent> stream = ctrRef.child('ctr').onValue;

  stream.listen((DatabaseEvent event) {
    ctr = event.snapshot.value as int;

    print("value of ctr right in Timer $ctr");
  });
}

int ctr = 0;
final DatabaseReference ctrRef = FirebaseDatabase.instance.ref('counter');

// The "soruce" of the table
class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  MyData(this._data);

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => _data.length;

  @override
  int get selectedRowCount => 0;

  @override
  DataRow getRow(int index) {
    return DataRow(cells: [
      DataCell(Text(_data[index]["date"].toString())),
      DataCell(Text(_data[index]["action"].toString())),
      DataCell(Text(_data[index]["time"].toString())),
    ]);
  }
}
