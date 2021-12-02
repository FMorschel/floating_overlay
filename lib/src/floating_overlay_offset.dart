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

  void onStart(GlobalKey key, double scale) => _previousOffset = state;

  void onUpdate(Offset offset, GlobalKey key, double scale) {
    final context = key.currentContext;
    if (context != null) {
      final screenSize = MediaQuery.of(context).size;
      final widgetSize = _widgetSize(context);
      emit(
        _validValue(
          _previousOffset + offset,
          screenSize,
          widgetSize * scale,
        ),
      );
    } else {
      emit(_previousOffset + offset);
    }
  }

  Size _widgetSize(BuildContext context) {
    final renderBox = context.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  Offset _validValue(
    Offset offset,
    Size screenSize, [
    Size? childSize,
  ]) {
    final padding = _constrained ? _constrainedPadding : _padding;
    double width = offset.dx;
    double height = offset.dy;
    if ((width + (childSize?.width ?? 0)) >
        (screenSize.width - padding.right)) {
      width = screenSize.width - padding.right - (childSize?.width ?? 0);
    } else if (width < padding.left) {
      width = padding.left;
    }
    if ((height + (childSize?.height ?? 0)) >
        (screenSize.height - padding.bottom)) {
      height = screenSize.height - padding.bottom - (childSize?.height ?? 0);
    } else if (height < padding.top) {
      height = padding.top;
    }
    return Offset(width, height);
  }
}
