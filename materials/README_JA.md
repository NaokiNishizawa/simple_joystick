# simple joystick

simple joystickは[Flutter](https://flutter.io)のプラグインです。
サポートはiOS, Android。
(その他の環境については未確認です。)

## アプリデモ
https://github.com/NaokiNishizawa/simple_joystick/assets/60878237/9592fae7-8140-444c-bc6d-77399111443a

## 開始

dependenciesに本プラグインを追加してください。

```yml
dependencies:
  ...
  simple_joystick:
```

## 使用例

```dart
import 'package:simple_joystick/simple_joystick.dart';
```

## 使用方法
```dart
 Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
        JoyStick(
            150, // JoyStickAreaSize
            50, // JoyStickStickSize
            (details) {
                // ここにstick移動後に行いたいことを記載してください。
            },
        ),
    ],
),
```
### コールバックの詳細
```dart
typedef StickDragCallback = void Function(StickDragDetails details);

class StickDragDetails {
  StickDragDetails(
    this.x, // 移動後のグローバル座標のX
    this.y, // 移動後のグローバル座標のY
    this.alignment,
    this.currentOffset, 
  );

  final double x;
  final double y;
  final Alignment alignment;
  final Offset currentOffset;
}
```
