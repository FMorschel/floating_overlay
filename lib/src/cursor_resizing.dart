part of 'floating_overlay.dart';

enum Side {
  left,
  top,
  right,
  bottom,
}

class _CursorResizing extends StatelessWidget {
  const _CursorResizing({
    Key? key,
    required this.side,
    required this.childKey,
    required this.cursorController,
    this.width,
  }) : super(key: key);

  final Side side;
  final double? width;
  final GlobalKey childKey;
  final _FloatingOverlayCursor cursorController;

  @override
  Widget build(BuildContext context) {
    late final MouseCursor cursor;
    double? _width;
    double? _height;
    if ((side == Side.right) || (side == Side.left)) {
      cursor = SystemMouseCursors.resizeLeftRight;
      _width = width ?? 2;
    } else {
      cursor = SystemMouseCursors.resizeUpDown;
      _height = width ?? 2;
    }
    double? left;
    double? top;
    double? right;
    double? bottom;
    if (side == Side.left) {
      left = 0;
      top = width ?? 2;
      bottom = width ?? 2;
    } else if (side == Side.top) {
      top = 0;
      left = width ?? 2;
      right = width ?? 2;
    } else if (side == Side.right) {
      right = 0;
      top = width ?? 2;
      bottom = width ?? 2;
    } else if (side == Side.bottom) {
      bottom = 0;
      left = width ?? 2;
      right = width ?? 2;
    }
    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      child: GestureDetector(
        onHorizontalDragStart: (details) {
          cursorController.onStart(childKey, details.globalPosition);
        },
        onHorizontalDragUpdate: (details) {
          if ((side == Side.left) || (side == Side.top)) {
            cursorController.onUpdate(details.globalPosition, -1);
          } else {
            cursorController.onUpdate(details.globalPosition);
          }
        },
        child: MouseRegion(
          cursor: cursor,
          opaque: true,
          child: SizedBox(
            width: _width,
            height: _height,
            child: Container(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
