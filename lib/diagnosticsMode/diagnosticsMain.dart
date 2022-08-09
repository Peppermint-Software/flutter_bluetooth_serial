import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
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
                              content: contentHeader[index].forEach((element) => element.value),
                              showAccordion: true,
                              contentPadding: const EdgeInsets.all(8),
                              title: titleList[index],
                            ))),
              ]))));
}

var titleList = {0: "General Info", 1: "Cleaning Data", 2: "Motor Data"};

var contentHeader = {
  titleList[0]: [
    "Firmware Version:",
    "Modebus connection Status: ",
    "E-Stop Engaged: ",
    "Smart Ignition Status:"
  ],
  titleList[1]: {},
  titleList[3]: {},
};

Widget ClassName(BuildContext context, index) => Card(
        // clipBehavior: Clip.antiAlias,
        child: Column(
      mainAxisAlignment: MainAxisAlignment.,
      mainAxisSize: MainAxisSize.min,
      children: [
        ListBody(children: const [
          Text(
            "Class name: ",
          ),
          Spacer(),
          Text("Widget name: "),
          Text("Widget name: "),
          Spacer(),
          Text("Widget name: "),
          Spacer(),
          Text("Widget name: "),
          Spacer(),
          Text("Widget name: "),
          Text("Widget name: "),
        ])
      ],
    ));
