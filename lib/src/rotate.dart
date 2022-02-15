part of 'floating_overlay.dart';

class _Rotate extends StatelessWidget {
  const _Rotate({
    Key? key,
    required this.child,
    required this.rotationController,
    required this.data,
  }) : super(key: key);

  final Widget child;
  final _FloatingOverlayRotation rotationController;
  final FloatingOverlayData Function() data;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: rotationController.state,
      stream: rotationController.stream,
      builder: (context, snapshot) {
        final rotation = snapshot.data!;
        return Transform.rotate(
          angle: rotation * (2 * pi) / 360,
          alignment: Alignment.center,
          child: child,
        );
      },
    );
  }
}
