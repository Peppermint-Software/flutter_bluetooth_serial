import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:remote_control/controller_widgets/forward_reverse_button.dart';
import 'package:remote_control/controller_widgets/on_off_button.dart';
import 'package:remote_control/controller_widgets/speed_controller_buttons.dart';
import 'package:remote_control/controller_widgets/virtual_joystick.dart';
import 'package:remote_control/detail_widgets/obstacle_indication.dart';
// import 'package:assets/icons/peppermint_icon_icons.dart';
import 'detail_widgets/robot_list.dart';

void main() => runApp(const BTAppVersionPointTwo());

class BTAppVersionPointTwo extends StatelessWidget {
  const BTAppVersionPointTwo({Key? key}) : super(key: key);

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
  bool _lights = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            //commented to be used in edge cases test of the UI

            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,

            Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 23, horizontal: 10),
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
                    ))),
            Row(
              //commented to be used in edge cases test of the UI

              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: const <Widget>[
                Padding(
                    padding: EdgeInsets.all(15),
                    child: SpeedControllerWidget()),
                Padding(padding: EdgeInsets.all(20), child: Obstacle()),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: ForwardReverseButton(),
                )
              ],
            ),
            const OnOffButton(),
          ],
        ),
        const Expanded(
            child: Align(
                child:
                    AspectRatio(aspectRatio: 0.7, child: JoystickWorkingArea()),
                alignment: Alignment.topCenter))
      ],
    ));
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
          children: [SizedBox(height: 320, width: 150, child: RobotList())]);
    },
  );
}
