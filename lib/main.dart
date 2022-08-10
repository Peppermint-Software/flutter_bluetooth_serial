import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peppermintrc/remoteControl/remoteControl.dart';

void main() => runApp(const PeppermintRemote());

class PeppermintRemote extends StatelessWidget {
  const PeppermintRemote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return const MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          home: RemoteControl(),
        ));
  }
}
