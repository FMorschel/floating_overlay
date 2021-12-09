part of 'floating_overlay.dart';

class FloatingOverlayController extends Cubit<FloatingOverlayData> {
  /// The controller for the [FloatingOverlay].
  ///
  /// Be sure to initialize this only once (probably inside `initState` method)
  /// when inside a Stateful Widget that has an [AnimationController] inside.
  FloatingOverlayController.relativeSize({
    /// Minimum scale to resize the floating child.
    double? minScale,

    /// Maximum scale to resize the floating child.
    double? maxScale,

    /// Padding inside the constraints of the floating child's space to float.
    EdgeInsets? padding,

    /// Offset inside the constraints of the floating child's space to float.
    Offset? start,

    /// If the floating child's space to float will be limited by the maximum
    /// size that the FloatingOverlay can be.
    bool? constrained,
  })  : _offset = _FloatingOverlayOffset(start: start, padding: padding),
        _constrained = constrained ?? false,
        _scale = _FloatingOverlayScale.relative(
          minScale: minScale,
          maxScale: maxScale,
        ),
        super(
          FloatingOverlayData(
            childSize: Size.zero,
            scale: 1.0,
            position: _FloatingOverlayOffset(
              start: start,
              padding: padding,
            ).state,
          ),
        );

  /// The controller for the [FloatingOverlay].
  ///
  /// Be sure to initialize this only once (probably inside `initState` method)
  /// when inside a Stateful Widget that has an [AnimationController] inside.
  FloatingOverlayController.absoluteSize({
    /// Minimum size to resize the floating child.
    Size? minSize,

    /// Maximum size to resize the floating child.
    Size? maxSize,

    /// Padding inside the constraints of the floating child's space to float.
    EdgeInsets? padding,

    /// Offset inside the constraints of the floating child's space to float.
    Offset? start,

    /// If the floating child's space to float will be limited by the maximum
    /// size that the FloatingOverlay can be.
    bool? constrained,
  })  : _offset = _FloatingOverlayOffset(start: start, padding: padding),
        _constrained = constrained ?? false,
        _scale = _FloatingOverlayScale.absolute(
          maxSize: maxSize,
          minSize: minSize,
        ),
        super(
          FloatingOverlayData(
            childSize: Size.zero,
            scale: 1.0,
            position: _FloatingOverlayOffset(
              start: start,
              padding: padding,
            ).state,
          ),
        );

  static final _logger = Logger('FloatingOverlayController');
  final _FloatingOverlayOffset _offset;
  final _FloatingOverlayScale _scale;
  final bool _constrained;
  GlobalKey? _key;
  OverlayState? _overlay;
  OverlayEntry? _entry;
  Widget? _child;

  void _initState(
    BuildContext context,
    Widget floatingChild,
    EdgeInsets newPadding,
    GlobalKey key,
  ) {
    _logger.info('Started');
    _key = key;
    _child = floatingChild;
    _offset.init(newPadding, _constrained);
    _offset.set(_offset.state, MediaQuery.of(context).size);
    _overlay = Overlay.of(context);
  }

  void _dispose() {
    hide(true);
    _offset.close();
    _scale.close();
    _overlay = null;
    _logger.info('Disposed');
  }

  // Toggles the floating child's visibility.
  void toggle() {
    _logger.info('Toggled');
    if (isFloating) {
      hide();
    } else {
      show();
    }
  }

  // Hides the floating child.
  void hide([bool dispose = false]) {
    _entry?.remove();
    if (dispose) _entry?.dispose();
    _entry = null;
    _logger.info('Hidden overlay');
  }

  // The floating child's visibility.
  bool get isFloating => _entry != null;

  // Shows the floating child.
  void show() {
    _logger.info('Showing overlay');
    _entry = OverlayEntry(
      builder: (context) {
        return _Reposition(
          offsetController: _offset,
          child: _Rescale(
            scaleController: _scale,
            child: GestureDetector(
              key: _key,
              onScaleStart: (details) {
                _scale.onStart(_offset, _key!);
                _offset.onStart(_scale, _key!, details.focalPoint);
              },
              onScaleUpdate: (details) {
                _scale.onUpdate(details.scale);
                _offset.onUpdate(details.focalPoint);
              },
              child: floatingChild(),
            ),
          ),
        );
      },
    );

    _overlay?.insert(_entry!);
  }

  Size get _childSize {
    final _context = _key!.currentContext!;
    final box = _context.findRenderObject() as RenderBox?;
    return box?.size ?? Size.zero;
  }

  Widget floatingChild() {
    return Builder(
      builder: (context) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          final data = FloatingOverlayData(
            position: _offset.state,
            childSize: _childSize,
            scale: _scale.state,
          );
          emit(data);
        });
        return _child ?? const SizedBox.shrink();
      },
    );
  }
}
