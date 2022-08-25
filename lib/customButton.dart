import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);
  final GestureTapCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      backgroundColor: Colors.black,
      radius: 46,
      child: CircleAvatar(
          radius: 50, backgroundImage: AssetImage('asset/onOffbuttonpng')),
    );
  }
}
