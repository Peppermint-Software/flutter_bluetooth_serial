import 'package:flutter/cupertino.dart';
import 'package:sliding_switch/sliding_switch.dart';

class ForwardReverseButton extends StatefulWidget {
  const ForwardReverseButton({Key? key}) : super(key: key);

  @override
  _ForwardReverseButtonState createState() => _ForwardReverseButtonState();
}

class _ForwardReverseButtonState extends State<ForwardReverseButton> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // const Text(
      //   'F',
      //   style: TextStyle(fontStyle: FontStyle.normal, fontSize: 19),
      // ),
      RotatedBox(
        quarterTurns: 1,
        child: SlidingSwitch(
          value: false,
          width: 180,
          onChanged: (bool value) {},
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
      // const Text('R',
      //     style: TextStyle(fontStyle: FontStyle.normal, fontSize: 19)),
    ]);
  }
}
