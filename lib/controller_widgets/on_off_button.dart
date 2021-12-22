import 'package:flutter/cupertino.dart';
import 'package:sliding_switch/sliding_switch.dart';

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
