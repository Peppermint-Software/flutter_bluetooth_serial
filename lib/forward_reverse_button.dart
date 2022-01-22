import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:test/main.dart';
import 'package:flutter/services.dart';

class ForwardReverseButton extends StatefulWidget {
  const ForwardReverseButton(buildContext, {Key? key}) : super(key: key);

  @override
  ForwardReverseButtonState createState() => ForwardReverseButtonState();
}

class ForwardReverseButtonState extends State<ForwardReverseButton> {
  @override
  Widget build(BuildContext context) {
    bool _value1 = true;
    BluetoothConnection? connection;
    return Column(children: [
      RotatedBox(
        quarterTurns: 1,
        child: SlidingSwitch(
          value: _value1,
          width: 180,
          onChanged: (value) => setState(() {
            String c1 = "MOONS+F;";
            String c2 = "MOONS+R;";
            _value1 = value;

            _value1 ? _repeatCmd(100, c2) : _repeatCmd(100, c1);
          }),
          height: 50,
          animationDuration: const Duration(milliseconds: 40),
          onTap: () {},
          onDoubleTap: () {},
          onSwipe: () {},
          textOff: '+',
          textOn: '|',
          colorOn: const Color(0xffdd2c00),
          colorOff: const Color(0xff64dd17),
          background: const Color(0xffe4e5eb),
          buttonColor: const Color(0xfff7f5f7),
          inactiveColor: const Color(0xff636f7b),
        ),
      ),
    ]);
  }
}

Future command(String data) async {
  List<int> x = List<int>.from(ascii.encode(data));

  String result = const AsciiDecoder().convert(x);
  print(result);
  BluetoothConnection? connection;
  if (connection != null) {
    connection.output.add(ascii.encoder.convert(result));

    await connection.output.allSent;
  }
}

_repeatCmd(int millisec, String cmd) {
  Timer.periodic(Duration(milliseconds: millisec), (Timer t) => command(cmd));
}
