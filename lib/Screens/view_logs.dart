import 'package:ardu_illuminate/Services/auth/auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class ViewLogsPage extends StatefulWidget {
  const ViewLogsPage({Key? key}) : super(key: key);

  @override
  State<ViewLogsPage> createState() => _ViewLogsPageState();
}

class _ViewLogsPageState extends State<ViewLogsPage> {
  int ctr = 1;
  List<Map<String, dynamic>> logsData = [];
  late Stream<List<Map<String, dynamic>>> logsStream;
  final _dataColumns = const [
    DataColumn(label: Text('Location')),
    DataColumn(label: Text('Date')),
    DataColumn(label: Text('Action')),
    DataColumn(label: Text('Time')),
  ];
  late Timer timer;

  @override
  void initState() {
    super.initState();
    logsStream = logsStreamController.stream;
    startDataFetching();
  }

  StreamController<List<Map<String, dynamic>>> logsStreamController =
      StreamController<List<Map<String, dynamic>>>();

  void startDataFetching() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchData(ctr).then((data) {
        if (data.isEmpty) {
          timer.cancel();
          print('Empty Data');
        }
        logsData.addAll(data);
        logsData.removeWhere((element) => element.containsValue(null));
        logsStreamController.sink.add(logsData);
        ctr++;
      });
    });
  }

  Future<List<Map<String, dynamic>>> fetchData(int ctr) async {
    List<Map<String, dynamic>> data = [];

    DatabaseReference ref = FirebaseDatabase.instance
        .ref("post/uid/${Auth().currentUser!.uid}/$ctr");

    print(ctr);

    DatabaseReference date = ref.child('date');
    DatabaseReference action = ref.child('action');
    DatabaseReference time = ref.child('time');
    DatabaseReference location = ref.child('location');

    DatabaseEvent actionRef = await action.once();
    DatabaseEvent timeRef = await time.once();
    DatabaseEvent dateRef = await date.once();
    DatabaseEvent locationRef = await location.once();

    String actionValue = actionRef.snapshot.value.toString();
    String timeValue = timeRef.snapshot.value.toString();
    String dateValue = dateRef.snapshot.value.toString();
    String locationValue = locationRef.snapshot.value.toString();

    if (actionValue != "null" && timeValue != "null" && dateValue != "null") {
      data.add({
        "location": locationValue,
        "date": dateValue,
        "action": actionValue,
        "time": timeValue,
      });
    }

    return data;
  }

  @override
  void dispose() {
    timer.cancel();
    logsStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('View Logs'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: logsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final data = snapshot.data;

                    return Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.height * 0.04),
                      child: PaginatedDataTable(
                        columns: _dataColumns,
                        source: MyData(data!),
                        columnSpacing: 20,
                        rowsPerPage: 10,
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MyData extends DataTableSource {
  final List<Map<String, dynamic>> _data;

  MyData(this._data);

  @override
  DataRow? getRow(int index) {
    if (index >= _data.length) {
      return null;
    }

    return DataRow(cells: [
      DataCell(Text(_data[index]["location"].toString())),
      DataCell(Text(_data[index]["date"].toString())),
      DataCell(Text(_data[index]["action"].toString())),
      DataCell(Text(_data[index]["time"].toString())),
    ]);
  }

  @override
  int get rowCount => _data.length;

  @override
  bool get isRowCountApproximate => false;

  @override
  int get selectedRowCount => 0;
}
