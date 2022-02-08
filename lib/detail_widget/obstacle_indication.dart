// import 'package:flutter/material.dart';
// import 'package:peppermintrc/main.dart';

// void main() => runApp(const Obstacle());

// class Obstacle extends StatefulWidget {
//   const Obstacle({Key? key}) : super(key: key);

//   @override
//   _ObstacleState createState() => _ObstacleState();
// }

// class _ObstacleState extends State<Obstacle> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Ink(
//             decoration: const ShapeDecoration(
//               color: Colors.white38,
//               shape: CircleBorder(),
//             ),
//             child: Image(
//                 color: connection != null && connection!.isConnected
//                     ? Colors.teal.shade300
//                     : Colors.grey.shade400,
//                 image: const AssetImage("asset/peppermint_leaf_only.png"))),
//       ],
//     );
//   }
// }
