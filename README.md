# Peppermint Remote Control

This is the initial creation stages of Peppermint Remote Control app.

> Most of the features in this project are placed in the **main.dart** file so that the components run in a single thread.

## File Heirarchy

>### [1] detail_widget

#### [1.1] obstacle_indication.dart

>### [2] main.dart

>### [3] speed_controller_buttons.dart

>### [4] forward_reverse_button.dart

## Details

>**[1]  detail_widget:**      In this folder, we have placed a widget as placeholder (as of now). This widget doesn't directly or indirectly influence the core functionality of the robot. It is used to indicate the proximity of the obstacle ahead.

>**[2]  main.dart:**     Most of the features and functionality of the app are place in this file (in order to run the features simultaniously in a single thread). In the later stages of the development we have to focus on multi threading (dart Isolates) for the joystick part of the app.

>**[3]  speed_controller_button.dart:**  
In this file we have buttons that sendthe required command to the robot to increase its natural acceptable speed.
The speed mentioned in the electronics team's documentaion was taken into account.

>**[4]  forward_reverse_button.dart:** This button send a command as an ascii stream of characeters required for moving the robot in forward and backward direction. In general it acts as forward and reverse gear for the robot. By default to is in forward gear.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
