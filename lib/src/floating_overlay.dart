library floating_overlay;

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

part 'floating_overlay_controller.dart';
part 'floating_overlay_offset.dart';
part 'floating_overlay_scale.dart';
part 'floating_overlay_data.dart';

class FloatingOverlay extends StatefulWidget {
  const FloatingOverlay({
    Key? key,

    /// The child underneath this widget inside the widget tree.
    this.child,

    /// Used to controll the visibility state of the [floatingChild].
    this.controller,

    /// Widget that will be floating around.
    this.floatingChild,

    /// When you push pages on top, the floating child will vanish and reappear
    /// when you return if you give it an RouteObserver linked to the main
    /// MaterialApp.
    this.routeObserver,
  }) : super(key: key);

  /// The child underneath this widget inside the widget tree.
  final Widget? child;

  /// Widget that will be floating around.
  final Widget? floatingChild;

  /// Used to controll the visibility state of the [floatingChild].
  final FloatingOverlayController? controller;

  /// When you push pages on top, the floating child will vanish and reappear
  /// when you return if you give it an RouteObserver linked to the main
  /// MaterialApp.
  final RouteObserver? routeObserver;

  @override
  State<FloatingOverlay> createState() => _FloatingOverlayState();
}

class _FloatingOverlayState extends State<FloatingOverlay> with RouteAware {
  static const empty = SizedBox.shrink();

  late final FloatingOverlayController controller;
  final key = GlobalKey();
  final floatingWidgetKey = GlobalKey();
  bool floating = false;

  void startController(BuildContext context, BoxConstraints constraints) {
    final screen = MediaQuery.of(context).size;
    final box = key.currentContext!.findRenderObject()! as RenderBox;
    final offset = box.localToGlobal(Offset.zero);
    final padding = EdgeInsets.fromLTRB(
      offset.dx,
      offset.dy,
      screen.width - (offset.dx + constraints.maxWidth),
      screen.height - (offset.dy + constraints.maxHeight),
    );
    controller._initState(
      context,
      widget.floatingChild ?? empty,
      padding,
      floatingWidgetKey,
    );
  }

  @override
  void initState() {
    controller = widget.controller ?? FloatingOverlayController.relativeSize();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.routeObserver?.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    if (floating) {
      controller.show();
    }
  }

  @override
  void didPushNext() {
    floating = controller.isFloating;
    if (floating) {
      controller.hide();
    }
  }

  @override
  void dispose() {
    widget.routeObserver?.unsubscribe(this);
    controller._dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      key: key,
      onWillPop: () async {
        controller.hide();
        return true;
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          WidgetsBinding.instance?.addPostFrameCallback(
            (_) => startController(context, constraints),
          );
          return widget.child ?? empty;
        },
      ),
    );
  }
}
