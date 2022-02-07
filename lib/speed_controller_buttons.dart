import 'dart:async';
import 'dart:developer';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'forward_reverse_button.dart';

class SpeedController extends StatelessWidget {
  const SpeedController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedControllerWidget();
  }
}

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
  const SaveButton(this.valueNotifier, {Key? key}) : super(key: key);

  final ValueNotifier<bool> valueNotifier;

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
          label: /*Text('$savedValue')*/ Text(''),
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
  const SpeedControllerWidget({Key? key}) : super(key: key);
  @override
  State<SpeedControllerWidget> createState() => _SpeedControllerWidgetState();
}

class _SpeedControllerWidgetState extends State<SpeedControllerWidget> {
  Model model = Model();
  int count = 0;
  Timer? _timer;

  @override
  Widget build(BuildContext context) {
    return Actions(
      actions: <Type, Action<Intent>>{
        ModifyIntent: ModifyAction(model),
        SaveIntent: SaveAction(model),
      },
      child: Builder(
        builder: (BuildContext context) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(5),
                          primary: Colors.white,
                          onPrimary: Colors.green[50],
                        ),
                        child: const Icon(
                          Icons.add_outlined,
                          size: 45,
                          color: Colors.grey,
                        ),
                        onPressed: () {}

                        //   Actions.invoke(context, ModifyIntent(++count));
                        //   model.data.value < 0
                        //       ? null
                        //       : command("MOONS+SL${model.data.value};");
                        // },
                        ),
                    onTap: () {
                      setState(() {
                        Actions.invoke(context, ModifyIntent(++count));
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      _timer = Timer.periodic(const Duration(milliseconds: 100),
                          (t) {
                        setState(() {
                          Actions.invoke(context, ModifyIntent(++count));
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
                  AnimatedBuilder(
                      animation: model.data,
                      builder: (BuildContext context, Widget? child) {
                        return Padding(
                            padding: const EdgeInsets.all(3),
                            child: Text(
                                '${model.data.value < 0 ? model.data.value = 0 : model.data.value}',
                                style: Theme.of(context).textTheme.headline6));
                      }),
                  SaveButton(model.isDirty),
                  GestureDetector(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(2),
                            primary: Colors.white,
                            onPrimary: Colors.green[50]),
                        child: const Icon(Icons.remove_outlined,
                            size: 50, color: Colors.grey),
                        onPressed: () {
                          // Actions.invoke(context, ModifyIntent(--count));
                          // model.data.value < 0
                          //     ? null
                          //     : command("MOONS+SL${model.data.value};");
                        }),
                    onTap: () {
                      setState(() {
                        Actions.invoke(context, ModifyIntent(--count));
                      });
                    },
                    onTapDown: (TapDownDetails details) {
                      _timer = Timer.periodic(const Duration(milliseconds: 100),
                          (t) {
                        setState(() {
                          Actions.invoke(context, ModifyIntent(--count));
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
          );
        },
      ),
    );
  }
}
