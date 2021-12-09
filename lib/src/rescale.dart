part of 'floating_overlay.dart';

class _Rescale extends StatelessWidget {
  const _Rescale({
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
        final vector = Vector3(scale, scale, 1.0);
        return Transform(
          transform: Matrix4.diagonal3(vector),
          child: child,
        );
      },
    );
  }
}
