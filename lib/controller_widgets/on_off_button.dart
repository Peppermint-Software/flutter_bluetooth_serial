import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class OnOffButton extends StatefulWidget {
  const OnOffButton({Key? key}) : super(key: key);

  @override
  _OnOffButtonState createState() => _OnOffButtonState();
}

class _OnOffButtonState extends State<OnOffButton> {
  void _sendOnMessageToBluetooth1() async {
    var connection;
    connection.output.add(ascii.encode("Z"));
    await connection.output.allSent;
    show('Device Turned On');
    setState(() {});
  }

  Future show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.all(5),
      child: SlidingSwitch(
        value: false,
        width: 150,
        onChanged: (bool value) {},
        height: 40,
        animationDuration: const Duration(milliseconds: 40),
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
