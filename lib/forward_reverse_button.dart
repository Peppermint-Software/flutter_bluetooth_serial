import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter/services.dart';

class ForwardReverseButton extends StatefulWidget {
  const ForwardReverseButton({Key? key}) : super(key: key);

  @override
  ForwardReverseButtonState createState() => ForwardReverseButtonState();
}

class ForwardReverseButtonState extends State<ForwardReverseButton> {
  @override
  Widget build(BuildContext context) {
    bool _btnState = false;

    return Column(children: [
      RotatedBox(
        quarterTurns: 1,
        child: SlidingSwitch(
          value: _btnState,
          width: 180,
          onChanged: (value) => setState(() {
            String _frwCmd = "MOONS+F;";
            String _revCmd = "MOONS+R;";
            _btnState = value;
            HapticFeedback.vibrate();

            value == true ? command(_revCmd) : command(_frwCmd);
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
