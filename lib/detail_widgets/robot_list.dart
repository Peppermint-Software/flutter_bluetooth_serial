import 'dart:convert';
import 'package:flutter/material.dart';

class RobotList extends StatefulWidget {
  const RobotList({Key? key}) : super(key: key);

  @override
  _RobotListState createState() => _RobotListState();
}

class _RobotListState extends State<RobotList> {
  late List data;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DefaultAssetBundle.of(context)
            .loadString('assets/dummy/robot_list.json'),
        builder: (context, snapshot) {
          var newData = json.decode(snapshot.data.toString());
          return Expanded(
              child: ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Card(
                              child: Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 15,
                          )),
                          Text(newData[index]['name'],
                              textAlign: TextAlign.center,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(newData[index]['dep'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal)),
                          const Icon(
                            Icons.bluetooth_connected_rounded,
                            size: 15,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: newData == null ? 0 : newData.length,
          ));
        });
  }
}
