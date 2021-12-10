import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RobotList extends StatefulWidget {
  const RobotList({Key? key}) : super(key: key);

  @override
  _RobotListState createState() => _RobotListState();
}

class _RobotListState extends State<RobotList> {
  late final List _data = [];

  // Future<void> getData() async {
  //   final String response =
  //       await rootBundle.loadString('assets/dummy/robot_list.json');
  //   final data = await json.decode(response);
  //   setState(() {
  //     _data = data['robots'];
  //   });

  //   // print(data[1]["title"]);

  //   // return "Success!";
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   getData();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/dummy/robot_list.json'),
        builder: (context, snapshot) {
          var newData = json.decode(snapshot.data.toString());
          List _newData = [];
          return Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int i) {
              return Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(_newData[i]['name'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(_newData[i]['dep'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            itemCount: newData == null ? 0 : newData.length,
          ));
        });
  }
}
