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
    bool constrained = false,
  })  : _offset = _FloatingOverlayOffset(
          start: start,
          padding: padding,
          constrained: constrained,
        ),
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
        ) {
    _streamProcess();
  }

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
    bool constrained = false,
  })  : _offset = _FloatingOverlayOffset(
          start: start,
          padding: padding,
          constrained: constrained,
        ),
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
        ) {
    _streamProcess();
  }

  void _streamProcess() {
    _offset.stream.listen((offset) {
      emit(state.copyWith(position: offset));
    });
    _scale.stream.listen((scale) {
      emit(state.copyWith(scale: scale));
    });
  }

  static final _logger = Logger('FloatingOverlayController');
  final _FloatingOverlayOffset _offset;
  final _FloatingOverlayScale _scale;
  final _key = GlobalKey();
  OverlayState? _overlay;
  OverlayEntry? _entry;
  Widget? _child;

  void _initState(
    BuildContext context,
    Widget floatingChild,
    Rect limits,
  ) {
    _logger.info('Started');
    _child ??= floatingChild;
    _offset.init(limits, MediaQuery.of(context).size);
    _overlay = Overlay.of(context);
    _createInvisibleChild(_startChildSize);
    _scale.init(_offset.floatingLimits!);
    _offset.set(_offset.state, state.childRect.size);
  }

  void _dispose() {
    hide(true);
    _offset.close();
    _scale.close();
    _overlay = null;
    _logger.info('Disposed');
  }

  void _createInvisibleChild(VoidCallback postFrameCallback) {
    _logger.info('Creating invisible entry');
    _entry = OverlayEntry(
      builder: (context) {
        WidgetsBinding.instance?.addPostFrameCallback((_) {
          postFrameCallback();
          _logger.info('Destroying invisible entry');
          hide();
        });
        return Offstage(
          offstage: true,
          child: SizedBox.shrink(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: _floatingChild,
            ),
          ),
        );
      },
    );
    _overlay?.insert(_entry!);
  }

  void _startChildSize() {
    _logger.info('Strating child size');
    emit(state.copyWith(childSize: _childSize));
  }

  Size get _childSize {
    final box = _key.currentContext!.findRenderObject()! as RenderBox;
    return box.size;
  }

  /// Update the offset of the floating widget.
  set offset(Offset global) => _offset.setGlobal(global, state);

  /// Returns the constrained `Rect` in which the widget can float.
  ///
  /// This value is null until the [FloatingOverlay] is initiated.
  Rect? get floatingLimits => _offset.floatingLimits;

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
    _logger.info('Entry removed');
  }

  // The floating child's visibility.
  bool get isFloating => _entry != null;

  // Shows the floating child.
  void show() {
    _logger.info('Showing entry');
    _entry = OverlayEntry(
      builder: (context) {
        return _entryWidget;
      },
    );
    _overlay?.insert(_entry!);
  }

  Widget get _entryWidget {
    return _Reposition(
      offsetController: _offset,
      child: _Rescale(
        data: state,
        scaleController: _scale,
        child: GestureDetector(
          onScaleStart: (details) {
            _scale.onStart();
            _offset.onStart(details.focalPoint);
          },
          onScaleUpdate: (details) {
            _scale.onUpdate(details.scale, state);
            final previousScale = _scale._previousScale;
            _offset.onUpdate(details.focalPoint, state, previousScale);
          },
          onScaleEnd: (_) {
            _offset.onEnd();
          },
          child: Builder(
            builder: (context) {
              WidgetsBinding.instance?.addPostFrameCallback(
                (_) => emit(
                  state.copyWith(
                    position: _offset.state,
                    childSize: _childSize,
                    scale: _scale.state,
                  ),
                ),
              );
              return _floatingChild;
            },
          ),
        ),
      ),
    );
  }

  Widget get _floatingChild {
    return Container(
      key: _key,
      child: _child ?? const SizedBox.shrink(),
    );
  }
}
