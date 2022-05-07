part of 'floating_overlay.dart';

class _Rotate extends StatelessWidget {
  const _Rotate({
    Key? key,
    required this.child,
    required this.rotationController,
    required this.scaleController,
    required this.entryData,
  }) : super(key: key);

  final Widget child;
  final _FloatingOverlayRotation rotationController;
  final _FloatingOverlayScale scaleController;
  final FloatingOverlayData Function() entryData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: scaleController.state,
      stream: scaleController.stream,
      builder: (context, snapshot) {
        return StreamBuilder<double>(
          initialData: rotationController.state,
          stream: rotationController.stream,
          builder: (context, snapshot) {
            final rotation = snapshot.data!;
            Size? size;
            if (entryData().childSize != Size.zero) {
              size = entryData().rotatedRect.size;
            }
            return SizedBox.fromSize(
              size: size,
              child: Builder(
                builder: (context) {
                  if (size != null) {
                    return Center(
                      child: Transform.rotate(
                        angle: rotation * (2 * pi) / 360,
                        alignment: Alignment.center,
                        child: child,
                      ),
                    );
                  } else {
                    return Transform.rotate(
                      angle: rotation * (2 * pi) / 360,
                      alignment: Alignment.center,
                      child: child,
                    );
                  }
                },
              ),
            );
          },
        );
      },
    );
  }
}
