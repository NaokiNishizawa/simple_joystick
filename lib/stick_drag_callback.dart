import 'dart:ui';

typedef StickDragCallback = void Function(StickDragDetails details);

class StickDragDetails {
  StickDragDetails(
    this.x,
    this.y,
    this.delta,
  );

  final double x;
  final double y;
  final Offset delta;
}
