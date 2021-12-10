import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remote_control/controller_widgets/speed_controller_buttons.dart';
import 'package:remote_control/controller_widgets/virtual_joystick.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'detail_widgets/robot_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//Limitations of setPrefferedOrientation
// This setting will only be respected on iPad if multitasking is disabled.You can decide to opt out of multitasking on iPad,
//then setPreferredOrientations will work but your app will not support Slide Over and Split View multitasking anymore.
// Should you decide to opt out of multitasking you can do this by setting "Requires full screen" to true in the Xcode Deployment Info.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    return MaterialApp(
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(title: 'Add icon here'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            textAlign: TextAlign.center,
          ),
        ),
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
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.all(2),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  fixedSize: const Size(100, 50),
                                  textStyle: const TextStyle(fontSize: 15)),
                              onPressed: () {
                                _showRobotList(context);
                              },
                              child: const Text("Machines")))
                    ])),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const <Widget>[
                    SpeedControllerWidget(),
                    Obstacle(),
                    ForwardReverseButton(),
                  ],
                ),
                const OnOffButton()
              ],
            ),
            //Joystick components here
            const Align(
                child:
                    AspectRatio(aspectRatio: 0.6, child: JoystickAreaExample()),
                alignment: Alignment.center)
          ],
        ));
  }
}

class Widget2 extends StatefulWidget {
  const Widget2({Key? key}) : super(key: key);

  @override
  _Widget2State createState() => _Widget2State();
}

class _Widget2State extends State<Widget2> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        child: RotatedBox(
            quarterTurns: 1,
            child: ToggleSwitch(
              minWidth: 90.0,
              cornerRadius: 20.0,
              activeBgColors: [
                [Colors.green[800]!],
                [Colors.red[800]!]
              ],
              activeFgColor: Colors.white,
              inactiveBgColor: Colors.grey,
              inactiveFgColor: Colors.white,
              initialLabelIndex: 1,
              totalSwitches: 2,
              radiusStyle: true,
              onToggle: (index) {
                print('switched to: $index');
              },
              icons: const [
                Icons.chevron_left_rounded,
                Icons.chevron_right_rounded
              ],
              iconSize: 50,
            )));
  }
}

class Obstacle extends StatefulWidget {
  const Obstacle({Key? key}) : super(key: key);

  @override
  _ObstacleState createState() => _ObstacleState();
}

class _ObstacleState extends State<Obstacle> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30),
        child:
            // ElevatedButton(
            //   style: ElevatedButton.styleFrom(
            //       shape: const CircleBorder(), padding: const EdgeInsets.all(30)),
            //   child: const Icon(
            //     Icons.add,
            //     size: 50,
            //   ),
            //   onPressed: () {},
            // )
            Ink(
          decoration: const ShapeDecoration(
            color: Colors.blue,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.circle,
              color: Colors.deepOrange,
            ),
            iconSize: 80,
            color: Colors.white,
            onPressed: () {
              setState(() {
                // _isBluetoothOn = !_isBluetoothOn;
              });
            },
          ),
        ));
  }
}

class OnOffButton extends StatefulWidget {
  const OnOffButton({Key? key}) : super(key: key);

  @override
  _OnOffButtonState createState() => _OnOffButtonState();
}

class _OnOffButtonState extends State<OnOffButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      // height: 50,
      // width: 100,
      padding: const EdgeInsets.all(8),
      child:
          //  OutlinedButton(
          //   child: const Text('ON/OFF'),
          //   onPressed: () {},
          // )
          SlidingSwitch(
        value: false,
        width: 150,
        onChanged: (bool value) {
          print(value);
        },
        height: 40,
        animationDuration: const Duration(milliseconds: 400),
        onTap: () {},
        onDoubleTap: () {},
        onSwipe: () {},
        textOff: "OFF",
        textOn: "ON",
        colorOn: const Color(0xffdc6c73),
        colorOff: const Color(0xff6682c0),
        background: const Color(0xffe4e5eb),
        buttonColor: const Color(0xfff7f5f7),
        inactiveColor: const Color(0xff636f7b),
      ),
    );
  }
}

class ForwardReverseButton extends StatefulWidget {
  const ForwardReverseButton({Key? key}) : super(key: key);

  @override
  _ForwardReverseButtonState createState() => _ForwardReverseButtonState();
}

class _ForwardReverseButtonState extends State<ForwardReverseButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        // height: 50,
        // width: 100,
        padding: const EdgeInsets.all(15),
        child:
            //  OutlinedButton(
            //   child: const Text('ON/OFF'),
            //   onPressed: () {},
            // )
            RotatedBox(
          quarterTurns: 1,
          child: SlidingSwitch(
            value: false,
            width: 150,
            onChanged: (bool value) {
              print(value);
            },
            height: 55,
            animationDuration: const Duration(milliseconds: 400),
            onTap: () {},
            onDoubleTap: () {},
            onSwipe: () {},
            textOff: "<-",
            textOn: "->",
            colorOn: const Color(0xffdc6c73),
            colorOff: const Color(0xff6682c0),
            background: const Color(0xffe4e5eb),
            buttonColor: const Color(0xfff7f5f7),
            inactiveColor: const Color(0xff636f7b),
          ),
        ));
  }
}

_showRobotList(BuildContext context) {
  return showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return SizedBox(
          child: AlertDialog(
              insetPadding: const EdgeInsets.all(5),
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("CANCEL"),
                )
              ],
              title: const Text(
                "Robots List",
                textAlign: TextAlign.center,
              ),
              content:
                  const SizedBox(height: 100, width: 350, child: RobotList())));
    },
  );
}
