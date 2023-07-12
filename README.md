# simple joystick

[Japanese READEME](./materials/README_JA.md)

simple joystick plugin for [Flutter](https://flutter.io).
Supports iOS, Android.
(Other environments unconfirmed)

## App Demo
https://github.com/NaokiNishizawa/simple_joystick/assets/60878237/4399367d-ca9f-4c0d-96e7-8732f77f9759

## Getting Started

In your flutter project add the dependency:

```yml
dependencies:
  ...
  simple_joystick:
```

## Usage example

```dart
import 'package:simple_joystick/simple_joystick.dart';
```

## Usage
```dart
 Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
        JoyStick(
            150, // JoyStickAreaSize
            50, // JoyStickStickSize
            (details) {
                // Please describe what you want to do after the stick move.
            },
        ),
    ],
),
```
### CallBack Detail
```dart
typedef StickDragCallback = void Function(StickDragDetails details);

class StickDragDetails {
  StickDragDetails(
    this.x, // Global X coordinate after moving
    this.y, // Global Y coordinate after moving
    this.alignment,
    this.currentOffset, 
  );

  final double x;
  final double y;
  final Alignment alignment;
  final Offset currentOffset;
}
```
