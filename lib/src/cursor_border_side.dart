part of 'floating_overlay.dart';

class _Side {
  const _Side._({
    required this.cursor,
    this.width,
    this.height,
    this.leftDistance,
    this.topDistance,
    this.rightDistance,
    this.bottomDistance,
  });

  static _Side get left => const _Side._(
        cursor: SystemMouseCursors.resizeLeftRight,
        width: _defaultWidth,
        leftDistance: 0,
        topDistance: _defaultWidth,
        bottomDistance: _defaultWidth,
      );
  static _Side get top => const _Side._(
        cursor: SystemMouseCursors.resizeUpDown,
        height: _defaultWidth,
        topDistance: 0,
        leftDistance: _defaultWidth,
        rightDistance: _defaultWidth,
      );
  static _Side get right => const _Side._(
        cursor: SystemMouseCursors.resizeLeftRight,
        width: _defaultWidth,
        rightDistance: 0,
        topDistance: _defaultWidth,
        bottomDistance: _defaultWidth,
      );
  static _Side get bottom => const _Side._(
        cursor: SystemMouseCursors.resizeUpDown,
        height: _defaultWidth,
        bottomDistance: 0,
        leftDistance: _defaultWidth,
        rightDistance: _defaultWidth,
      );

  static _Side get topLeft => const _Side._(
        cursor: SystemMouseCursors.resizeUpLeftDownRight,
        width: _defaultWidth,
        height: _defaultWidth,
        leftDistance: 0,
        topDistance: 0,
      );
  static _Side get topRight => const _Side._(
        cursor: SystemMouseCursors.resizeUpRightDownLeft,
        width: _defaultWidth,
        height: _defaultWidth,
        rightDistance: 0,
        topDistance: 0,
      );
  static _Side get bottomLeft => const _Side._(
        cursor: SystemMouseCursors.resizeUpRightDownLeft,
        width: _defaultWidth,
        height: _defaultWidth,
        leftDistance: 0,
        bottomDistance: 0,
      );
  static _Side get bottomRight => const _Side._(
        cursor: SystemMouseCursors.resizeUpLeftDownRight,
        width: _defaultWidth,
        height: _defaultWidth,
        rightDistance: 0,
        bottomDistance: 0,
      );

  static _Side get rotateTopLeft => const _Side._(
        cursor: SystemMouseCursors.none,
        width: _defaultWidth,
        height: _defaultWidth,
        leftDistance: 0,
        topDistance: 0,
      );
  static _Side get rotateTopRight => const _Side._(
        cursor: SystemMouseCursors.none,
        width: _defaultWidth,
        height: _defaultWidth,
        rightDistance: 0,
        topDistance: 0,
      );
  static _Side get rotateBottomLeft => const _Side._(
        cursor: SystemMouseCursors.none,
        width: _defaultWidth,
        height: _defaultWidth,
        leftDistance: 0,
        bottomDistance: 0,
      );
  static _Side get rotateBottomRight => const _Side._(
        cursor: SystemMouseCursors.none,
        width: _defaultWidth,
        height: _defaultWidth,
        rightDistance: 0,
        bottomDistance: 0,
      );

  static const _defaultWidth = 3.0;

  final MouseCursor cursor;
  final double? width;
  final double? height;
  final double? leftDistance;
  final double? topDistance;
  final double? rightDistance;
  final double? bottomDistance;

  bool get diagonal {
    final primaria = cursor == SystemMouseCursors.resizeUpLeftDownRight;
    final secundaria = cursor == SystemMouseCursors.resizeUpRightDownLeft;
    return primaria || secundaria;
  }

  bool get rotation {
    return cursor == SystemMouseCursors.none;
  }

  bool get vertical {
    return cursor == SystemMouseCursors.resizeUpDown;
  }

  bool get horizontal {
    return cursor == SystemMouseCursors.resizeLeftRight;
  }

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
