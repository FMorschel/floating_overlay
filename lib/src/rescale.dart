part of 'floating_overlay.dart';

class _Rescale extends StatelessWidget {
  const _Rescale({
    Key? key,
    required this.child,
    required this.scaleController,
    required this.entryData,
  }) : super(key: key);

  final Widget child;
  final _FloatingOverlayScale scaleController;
  final FloatingOverlayData entryData;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
      initialData: scaleController.state,
      stream: scaleController.stream,
      builder: (context, snapshot) {
        final scale = snapshot.data!;
        Size? size;
        if (entryData.childSize != Size.zero) size = entryData.childSize * scale;
        return SizedBox.fromSize(
          size: size,
          child: child,
        );
      },
    );
  }
}
