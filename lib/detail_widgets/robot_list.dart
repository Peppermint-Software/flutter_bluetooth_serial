import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RobotList extends StatefulWidget {
  const RobotList({Key? key}) : super(key: key);

  @override
  _RobotListState createState() => _RobotListState();
}

class _RobotListState extends State<RobotList> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        trailing:
            const Icon(Icons.bluetooth_connected_rounded, color: Colors.green),
        title: const Text(
          'robot name',
          style: TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        subtitle: const Text(
          "Deployed At ",
          style: TextStyle(fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
        ),
        onTap: () {},
      ),
    );
  }
}
