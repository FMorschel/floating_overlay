part of 'floating_overlay.dart';

class _FloatingOverlayOffset extends Cubit<Offset> {
  _FloatingOverlayOffset({
    Offset? start,
    EdgeInsets? padding,
    bool constrained = false,
  })  : _constrained = constrained,
        _padding = padding ?? EdgeInsets.zero,
        _previousOffset = start ?? Offset.zero,
        _startOffset = start ?? Offset.zero,
        super(start ?? Offset.zero);

  final EdgeInsets _padding;
  final bool _constrained;
  Offset _previousOffset;
  Offset _startOffset;
  Rect? floatingLimits;

  void init(Rect limits, Size screenSize) {
    if (_constrained) {
      floatingLimits = Rect.fromLTRB(
        limits.left + _padding.left,
        limits.top + _padding.top,
        limits.right - _padding.right,
        limits.bottom - _padding.bottom,
      );
    } else {
      final rightPaddding = screenSize.width - _padding.right;
      final bottomPadding = screenSize.height - _padding.bottom;
      floatingLimits = Rect.fromLTRB(
        _padding.left,
        _padding.top,
        rightPaddding,
        bottomPadding,
      );
    }
  }

  void set(Offset offset, Size childSize) {
    emit(_validValue(offset, childSize));
    onEnd();
  }

  void setGlobal(Offset newOffset, FloatingOverlayData data) {
    emit(_validValue(newOffset, data.childRect.size));
    onEnd();
  }

  void onStart(Offset newOffset) => _startOffset = newOffset;

  void onEnd() => _previousOffset = state;

  void onUpdate(
    Offset newOffset,
    FloatingOverlayData data,
    double previousScale,
  ) {
    final scaleOffset = _scaleOffset(data, previousScale);
    final delta = newOffset - _startOffset - scaleOffset;
    onUpdateDelta(delta, data.childRect.size);
  }

  Offset _scaleOffset(FloatingOverlayData data, double previousScale) {
    final previousSize = data.copyWith(scale: previousScale).childRect.size;
    final currentSize = data.childRect.size;
    final difference = Size(
      currentSize.width - previousSize.width,
      currentSize.height - previousSize.height,
    );
    return Offset(difference.width / 2, difference.height / 2);
  }

  void onUpdateDelta(Offset delta, Size size) {
    final offset = (_previousOffset + delta);
    emit(_validValue(offset, size));
  }

  Offset _validValue(Offset offset, Size childSize) {
    double? dx;
    double? dy;
    final limits = floatingLimits!;
    final rect = offset & childSize;

    if (rect.right > limits.right) dx = limits.right - rect.width;
    if ((dx != null) && (dx < limits.left)) dx = limits.left;
    if (rect.left < limits.left) dx = limits.left;

    if (rect.bottom > limits.bottom) dy = limits.bottom - rect.height;
    if ((dy != null) && (dy < limits.top)) dy = limits.top;
    if (rect.top < limits.top) dy = limits.top;

    return Offset(
      dx ?? offset.dx,
      dy ?? offset.dy,
    );
  }
}
