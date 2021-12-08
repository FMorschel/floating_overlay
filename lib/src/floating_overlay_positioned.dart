part of 'floating_overlay.dart';

class _FloatingOverlayPositioned extends StatelessWidget {
  const _FloatingOverlayPositioned({
    Key? key,
    required this.child,
    required this.offsetController,
  }) : super(key: key);

  final Widget child;
  final _FloatingOverlayOffset offsetController;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Offset>(
      initialData: offsetController.state,
      stream: offsetController.stream,
      builder: (context, snapshot) {
        final position = snapshot.data!;
        return Positioned(
          left: position.dx,
          top: position.dy,
          child: child,
        );
      },
    );
  }
}
