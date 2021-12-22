import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:remote_control/controller_widgets/forward_reverse_button.dart';
import 'package:remote_control/controller_widgets/on_off_button.dart';
import 'package:remote_control/controller_widgets/speed_controller_buttons.dart';
import 'package:remote_control/controller_widgets/virtual_joystick.dart';
import 'package:remote_control/detail_widgets/obstacle_indication.dart';

import 'detail_widgets/robot_list.dart';

void main() => runApp(const PeppermintRemote());

class PeppermintRemote extends StatelessWidget {
  const PeppermintRemote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: RemoteControl(
            title: '',
          ),
        ));
  }
}

class RemoteControl extends StatefulWidget {
  const RemoteControl({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<RemoteControl> createState() => _RemoteControlState();
}

class _RemoteControlState extends State<RemoteControl> {
  bool _lights = false;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            body: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 19, horizontal: 10),
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
                      textAlign: TextAlign.center,
                    ))),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SpeedControllerWidget()),
                Padding(padding: EdgeInsets.all(15), child: Obstacle()),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 15,
                  ),
                  child: ForwardReverseButton(),
                )
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2, horizontal: 9),
              child: OnOffButton(),
            )
          ],
        ),
        Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              SizedBox(
                height: 300,
                width: 250,
                child: JoystickExampleApp(),
              )
            ])
      ],
    )));
  }
}

_showRobotList(BuildContext context) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return const SimpleDialog(
          insetPadding: EdgeInsets.all(2),
          title: Text(
            'Robot List',
            textAlign: TextAlign.center,
          ),
          children: [
            SizedBox(
              height: 100,
              width: 100,
              child: BluetoothApp(),
            ),
          ]);
    },
  );
}
