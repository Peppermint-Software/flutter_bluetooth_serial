// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:peppermintapp/remoteControl/globals.dart';

// class ForwardReverse extends StatefulWidget {
//   const ForwardReverse({Key? key}) : super(key: key);

//   @override
//   State<ForwardReverse> createState() => _ForwardReverseState();
// }

// class _ForwardReverseState extends State<ForwardReverse> {
//   late bool frswap;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       mainAxisAlignment: MainAxisAlignment.spaceAround,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: <Widget>[

//         ElevatedButton(
//           onPressed: () {
//             setState(() {
//               frswap = true;
//               GlobalSingleton().command(GlobalSingleton().fwdCmd);
//             });
//           },
//           style: ElevatedButton.styleFrom(
//             primary: frswap
//                 ? const Color.fromARGB(255, 76, 175, 80)
//                 : const Color.fromARGB(255, 158, 158, 158),
//             shape: const CircleBorder(),
//             shadowColor: Colors.black12,
//             padding: const EdgeInsets.all(10),
//           ),
//           child: const Text(
//             "F",
//             style: TextStyle(color: Colors.white, fontSize: 15),
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(top: 80, bottom: 0),
//           child: ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 frswap = false;
//                 GlobalSingleton().command(GlobalSingleton().revCmd);
//               });
//             },
//             style: ElevatedButton.styleFrom(
//               primary: frswap
//                   ? const Color.fromARGB(255, 158, 158, 158)
//                   : const Color.fromARGB(255, 76, 175, 80),
//               shape: const CircleBorder(),
//               shadowColor: Colors.black12,
//               padding: const EdgeInsets.all(10),
//             ),
//             child: const Text(
//               "R",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 16,
//                   fontStyle: FontStyle.normal),
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
