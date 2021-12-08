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
  GlobalKey? _key;

  BuildContext? get _context => _key?.currentContext;

  void onStart([GlobalKey? key]) {
    _previousScale = state;
    _key = key;
  }

  void onUpdate(double scale) {
    final newScale = _previousScale * scale;
    final minScale = _minScale ?? 1.0;
    final maxScale = _maxScale ?? 1.0;
    if (_context != null) {
      final childSize = _widgetSize(_context!);
      final minSize = _minSize ?? (childSize * minScale);
      final maxSize = _maxSize ?? (childSize * maxScale);
      final clampedSize = (childSize * newScale).clamp(minSize, maxSize);
      emit(clampedSize.div(childSize));
    } else {
      emit(newScale.clamp(minScale, maxScale));
    }
  }

  Size _widgetSize(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox?;
    return renderBox?.size ?? Size.zero;
  }
}
