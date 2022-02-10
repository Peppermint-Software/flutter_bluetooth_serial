import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'forward_reverse_button.dart';

// class SpeedController extends StatelessWidget {
//   const SpeedController({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return  SpeedControllerWidget();
//   }
// }

class Model {
  ValueNotifier<bool> isDirty = ValueNotifier<bool>(false);
  ValueNotifier<int> data = ValueNotifier<int>(0);

  int save() {
    if (isDirty.value) {
      isDirty.value = false;
    }
    return data.value;
  }

  setValue(int newValue) {
    isDirty.value = data.value != newValue;
    data.value = newValue;
    return newValue;
  }
}

class ModifyIntent extends Intent {
  const ModifyIntent(this.value);

  final int value;
}

class ModifyAction extends Action<ModifyIntent> {
  ModifyAction(this.model);

  final Model model;

  @override
  void invoke(covariant ModifyIntent intent) {
    model.setValue(intent.value);
  }
}

class SaveIntent extends Intent {
  const SaveIntent();
}

class SaveAction extends Action<SaveIntent> {
  SaveAction(this.model);

  final Model model;

  @override
  int invoke(covariant SaveIntent intent) => model.save();
}

class SaveButton extends StatefulWidget {
  const SaveButton(
      {Key? key, required this.valueNotifier, required this.magnitude})
      : super(key: key);

  final ValueNotifier<bool> valueNotifier;
  final int magnitude;
  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton> {
  int savedValue = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.valueNotifier,
      builder: (BuildContext context, Widget? child) {
        return TextButton.icon(
          icon: const Icon(
            Icons.lock,
            size: 30,
          ),
          label: /*Text('$savedValue')*/ const Text(""),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              widget.valueNotifier.value ? Colors.red : Colors.green,
            ),
          ),
          onPressed: () {
            setState(() {
              savedValue = Actions.invoke(context, const SaveIntent())! as int;
            });
          },
        );
      },
    );
  }
}

class SpeedControllerWidget extends StatefulWidget {
  @override
  State<SpeedControllerWidget> createState() => _SpeedControllerWidgetState();
}

class _SpeedControllerWidgetState extends State<SpeedControllerWidget> {
  int count = 0;
  Timer? _timer;
  int weight = 0;
  int magnitude = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(width: 10),
              GestureDetector(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  width: 40,
                  height: 40,
                  child: const Center(
                    child: Icon(
                      Icons.add,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    weight++;
                  });
                },
                onTapDown: (TapDownDetails details) {
                  _timer =
                      Timer.periodic(const Duration(milliseconds: 100), (t) {
                    setState(() {
                      weight++;
                    });
                  });
                },
                onTapUp: (TapUpDetails details) {
                  _timer!.cancel();
                },
                onTapCancel: () {
                  _timer!.cancel();
                },
              ),
              Text(
                "$weight",
                style: const TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.bold,
                  fontSize: 30.0,
                ),
              ),
              // this.widget.callback(weight),
              GestureDetector(
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  width: 40,
                  height: 40,
                  child: Center(
                    child: Container(
                      color: Colors.white,
                      width: 20,
                      height: 5.0,
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    if (weight > 0) weight--;
                  });
                },
                onTapDown: (TapDownDetails details) {
                  _timer =
                      Timer.periodic(const Duration(milliseconds: 100), (t) {
                    setState(() {
                      if (weight > 0) weight--;
                    });
                  });
                },
                onTapUp: (TapUpDetails details) {
                  _timer!.cancel();
                },
                onTapCancel: () {
                  _timer!.cancel();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
