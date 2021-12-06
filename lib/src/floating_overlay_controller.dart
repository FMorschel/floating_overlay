part of 'floating_overlay.dart';

class FloatingOverlayController {
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
  })  : _offset = _FloatingOverlayOffset(start, padding),
        _constrained = constrained ?? false,
        _scale = _FloatingOverlayScale.relative(
          minScale: minScale,
          maxScale: maxScale,
        );

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
  })  : _offset = _FloatingOverlayOffset(start, padding),
        _constrained = constrained ?? false,
        _scale = _FloatingOverlayScale.absolute(
          maxSize: maxSize,
          minSize: minSize,
        );

  static final _logger = Logger('FloatingOverlayController');
  final _FloatingOverlayOffset _offset;
  final _FloatingOverlayScale _scale;
  final _key = GlobalKey();
  final bool _constrained;
  OverlayState? _overlay;
  OverlayEntry? _entry;
  Widget? _child;

  void _initState(
    BuildContext context,
    Widget floatingChild,
    EdgeInsets newPadding,
  ) {
    _logger.info('Started');
    _child = floatingChild;
    _offset.init(newPadding, _constrained);
    _offset.set(_offset.state, MediaQuery.of(context).size);
    _overlay = Overlay.of(context);
  }

  void _dispose() {
    hide();
    _overlay?.dispose();
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
  void hide() {
    _entry?.remove();
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
        return StreamBuilder<Offset>(
          initialData: _offset.state,
          stream: _offset.stream,
          builder: (context, snapshot) {
            final position = snapshot.data!;
            return Positioned(
              left: position.dx,
              top: position.dy,
              child: StreamBuilder<double>(
                initialData: _scale.state,
                stream: _scale.stream,
                builder: (context, snapshot) {
                  final scale = snapshot.data!;
                  final vector = Vector3(scale, scale, scale);
                  return Transform(
                    alignment: Alignment.topLeft,
                    transform: Matrix4.diagonal3(vector),
                    child: GestureDetector(
                      key: _key,
                      onScaleStart: (_) {
                        _scale.onStart();
                        _offset.onStart(_key, scale);
                      },
                      onScaleUpdate: (details) {
                        _scale.onUpdate(details, _key);
                        _offset.onUpdate(details.delta, _key, scale);
                      },
                      child: _child,
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );

    _overlay?.insert(_entry!);
  }
}
