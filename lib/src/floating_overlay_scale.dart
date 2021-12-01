part of 'floating_overlay.dart';

class FloatingOverlayScale extends Cubit<double> {
  FloatingOverlayScale.relative({
    double? minScale,
    double? maxScale,
  })  : _minScale = minScale ?? 1.0,
        _maxScale = maxScale ?? 1.0,
        _maxSize = null,
        _minSize = null,
        super(1.0);

  FloatingOverlayScale.absolute({
    Size? minSize,
    Size? maxSize,
  })  : _maxSize = maxSize,
        _minSize = minSize,
        _minScale = minSize == null ? 1.0 : null,
        _maxScale = maxSize == null ? 1.0 : null,
        super(1.0);

  final double? _maxScale;
  final double? _minScale;
  final Size? _minSize;
  final Size? _maxSize;
  double _previousScale = 1.0;

  void onStart() => _previousScale = state;

  void onUpdate(ScaleUpdateDetails details, [GlobalKey? key]) {
    final scale = _previousScale * details.scale;
    final context = key?.currentContext;
    if (context != null) {
      final renderBox = context.findRenderObject() as RenderBox;
      final size = renderBox.size * scale;
      if (((_minSize != null) && (_minSize! > size)) ||
          ((_minScale != null) && (_minScale! > scale))) {
        emit(
          (_minSize != null)
              ? (_minSize!.height / renderBox.size.height)
              : _minScale!,
        );
      } else if (((_maxSize != null) && (_maxSize! < size)) ||
          ((_maxScale != null) && (_maxScale! < scale))) {
        emit(
          (_maxSize != null)
              ? (_maxSize!.height / renderBox.size.height)
              : _maxScale!,
        );
      } else {
        emit(scale);
      }
    } else if ((_minScale ?? 1.0) > scale) {
      emit(_minScale ?? 1.0);
    } else if (scale > (_maxScale ?? 1.0)) {
      emit(_maxScale ?? 1.0);
    } else {
      emit(scale);
    }
  }
}
