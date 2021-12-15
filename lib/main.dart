import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:remote_control/controller_widgets/forward_reverse_button.dart';
import 'package:remote_control/controller_widgets/speed_controller_buttons.dart';
import 'package:remote_control/controller_widgets/virtual_joystick.dart';
import 'package:remote_control/detail_widgets/obstacle_indication.dart';
// import 'package:assets/icons/peppermint_icon_icons.dart';
import 'detail_widgets/robot_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const BtRemoteControl(
        title: '',
      ),
    );
  }
}

class BtRemoteControl extends StatefulWidget {
  const BtRemoteControl({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<BtRemoteControl> createState() => _BtRemoteControlState();
}

class _BtRemoteControlState extends State<BtRemoteControl> {
  late bool _lights = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(30),
            child: AppBar(
              actions: const <Widget>[],
              elevation: 9,
              title: Text(
                widget.title,
                textAlign: TextAlign.center,
              ),
            )),
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Container(
                          margin: const EdgeInsets.all(10),
                          height: 60,
                          width: 160,
                          padding: const EdgeInsets.all(8),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  fixedSize: const Size(100, 40),
                                  textStyle: const TextStyle(fontSize: 15)),
                              onPressed: () {
                                _showRobotList(context);
                              },
                              child: const Text(
                                "Machines",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.start,
                              )))
                    ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const <Widget>[
                    SpeedControllerWidget(),
                    Padding(padding: EdgeInsets.all(20), child: Obstacle()),
                    ForwardReverseButton(),
                  ],
                ),
                // const OnOffButton()
                SwitchListTile(
                  title: const Text('Lights'),
                  value: _lights,
                  onChanged: (bool value) {
                    setState(() {
                      _lights = value;
                    });
                  },
                  secondary: const Icon(Icons.lightbulb_outline),
                )
              ],
            ),
            const Align(
                child:
                    AspectRatio(aspectRatio: 0.7, child: JoystickWorkingArea()),
                alignment: Alignment.center)
          ],
        ));
  }
}

_showRobotList(BuildContext context) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return const SizedBox(
          child: AlertDialog(
              insetPadding: EdgeInsets.all(2),
              title: Text(
                "Robots List",
                textAlign: TextAlign.center,
              ),
              content: SizedBox(height: 320, width: 200, child: RobotList())));
    },
  );
}
