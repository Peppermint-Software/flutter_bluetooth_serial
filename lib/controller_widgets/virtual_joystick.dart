import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class JoystickAreaExample extends StatefulWidget {
  const JoystickAreaExample({Key? key}) : super(key: key);

  @override
  _JoystickAreaExampleState createState() => _JoystickAreaExampleState();
}

enum Status { connected, disconnected }

class _JoystickAreaExampleState extends State<JoystickAreaExample> {
  static const ballSize = 20.0;
  static const step = 10.0;
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;
  double _signalStrength = 0.0;

  void _changeValue(double value) {
    setState(() {
      _signalStrength = value;
    });
  }

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  String dropdownValue = 'SD40001';
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(4),
        child: Scaffold(
          appBar: AppBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(360)),
            leading: const Positioned.fill(
                child: Icon(
              Icons.circle,
              color: Colors.green,
              size: 15,
            )),
            elevation: 1,
            backgroundColor: Colors.white10,
            title: Text('Connection :   $dropdownValue',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  fontSize: 15,
                )),
            titleSpacing: 00.0,
            actions: [
              JoystickModeDropdown(
                mode: _joystickMode,
                onChanged: (JoystickMode value) {
                  setState(() {
                    _joystickMode = value;
                  });
                },
              ),
            ],
          ),
          body: SafeArea(
            maintainBottomViewPadding: true,
            child: JoystickArea(
              mode: _joystickMode,
              initialJoystickAlignment: Alignment.center,
              listener: (details) {
                setState(() {
                  _x = _x + step * details.x;
                  _y = _y + step * details.y;
                });
              },
            ),
          ),
        ));
  }
}

class JoystickModeDropdown extends StatelessWidget {
  final JoystickMode mode;
  final ValueChanged<JoystickMode> onChanged;

  const JoystickModeDropdown(
      {Key? key, required this.mode, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: double.minPositive,
      width: double.minPositive,
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: FittedBox(
          child: DropdownButton(
            value: mode,
            onChanged: (v) {
              onChanged(v as JoystickMode);
            },
            items: const [
              DropdownMenuItem(
                  child: Text('All Directions'), value: JoystickMode.all),
              DropdownMenuItem(
                  child: Text('Vertical And Horizontal'),
                  value: JoystickMode.horizontalAndVertical),
              DropdownMenuItem(
                  child: Text('Horizontal'), value: JoystickMode.horizontal),
              DropdownMenuItem(
                  child: Text('Vertical'), value: JoystickMode.vertical),
            ],
          ),
        ),
      ),
    ));
  }
}
