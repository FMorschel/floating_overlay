part of 'floating_overlay.dart';

class _FloatingOverlayScale extends Cubit<double> {
  _FloatingOverlayScale.relative({
    double? minScale,
    double? maxScale,
  })  : _minScale = minScale ?? 1.0,
        _maxScale = maxScale ?? 1.0,
        _maxSize = null,
        _minSize = null,
        super(1.0);

  _FloatingOverlayScale.absolute({
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
  Size? _sizeLimit;

  void init(Rect constraints) {
    final height = constraints.bottom - constraints.top;
    final width = constraints.right - constraints.left;
    _sizeLimit = Size(width, height);
  }

  void onStart() => _previousScale = state;

  void onUpdate(double scale, FloatingOverlayData data) {
    final childSize = data.childSize;
    final minSize = _minSize ?? (childSize * (_minScale ?? 1.0));
    final maxSize = _maxSize ?? (childSize * (_maxScale ?? 1.0));
    final actualMax = maxSize.clamp(Size.zero, _sizeLimit!);
    final clampedSize = (childSize * (_previousScale * scale)).clamp(
      minSize,
      actualMax,
    );
    emit(clampedSize.div(childSize));
  }
}
