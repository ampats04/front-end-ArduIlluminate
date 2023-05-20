import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

class ViewLogsPage extends StatefulWidget {
  const ViewLogsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ViewLogsPageState createState() => _ViewLogsPageState();
}

class _ViewLogsPageState extends State<ViewLogsPage> {
  final ref = FirebaseDatabase.instance.ref("POST");
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
      body: Column(children: [
        Expanded(
            child: FirebaseAnimatedList(
          query: ref,
          defaultChild: const Text('Loading'),
          itemBuilder: ((context, snapshot, animation, index) {
            return ListTile(
              title: Text(snapshot.child('action').value.toString()),
              subtitle: Text(snapshot.child('timestamp').value.toString()),
            );
          }),
        ))
      ]),
    );
  }
}
