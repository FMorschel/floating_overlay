part of 'floating_overlay.dart';

class _Rescale extends StatelessWidget {
  _Rescale({
    Key? key,
    required this.child,
    required this.scaleController,
    required this.childKey,
  }) : super(key: key);

  final Widget child;
  final _FloatingOverlayScale scaleController;
  final GlobalKey childKey;
  final cubit = _SizeCubit();

  void function([void Function(Size)? lambda]) {
    final box = childKey.currentContext!.findRenderObject()! as RenderBox;
    lambda?.call(box.size);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback(
      (_) => function((_size) => cubit.emit(_size)),
    );
    return StreamBuilder<double>(
      initialData: scaleController.state,
      stream: scaleController.stream,
      builder: (context, snapshot) {
        final scale = snapshot.data!;
        return StreamBuilder<Size?>(
          stream: cubit.stream,
          builder: (context, snapshot) {
            final size = snapshot.data;
            if (size == null) {
              return Offstage(
                offstage: true,
                child: child,
              );
            } else {
              return SizedBox.fromSize(
                size: size * scale,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: child,
                ),
              );
            }
          },
        );
      },
    );
  }
}

class _SizeCubit extends Cubit<Size?> {
  _SizeCubit([Size? initialState]) : super(initialState);
}
