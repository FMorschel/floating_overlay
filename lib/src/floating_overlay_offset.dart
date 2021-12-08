part of 'floating_overlay.dart';

class _FloatingOverlayOffset extends Cubit<Offset> {
  _FloatingOverlayOffset(Offset? initialState, [EdgeInsets? padding])
      : _padding = padding ?? EdgeInsets.zero,
        _constrainedPadding = padding ?? EdgeInsets.zero,
        _previousOffset = initialState ?? Offset.zero,
        super(initialState ?? Offset.zero);

  final EdgeInsets _padding;
  EdgeInsets _constrainedPadding;
  bool _constrained = false;
  Offset _previousOffset;
  _FloatingOverlayScale? _scale;
  GlobalKey? _key;

  void init(EdgeInsets padding, bool constrained) {
    _constrainedPadding = EdgeInsets.fromLTRB(
      padding.left + _padding.left,
      padding.top + _padding.top,
      padding.right + _padding.right,
      padding.bottom + _padding.bottom,
    );
    _constrained = constrained;
  }

  void set(Offset offset, Size screenSize) {
    _previousOffset = _validValue(offset, screenSize);
    emit(_validValue(offset, screenSize));
  }

  void onStart(final _FloatingOverlayScale scale, final GlobalKey key) {
    _previousOffset = state;
    _scale = scale;
    _scale!.stream.listen((scale) {
      if (_context != null) {
        _update(scale: scale);
      }
    });
    _key = key;
  }

  BuildContext? get _context => _key?.currentContext;
  EdgeInsets get currentPadding =>
      _constrained ? _constrainedPadding : _padding;

  void onUpdate(Offset offset) {
    if (_context != null) {
      _update(offset: offset);
    } else {
      emit(_previousOffset + offset);
    }
  }

  void _update({Offset? offset, double? scale}) {
    final screenSize = MediaQuery.of(_context!).size;
    final widgetSize = _widgetSize(_context!) * (scale ?? _scale!.state);
    final _offset = offset == null ? state : _previousOffset + offset;
    emit(_validValue(_offset, screenSize, widgetSize));
  }

  Size _widgetSize(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  Offset _validValue(
    Offset offset,
    Size screen, [
    Size child = Size.zero,
  ]) {
    double? width;
    double? height;
    final limits = _limitsFrom(currentPadding, screen);
    final pixels = _childPixels(offset, child);

    if (pixels.right > limits.right) width = limits.right - child.width;
    if (pixels.left < limits.left) width = limits.left;
    
    if (pixels.bottom > limits.bottom) height = limits.bottom - child.height;
    if (pixels.top < limits.top) height = limits.top;

    return Offset(
      width ?? offset.dx, 
      height ?? offset.dy,
    );
  }

  EdgeInsets _childPixels(Offset offset, Size? size) {
    return EdgeInsets.fromLTRB(
      offset.dx,
      offset.dy,
      offset.dx + (size?.width ?? 0),
      offset.dy + (size?.height ?? 0),
    );
  }

  EdgeInsets _limitsFrom(EdgeInsets padding, Size size) {
    final rightPaddding = size.width - padding.right;
    final bottomPadding = size.height - padding.bottom;
    return EdgeInsets.fromLTRB(
      padding.left,
      padding.top,
      rightPaddding,
      bottomPadding,
    );
  }
}
