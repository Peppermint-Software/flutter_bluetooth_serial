import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Obstacle extends StatefulWidget {
  const Obstacle({Key? key}) : super(key: key);

  @override
  _ObstacleState createState() => _ObstacleState();
}

class _ObstacleState extends State<Obstacle> {
  @override
  Widget build(BuildContext context) {
    var model;
    return Column(
      children: [
        Ink(
          decoration: const ShapeDecoration(
            color: Colors.yellow,
            shape: CircleBorder(),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.circle,
              color: Colors.deepOrange,
            ),
            iconSize: 80,
            color: Colors.white,
            onPressed: () {
              setState(() {});
            },
          ),
        ),
      ],
    );
  }
}
