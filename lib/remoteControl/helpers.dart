import 'package:flutter/material.dart';
import 'package:peppermintapp/remoteControl/remoteControl.dart';

bool get isConnected => connection != null && connection!.isConnected;

class Icon_placeHolder extends StatefulWidget {
  const Icon_placeHolder({Key? key}) : super(key: key);

  @override
  State<Icon_placeHolder> createState() => _Icon_placeHolderState();
}

class _Icon_placeHolderState extends State<Icon_placeHolder> {
  @override
  Widget build(BuildContext context) {
    return Container(child: const Text('Icon_placeHolder'));
  }
}
