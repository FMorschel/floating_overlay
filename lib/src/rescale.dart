part of 'floating_overlay.dart';

class _Rescale extends StatelessWidget {
  const _Rescale({
    required this.child,
    required this.scaleController,
    required this.data,
  });

  final Widget child;
  final _FloatingOverlayScale scaleController;
  final FloatingOverlayData data;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: scaleController.state,
      stream: scaleController.stream,
      builder: (context, snapshot) {
        final scale = snapshot.data!;
        Size? size;
        if (data.childSize != Size.zero) size = data.childSize * scale;
        return SizedBox.fromSize(
          size: size,
          child: child,
        );
      },
    );
  }
}
