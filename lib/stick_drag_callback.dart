typedef StickDragCallback = void Function(StickDragDetails details);

class StickDragDetails {
  StickDragDetails(this.x, this.y);

  final double x;
  final double y;
}
