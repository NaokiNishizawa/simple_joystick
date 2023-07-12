import 'package:flutter/material.dart';

typedef StickDragCallback = void Function(StickDragDetails details);

class StickDragDetails {
  StickDragDetails(
    this.x,
    this.y,
    this.alignment,
    this.currentOffset,
  );

  final double x;
  final double y;
  final Alignment alignment;
  final Offset currentOffset;
}
