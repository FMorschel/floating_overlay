part of 'floating_overlay.dart';

class _FloatingOverlayCursor {
  _FloatingOverlayCursor({
    required _FloatingOverlayScale scale,
    required _FloatingOverlayOffset offset,
  })  : _scale = scale,
        _offset = offset;

  final _FloatingOverlayScale _scale;
  final _FloatingOverlayOffset _offset;
  Rect _startRect = Rect.zero;

  /// Returns the actual main direction where the mouse is going.
  ///
  /// E.g. `_Side.left`? `Offset(X.Y, 0.0)`.
  ///
  /// E.g. `_Side.topLeft`?
  /// It's going to return where the mouse has gone further.
  ///
  /// ```dart
  /// final delta = newOffset - _offset._startOffset;
  /// if (delta.dx.abs() > delta.dy.abs()) {
  ///   return Offset(X.Y, 0.0);
  /// } else {
  ///   return Offset(0.0, X.Y);
  /// }
  /// ```
  Offset mainDirectionDelta(Offset newOffset, _Side side) {
    final delta = newOffset - _offset._startOffset;
    if (side.diagonal) {
      if (delta.dx.abs() > delta.dy.abs()) {
        return Offset(delta.dx, 0) * 2;
      } else {
        return Offset(0, delta.dy) * 2;
      }
    } else if (side.horizontal) {
      return Offset(delta.dx, 0) * 2;
    } else {
      return Offset(0, delta.dy) * 2;
    }
  }

  void onStart(Offset startOffset, FloatingOverlayData data) {
    _scale.onStart();
    _offset.onStart(startOffset);
    _startRect = data.childRect;
  }

  /// Just as the gesture detector around the child, this tries to update the
  /// scale and then the offset.
  void onUpdate(Offset delta, FloatingOverlayData data) {
    final size = data.childSize;
    final previousScale = _scale.state;
    _scale.onUpdateDelta(delta, data);
    final newScale = _scale.state;
    if (newScale != previousScale) {
      final newSize = size * newScale;
      final newRect = Alignment.center.inscribe(newSize, _startRect);
      _offset.onUpdateDelta(
        newRect.topLeft - _startRect.topLeft,
        data.childRect.size,
      );
    }
  }

  void onEnd() {
    _offset.onEnd();
  }
}
