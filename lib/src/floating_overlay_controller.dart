part of 'floating_overlay.dart';

class FloatingOverlayController {
  FloatingOverlayController.relativeSize({
    double? minScale,
    double? maxScale,
    EdgeInsets? padding,
    Offset? start,
    bool? constrained,
  })  : _offset = FloatingOverlayOffset(start, padding),
        _constrained = constrained ?? false,
        _scale = FloatingOverlayScale.relative(
          minScale: minScale,
          maxScale: maxScale,
        );

  FloatingOverlayController.absoluteSize({
    Size? minSize,
    Size? maxSize,
    EdgeInsets? padding,
    Offset? start,
    bool? constrained,
  })  : _offset = FloatingOverlayOffset(start, padding),
        _constrained = constrained ?? false,
        _scale = FloatingOverlayScale.absolute(
          maxSize: maxSize,
          minSize: minSize,
        );

  static final _logger = Logger('FloatingOverlayController');
  final FloatingOverlayOffset _offset;
  final FloatingOverlayScale _scale;
  final GlobalKey key = GlobalKey();
  final bool _constrained;
  OverlayState? _overlay;
  OverlayEntry? _entry;
  Widget? _child;

  void toggle() {
    _logger.info('Toggled');
    if (isFloating) {
      hide();
    } else {
      show();
    }
  }

  void initState(
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

  bool get isFloating => _entry != null;

  void dispose() {
    hide();
    _overlay?.dispose();
    _logger.info('Disposed');
  }

  void hide() {
    _entry?.remove();
    _entry = null;
    _logger.info('Hidden overlay');
  }

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
                      key: key,
                      onScaleStart: (_) {
                        _scale.onStart();
                        _offset.onStart(key, scale);
                      },
                      onScaleUpdate: (details) {
                        _scale.onUpdate(details, key);
                        _offset.onUpdate(details.delta, key, scale);
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
