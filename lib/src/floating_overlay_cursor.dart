part of 'floating_overlay.dart';

class _FloatingOverlayCursor {
  _FloatingOverlayCursor({
    required _FloatingOverlayScale scale,
    required _FloatingOverlayOffset offset,
  })  : _scale = scale,
        _offset = offset;

  final _FloatingOverlayScale _scale;
  final _FloatingOverlayOffset _offset;
  Offset _startOffset = Offset.zero;

  void onStart(
    final GlobalKey key,
    final Offset startOffset,
  ) {
    _scale.onStart();
    _offset.onStart(startOffset);
    _startOffset = startOffset;
  }

  void onUpdate(Offset globalPosition, [double multiplyer = 1.0]) {
    assert((multiplyer == 1.0) || (multiplyer == -1.0));
    final delta = (globalPosition - _startOffset) * multiplyer;
  }
}
