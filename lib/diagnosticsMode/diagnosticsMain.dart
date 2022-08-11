import 'package:flutter/material.dart';
import 'package:getwidget/components/accordion/gf_accordion.dart';
import 'package:getwidget/components/appbar/gf_appbar.dart';

void main() => runApp(const DiagnosticsMain());

class DiagnosticsMain extends StatefulWidget {
  const DiagnosticsMain({Key? key}) : super(key: key);

  @override
  State<DiagnosticsMain> createState() => _DiagnosticsMainState();
}

class _DiagnosticsMainState extends State<DiagnosticsMain> {
  @override
  Widget build(BuildContext context) => MediaQuery(
      data: const MediaQueryData(),
      child: MaterialApp(
          home: Scaffold(
              appBar: GFAppBar(
                backgroundColor: Colors.white30,
                bottomOpacity: 0,
                title: const Text("Diagnostics"),
                actions: const <Widget>[
                  Icon(
                    Icons.circle,
                    size: 24,
                    color: Colors.green,
                  )
                ],
              ),
              body: Column(children: [
                Expanded(
                    child: ListView.builder(
                        itemCount: 3,
                        itemBuilder: (context, index) => GFAccordion(
                              collapsedIcon: const Icon(
                                Icons.arrow_drop_down_circle_rounded,
                                color: Colors.grey,
                              ),
                              contentChild: placeholder(context),
                              showAccordion: true,
                              contentPadding: const EdgeInsets.all(8),
                              title: titleList[index].toString(),
                            ))),
              ]))));
}

var titleList = {0: "General Info", 1: "Cleaning Data", 2: "Motor Data"};

Widget placeholder(context) {
  return Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40), // if you need this
      side: BorderSide(
        color: Colors.grey.withOpacity(0.2),
        width: 1,
      ),
    ),
    child: Container(
      color: Colors.white,
      width: 200,
      height: 200,
      child: Column(
        children: <Widget>[
          Text(
            titleList.toString(),
          ),
          const Spacer(),
          Text(something.toString()),
        ],
      ),
    ),
  );
}

List<Map<String, dynamic>> something = [
  {
    "Firmware Version": true,
    "Modbus Connection Status": " Connected",
    "E Stop Engaged: ": true
  },
  {"Placeholder": "Lorem epsum", "Something 1": "Lorem epsum 2"}
];
