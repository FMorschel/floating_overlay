part of 'floating_overlay.dart';

class _Reposition extends StatelessWidget {
  const _Reposition({
    required this.child,
    required this.offsetController,
  });

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
          top: position.dy,
          left: position.dx,
          child: child,
        );
      },
    );
  }
}
