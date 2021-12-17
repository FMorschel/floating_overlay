part of 'floating_overlay.dart';

class _CursorResizing extends StatelessWidget {
  const _CursorResizing({
    Key? key,
    required this.side,
    required this.controller,
    required this.data,
    this.width,
  }) : super(key: key);

  final _Side side;
  final double? width;
  final FloatingOverlayData Function() data;
  final _FloatingOverlayCursor controller;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: side.leftDistance,
      top: side.topDistance,
      right: side.rightDistance,
      bottom: side.bottomDistance,
      child: GestureDetector(
        onPanStart: side.diagonal ? onStart : null,
        onPanUpdate: side.diagonal ? onUpdate : null,
        onPanEnd: side.diagonal ? onEnd : null,
        onVerticalDragStart: side.vertical ? onStart : null,
        onVerticalDragUpdate: side.vertical ? onUpdate : null,
        onVerticalDragEnd: side.vertical ? onEnd : null,
        onHorizontalDragStart: side.horizontal ? onStart : null,
        onHorizontalDragUpdate: side.horizontal ? onUpdate : null,
        onHorizontalDragEnd: side.horizontal ? onEnd : null,
        child: MouseRegion(
          cursor: side.cursor,
          opaque: true,
          child: SizedBox(
            width: side.width,
            height: side.height,
          ),
        ),
      ),
    );
  }

  void onStart(DragStartDetails details) {
    controller.onStart(details.globalPosition, data());
  }

  void onUpdate(DragUpdateDetails details) {
    final delta = controller.mainDirectionDelta(details.globalPosition, side);
    controller.onUpdate(side.consideringDelta(delta), data());
  }

  void onEnd(void _) {
    controller.onEnd();
  }
}
