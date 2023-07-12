library simple_joystick;

import 'package:flutter/material.dart';
import 'package:simple_joystick/stick_drag_callback.dart';

class JoyStick extends StatefulWidget {
  const JoyStick(
    this.joyStickAreaSize,
    this.joyStickStickSize,
    this.callback, {
    super.key,
    this.joyStickAreaColor = Colors.grey,
    this.joyStickStickColor = Colors.white,
    this.animationDuration = 200,
  });

  // must
  final double joyStickAreaSize;
  final double joyStickStickSize;
  final StickDragCallback callback;

  // option
  final Color joyStickAreaColor;
  final Color joyStickStickColor;
  final int animationDuration; // ms

  @override
  State<StatefulWidget> createState() => _JoyStickState();
}

class _JoyStickState extends State<JoyStick>
    with SingleTickerProviderStateMixin {
  GlobalKey parentKey = GlobalKey();
  GlobalKey childKey = GlobalKey();
  Offset stickMovedPositionOffset = Offset.zero;
  bool isCompleteInit = false;
  bool isStickInitPosition = true;
  Offset currentOffset = Offset.zero;

  late double joyStickSize;
  late double halfSize;
  late double stickSize;

  late Offset joyStickInitPositionOffset;
  late Offset origin;
  late Offset stickInitPositionOffset;

  late AnimationController controller;
  late Tween<Offset> tween;

  @override
  void initState() {
    controller = AnimationController(
        duration: Duration(milliseconds: widget.animationDuration),
        vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool judgmentStickMove(Offset now) {
      if (joyStickInitPositionOffset.dx > now.dx ||
          (joyStickInitPositionOffset.dx + joyStickSize) < now.dx) {
        return false;
      }

      if (joyStickInitPositionOffset.dy > now.dy ||
          (joyStickInitPositionOffset.dy + joyStickSize) < now.dy) {
        return false;
      }

      return true;
    }

    void moveStick(Offset offset, Offset delta) {
      setEndOffset(offset);
      isStickInitPosition = false;

      widget.callback(
        StickDragDetails(
          offset.dx,
          offset.dy,
          Alignment(currentOffset.dx, currentOffset.dy),
          currentOffset,
        ),
      );
      setState(() {});
    }

    void moveStickInitPosition() {
      setEndOffset(origin);
      isStickInitPosition = true;
      widget.callback(
        StickDragDetails(
          stickInitPositionOffset.dx,
          stickInitPositionOffset.dy,
          Alignment(currentOffset.dx, currentOffset.dy),
          currentOffset,
        ),
      );
      setState(() {});
    }

    Future<bool> animationInitCompleteWait() async {
      // wait 100ms
      await Future.delayed(const Duration(milliseconds: 100));
      return true;
    }

    return FutureBuilder(
      future: animationInitCompleteWait(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }
        Widget content = GestureDetector(
          onPanUpdate: (details) {
            final globalPosition = details.globalPosition;
            final delta = details.delta;

            if (judgmentStickMove(globalPosition)) {
              Offset offset = Offset(globalPosition.dx, globalPosition.dy);
              moveStick(offset, delta);
            }
          },
          onPanEnd: (details) {
            moveStickInitPosition();
          },
          child: Container(
            color: Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  key: parentKey,
                  width: widget.joyStickAreaSize,
                  height: widget.joyStickAreaSize,
                  decoration: BoxDecoration(
                    color: widget.joyStickAreaColor,
                    shape: BoxShape.circle,
                  ),
                ),
                FutureBuilder(
                    future: animationInitCompleteWait(),
                    builder:
                        (BuildContext context, AsyncSnapshot<bool> snapshot) {
                      if (snapshot.hasData && !isStickInitPosition) {
                        return SlideTransition(
                          position: tween.animate(controller),
                          child: Container(
                            width: stickSize,
                            height: stickSize,
                            decoration: BoxDecoration(
                              color: widget.joyStickStickColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      } else {
                        return Container(
                          key: childKey,
                          width: widget.joyStickStickSize,
                          height: widget.joyStickStickSize,
                          decoration: BoxDecoration(
                            color: widget.joyStickStickColor,
                            shape: BoxShape.circle,
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        );
        Future.delayed(const Duration(milliseconds: 100)).then(
          (value) => {
            if (!isCompleteInit)
              {
                init(),
              },
          },
        );

        return content;
      },
    );
  }

  void init() {
    if (isStickInitPosition) {
      joyStickInitPositionOffset = getJoyStickPosition();
      stickInitPositionOffset = getStickPosition();

      joyStickSize = widget.joyStickAreaSize;
      halfSize = joyStickSize / 2.0;
      stickSize = widget.joyStickStickSize;

      // Set the center point of the outer circle
      origin = Offset(joyStickInitPositionOffset.dx + halfSize,
          joyStickInitPositionOffset.dy + halfSize);

      setEndOffset(stickInitPositionOffset);
      isCompleteInit = true;
    }
  }

  /// Get JoyStick Position
  Offset getJoyStickPosition() {
    RenderBox box = parentKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    return position;
  }

  /// Get Stick Position
  Offset getStickPosition() {
    RenderBox box = childKey.currentContext?.findRenderObject() as RenderBox;
    Offset position = box.localToGlobal(Offset.zero); //this is global position
    return position;
  }

  void setEndOffset(Offset currentStickPositionOffset) {
    Offset endOffset = calculationMoveOffset(currentStickPositionOffset);

    tween = Tween(begin: stickMovedPositionOffset, end: endOffset);

    currentOffset = endOffset;

    stickMovedPositionOffset = endOffset;
  }

  Offset calculationMoveOffset(Offset now) {
    double x = 0;
    double y = 0;

    // X
    if (now.dx == stickInitPositionOffset.dx) {
      // nothing
    } else {
      x = (now.dx - origin.dx) / (joyStickSize / 2);
    }

    // Y
    if (now.dy == stickInitPositionOffset.dy) {
      // nothing
    } else {
      y = (now.dy - origin.dy) / (joyStickSize / 2);
    }

    x = makeRound(x);
    y = makeRound(y);

    return Offset(x, y);
  }

  /// Round number between -1 and 1
  double makeRound(double base) {
    double rtn = base;
    if (rtn == 0) {
      return rtn;
    }

    if (base > 0) {
      rtn = rtn > 1 ? 1 : base;
    } else {
      rtn = rtn < -1 ? -1 : base;
    }

    return rtn;
  }
}
