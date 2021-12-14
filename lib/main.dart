import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remote_control/controller_widgets/speed_controller_buttons.dart';
import 'package:remote_control/controller_widgets/virtual_joystick.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:toggle_switch/toggle_switch.dart';
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
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(
        title: '',
      ),
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
                const OnOffButton()
              ],
            ),
            const Align(
                child:
                    AspectRatio(aspectRatio: 0.7, child: JoystickAreaExample()),
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
    var model;
    return Column(
      children: [
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.yellow,
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
              setState(() {});
            },
          ),
        ),
      ],
    );
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
      padding: const EdgeInsets.all(8),
      child: SlidingSwitch(
        value: false,
        width: 150,
        onChanged: (bool value) {},
        height: 40,
        animationDuration: const Duration(milliseconds: 100),
        onTap: () {},
        onDoubleTap: () {},
        onSwipe: () {},
        textOff: "OFF",
        textOn: "ON",
        colorOn: const Color(0xff64dd17),
        colorOff: const Color(0xffdd2c00),
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
        width: 100,
        padding: const EdgeInsets.all(15),
        child: RotatedBox(
          quarterTurns: 1,
          child: SlidingSwitch(
            value: false,
            width: 180,
            onChanged: (bool value) {
              print(value);
            },
            height: 50,
            animationDuration: const Duration(milliseconds: 100),
            onTap: () {},
            onDoubleTap: () {},
            onSwipe: () {},
            textOff: "<",
            textOn: ">",
            colorOn: const Color(0xffdd2c00),
            colorOff: const Color(0xff64dd17),
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
