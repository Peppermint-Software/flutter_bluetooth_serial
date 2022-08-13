import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peppermintapp/remoteControl/remoteControl.dart';

void main() => runApp(const PeppermintRemote());

class PeppermintRemote extends StatelessWidget {
  const PeppermintRemote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const RemoteControl();
}
