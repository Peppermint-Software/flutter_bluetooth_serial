import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_joystick/flutter_joystick.dart';

class JoystickAreaExample extends StatefulWidget {
  const JoystickAreaExample({Key? key}) : super(key: key);

  @override
  _JoystickAreaExampleState createState() => _JoystickAreaExampleState();
}

class _JoystickAreaExampleState extends State<JoystickAreaExample> {
  static const ballSize = 20.0;
  static const step = 10.0;
  double _x = 100;
  double _y = 100;
  JoystickMode _joystickMode = JoystickMode.all;

  @override
  void didChangeDependencies() {
    _x = MediaQuery.of(context).size.width / 2 - ballSize / 2;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2),
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: Colors.white10,
            title: const Text(
              'Connection',
              textAlign: TextAlign.left,
            ),
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
              initialJoystickAlignment: const Alignment(0, 0.8),
              listener: (details) {
                setState(() {
                  _x = _x + step * details.x;
                  _y = _y + step * details.y;
                });
              },
              // child: Stack(
              //   children: [
              //     Container(
              //       color: Colors.blueGrey,
              //     ),
              //     Ball(_x, _y),
              //   ],
              // ),
            ),
          ),
        ));
  }
}

// class Ball extends StatelessWidget {
//   static const ballSize = 20.0;
//   static const step = 10.0;
//   final double x;
//   final double y;

//   const Ball(this.x, this.y, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Positioned(
//       left: x,
//       top: y,
//       child: Container(
//         width: ballSize,
//         height: ballSize,
//         decoration: const BoxDecoration(
//           shape: BoxShape.circle,
//           color: Colors.redAccent,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               spreadRadius: 2,
//               blurRadius: 3,
//               offset: Offset(0, 3),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

class JoystickModeDropdown extends StatelessWidget {
  final JoystickMode mode;
  final ValueChanged<JoystickMode> onChanged;

  const JoystickModeDropdown(
      {Key? key, required this.mode, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: double.minPositive,
      width: double.minPositive,
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
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
    );
  }
}
