import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:peppermintrc/bluetooth.dart';

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
