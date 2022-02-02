import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter/services.dart';

class ForwardReverseButton extends StatefulWidget {
  const ForwardReverseButton(buildContext, {Key? key}) : super(key: key);

  @override
  ForwardReverseButtonState createState() => ForwardReverseButtonState();
}

class ForwardReverseButtonState extends State<ForwardReverseButton> {
  @override
  Widget build(BuildContext context) {
    bool _value = false;
    return Column(children: [
      RotatedBox(
        quarterTurns: 1,
        child: SlidingSwitch(
          value: _value,
          width: 180,
          onChanged: (value) => setState(() {
            String c1 = "MOONS+F;";
            String c2 = "MOONS+R;";
            _value = value;
            HapticFeedback.heavyImpact();

            _value
                ? {command(c2), command(c2), command(c2)}
                : {command(c1), command(c1), command(c1)};
          }),
          height: 50,
          animationDuration: const Duration(milliseconds: 10),
          onTap: () {},
          onDoubleTap: () {},
          onSwipe: () {},
          textOff: '<',
          textOn: '>',
          colorOn: Colors.lightGreenAccent.shade700,
          colorOff: Colors.deepOrangeAccent.shade700,
          background: Colors.grey.shade300,
          buttonColor: Colors.white,
          inactiveColor: Colors.grey,
        ),
      ),
    ]);
  }
}

Future command(String data) async {
  List<int> x = List<int>.from(ascii.encode(data));

  String result = const AsciiDecoder().convert(x);
  BluetoothConnection? connection;
  if (connection != null) {
    connection.output.add(ascii.encoder.convert(result));

    await connection.output.allSent;
  }
}
