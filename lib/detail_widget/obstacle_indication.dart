import 'package:flutter/material.dart';

class Obstacle extends StatefulWidget {
  const Obstacle({Key? key}) : super(key: key);

  @override
  _ObstacleState createState() => _ObstacleState();
}

class _ObstacleState extends State<Obstacle> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
            decoration: const ShapeDecoration(
              color: Colors.lightGreen,
              shape: CircleBorder(),
            ),
            child: Text("hello"))
      ],
    );
  }
}
