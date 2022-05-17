part of 'floating_overlay.dart';

class _CursorResizing extends StatelessWidget {
  const _CursorResizing({
    Key? key,
    required this.side,
    required this.controller,
    required this.data,
    required this.area,
  }) : super(key: key);

  final _Side side;
  final double? area;
  final FloatingOverlayData Function() data;
  final _FloatingOverlayCursor controller;

  double? _sideSize(double? distance) => area ?? distance;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: _sideSize(side.leftDistance),
      top: _sideSize(side.topDistance),
      right: _sideSize(side.rightDistance),
      bottom: _sideSize(side.bottomDistance),
      child: GestureDetector(
        onPanStart: onStart,
        onPanUpdate: onUpdate,
        onPanEnd: onEnd,
        child: MouseRegion(
          cursor: side.cursor,
          opaque: true,
          child: SizedBox(
            width: _sideSize(side.width),
            height: _sideSize(side.height),
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
