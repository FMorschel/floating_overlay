part of 'floating_overlay.dart';

class _FloatingOverlatTransform extends StatelessWidget {
  const _FloatingOverlatTransform({
    Key? key,
    required this.child,
    required this.scaleController,
  }) : super(key: key);

  final Widget child;
  final _FloatingOverlayScale scaleController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: scaleController.state,
      stream: scaleController.stream,
      builder: (context, snapshot) {
        final scale = snapshot.data!;
        final vector = Vector3(scale, scale, scale);
        return Transform(
          alignment: Alignment.topLeft,
          transform: Matrix4.diagonal3(vector),
          child: child,
        );
      },
    );
  }
}
