part of 'floating_overlay.dart';

enum _Side {
  left(
    cursor: SystemMouseCursors.resizeLeftRight,
    width: _defaultWidth,
    leftDistance: 0,
    topDistance: _defaultWidth,
    bottomDistance: _defaultWidth,
  ),
  top(
    cursor: SystemMouseCursors.resizeUpDown,
    height: _defaultWidth,
    topDistance: 0,
    leftDistance: _defaultWidth,
    rightDistance: _defaultWidth,
  ),
  right(
    cursor: SystemMouseCursors.resizeLeftRight,
    width: _defaultWidth,
    rightDistance: 0,
    topDistance: _defaultWidth,
    bottomDistance: _defaultWidth,
  ),
  bottom(
    cursor: SystemMouseCursors.resizeUpDown,
    height: _defaultWidth,
    bottomDistance: 0,
    leftDistance: _defaultWidth,
    rightDistance: _defaultWidth,
  ),

  topLeft(
    cursor: SystemMouseCursors.resizeUpLeftDownRight,
    width: _defaultWidth,
    height: _defaultWidth,
    leftDistance: 0,
    topDistance: 0,
  ),
  topRight(
    cursor: SystemMouseCursors.resizeUpRightDownLeft,
    width: _defaultWidth,
    height: _defaultWidth,
    rightDistance: 0,
    topDistance: 0,
  ),
  bottomLeft(
    cursor: SystemMouseCursors.resizeUpRightDownLeft,
    width: _defaultWidth,
    height: _defaultWidth,
    leftDistance: 0,
    bottomDistance: 0,
  ),
  bottomRight(
    cursor: SystemMouseCursors.resizeUpLeftDownRight,
    width: _defaultWidth,
    height: _defaultWidth,
    rightDistance: 0,
    bottomDistance: 0,
  );

  const _Side({
    required this.cursor,
    this.width,
    this.height,
    this.leftDistance,
    this.topDistance,
    this.rightDistance,
    this.bottomDistance,
  });

  static const _defaultWidth = 3.0;

  final MouseCursor cursor;
  final double? width;
  final double? height;
  final double? leftDistance;
  final double? topDistance;
  final double? rightDistance;
  final double? bottomDistance;

  bool get rotation => cursor == SystemMouseCursors.none;

  bool get diagonal {
    final primaria = cursor == SystemMouseCursors.resizeUpLeftDownRight;
    final secundaria = cursor == SystemMouseCursors.resizeUpRightDownLeft;
    return primaria || secundaria;
  }

  bool get vertical => cursor == SystemMouseCursors.resizeUpDown;

  bool get horizontal => cursor == SystemMouseCursors.resizeLeftRight;

  Offset consideringDelta(Offset delta) {
    if ((leftDistance == 0) && (delta.dx != 0)) {
      return Offset(delta.dx, delta.dx) * -1;
    } else if ((topDistance == 0) && (delta.dy != 0)) {
      return Offset(delta.dy, delta.dy) * -1;
    } else if (delta.dx != 0) {
      return Offset(delta.dx, delta.dx);
    } else {
      return Offset(delta.dy, delta.dy);
    }
  }
}
