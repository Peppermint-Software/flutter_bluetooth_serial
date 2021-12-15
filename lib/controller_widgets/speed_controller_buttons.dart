import 'package:flutter/material.dart';

class SpeedController extends StatelessWidget {
  const SpeedController({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SpeedControllerWidget();
  }
}

// A simple model class that notifies listeners when it changes.
class Model {
  ValueNotifier<bool> isDirty = ValueNotifier<bool>(false);
  ValueNotifier<int> data = ValueNotifier<int>(0);

  int save() {
    if (isDirty.value) {
      debugPrint('Saved Data: ${data.value}');
      isDirty.value = false;
    }
    return data.value;
  }

  void setValue(int newValue) {
    isDirty.value = data.value != newValue;
    data.value = newValue;
  }
}

class ModifyIntent extends Intent {
  const ModifyIntent(this.value);

  final int value;
}

// An Action that modifies the model by setting it to the value that it gets
// from the Intent passed to it when invoked.
class ModifyAction extends Action<ModifyIntent> {
  ModifyAction(this.model);

  final Model model;

  @override
  void invoke(covariant ModifyIntent intent) {
    model.setValue(intent.value);
  }
}

// An intent for saving data.
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
            size: 40,
          ),
          label: Text('$savedValue'),
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      primary: Colors.white,
                      onPrimary: Colors.green[50],
                    ),
                    child: const Icon(
                      Icons.add_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      Actions.invoke(context, ModifyIntent(++count));
                    },
                  ),
                  AnimatedBuilder(
                      animation: model.data,
                      builder: (BuildContext context, Widget? child) {
                        return Padding(
                            padding: const EdgeInsets.all(2),
                            child: Text('${model.data.value}',
                                style: Theme.of(context).textTheme.headline4));
                      }),
                  const Text('m/s'),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(10),
                        primary: Colors.white,
                        onPrimary: Colors.green[50]),
                    child: const Icon(Icons.remove_outlined,
                        size: 40, color: Colors.grey),
                    onPressed: () {
                      Actions.invoke(context, ModifyIntent(--count));
                    },
                  ),
                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.end,
                  //     children: [SaveButton(model.isDirty)]),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
