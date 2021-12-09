part of 'floating_overlay.dart';

class _FloatingOverlayOffset extends Cubit<Offset> {
  _FloatingOverlayOffset({
    Offset? start,
    EdgeInsets? padding,
  })  : _padding = padding ?? EdgeInsets.zero,
        _constrainPadding = padding ?? EdgeInsets.zero,
        _previousOffset = start ?? Offset.zero,
        super(start ?? Offset.zero);

  final EdgeInsets _padding;
  EdgeInsets _constrainPadding;
  bool _constrained = false;
  Offset _previousOffset;
  _FloatingOverlayScale? _scale;
  GlobalKey? _key;

  void init(EdgeInsets padding, bool constrained) {
    _constrainPadding = EdgeInsets.fromLTRB(
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
  EdgeInsets get _currentPadding => _constrained ? _constrainPadding : _padding;

  void onUpdate(Offset offset) {
    if (_context != null) {
      _update(offset: offset);
    } else {
      emit(_previousOffset + offset);
    }
  }

  void _update({Offset? offset, double? scale}) {
    final currentScale = scale ?? _scale!.state;
    final screenSize = MediaQuery.of(_context!).size;
    final widgetSize = _widgetSize(_context!);
    final _offset = offset == null ? state : _previousOffset + offset;
    emit(_validValue(_offset, screenSize, widgetSize * currentScale));
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
    final limits = _limitsFrom(screen);
    final rect = _childRect(offset, child);

    if (rect.right > limits.right) width = limits.right - child.width;
    if (rect.left < limits.left) width = limits.left;

    if (rect.bottom > limits.bottom) height = limits.bottom - child.height;
    if (rect.top < limits.top) height = limits.top;

    return Offset(
      width ?? offset.dx,
      height ?? offset.dy,
    );
  }

  Rect _childRect(Offset offset, Size? size) {
    return Rect.fromLTRB(
      offset.dx,
      offset.dy,
      offset.dx + (size?.width ?? 0),
      offset.dy + (size?.height ?? 0),
    );
  }

  Rect _limitsFrom(Size screenSize) {
    final rightPaddding = screenSize.width - _currentPadding.right;
    final bottomPadding = screenSize.height - _currentPadding.bottom;
    return Rect.fromLTRB(
      _currentPadding.left,
      _currentPadding.top,
      rightPaddding,
      bottomPadding,
    );
  }
}
