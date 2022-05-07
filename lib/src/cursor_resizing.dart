part of 'floating_overlay.dart';

class _CursorResizing extends StatelessWidget {
  const _CursorResizing({
    Key? key,
    required this.side,
    required this.controller,
    required this.data,
    this.width,
    this.cursorColor,
    this.cursorSize,
  }) : super(key: key);

  final _Side side;
  final double? width;
  final FloatingOverlayData Function() data;
  final _FloatingOverlayCursor controller;
  final Color? cursorColor;
  final double? cursorSize;

  double? _sideSize(double? distance) {
    if ((distance != null) && (distance != 0)) {
      return width ?? distance;
    } else {
      return distance;
    }
  }

  @override
  Widget build(BuildContext context) {
    final position = _CursorPositon();
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
          onHover: (event) {
            if (side.rotation) position.update(event.localPosition);
          },
          onExit: (_) => position.update(null),
          child: Builder(
            builder: (context) {
              if (side.rotation) {
                return SizedBox(
                  width: _sideSize(side.width),
                  height: _sideSize(side.height),
                );
              } else {
                return Stack(
                  children: [
                    SizedBox(
                      width: _sideSize(side.width),
                      height: _sideSize(side.height),
                    ),
                    StreamBuilder<Offset?>(
                      initialData: position.state,
                      stream: position.stream,
                      builder: (context, snapshot) {
                        final offset = snapshot.data;
                        if (offset != null) {
                          final size = cursorSize ??
                              Theme.of(context).iconTheme.size ??
                              24;
                          return Positioned(
                            left: offset.dx - size / 2,
                            top: offset.dx - size / 2,
                            child: Icon(
                              Icons.refresh,
                              color: cursorColor,
                              size: size,
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ],
                );
              }
            },
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

class _CursorPositon extends Cubit<Offset?> {
  _CursorPositon([Offset? initialState]) : super(initialState);
  void update(Offset? newState) => emit(newState);
}
