import 'package:flutter/material.dart';
import 'package:peppermintrc/remoteControl/globals.dart';

class SpeedLimiter extends StatefulWidget {
  const SpeedLimiter({Key? key}) : super(key: key);

  @override
  State<SpeedLimiter> createState() => _SpeedLimiterState();
}

class ModifyIntent extends Intent {
  const ModifyIntent(this.value);

  final double value;
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

class SaveButton extends StatefulWidget {
  const SaveButton(this.valueNotifier, {Key? key}) : super(key: key);

  final ValueNotifier<bool> valueNotifier;

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SpeedLimiterState extends State<SpeedLimiter> {
  Model model = Model();
  double count = 0;

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  IconButton(
                    color: Colors.grey,
                    iconSize: 40,
                    icon: const Icon(Icons.add_circle_sharp),
                    onPressed: () {
                      Actions.invoke(context, ModifyIntent(count += 10));
                    },
                  ),
                  AnimatedBuilder(
                      animation: model.data,
                      builder: (BuildContext context, Widget? child) {
                        return Padding(
                          padding: const EdgeInsets.all(1),
                          child: Text(model.data.value.toString(),
                              style: Theme.of(context).textTheme.headlineSmall),
                        );
                      }),
                  SaveButton(model.isDirty),
                  IconButton(
                    color: Colors.grey,
                    iconSize: 40,
                    icon: const Icon(Icons.remove_circle_sharp),
                    onPressed: () {
                      Actions.invoke(context, ModifyIntent(count -= 10));
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

class Model {
  static Model? _instance1;
  ValueNotifier<bool> isDirty = ValueNotifier<bool>(false);
  ValueNotifier<double> data = ValueNotifier<double>(0);

  Model._internal1() {
    _instance1 = this;
  }
  factory Model() => _instance1 ?? Model._internal1();

  double save() {
    if (isDirty.value) {
      isDirty.value = false;

      GlobalSingleton().command("MOONS+SL${data.value.toInt()};");
    }
    return data.value;
  }

  void setValue(double newValue) {
    isDirty.value = data.value != newValue;
    data.value = newValue;
  }
}

// An Action that saves the data in the model it is created with.

class SaveAction extends Action<SaveIntent> {
  SaveAction(this.model);

  final Model model;

  @override
  double invoke(covariant SaveIntent intent) => model.save();
}

class _SaveButtonState extends State<SaveButton> {
  double savedValue = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.valueNotifier,
      builder: (BuildContext context, Widget? child) {
        return TextButton.icon(
          autofocus: true,
          icon: const Icon(Icons.check_circle),
          label: Text('$savedValue'),
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(
              widget.valueNotifier.value ? Colors.red : Colors.green,
            ),
          ),
          onPressed: () {
            setState(() {
              savedValue =
                  Actions.invoke(context, const SaveIntent())! as double;
            });
          },
        );
      },
    );
  }
}
