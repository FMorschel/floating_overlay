library floating_overlay;

import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

part 'floating_overlay_controller.dart';
part 'floating_overlay_offset.dart';
part 'floating_overlay_scale.dart';

class FloatingOverlay extends StatefulWidget {
  const FloatingOverlay({
    Key? key,
    this.child,
    this.controller,
    this.floatingChild,
    this.routeObserver,
  }) : super(key: key);

  final Widget? child;
  final Widget? floatingChild;
  final FloatingOverlayController? controller;
  final RouteObserver? routeObserver;

  @override
  State<FloatingOverlay> createState() => _FloatingOverlayState();
}

class _FloatingOverlayState extends State<FloatingOverlay> with RouteAware {
  static const empty = SizedBox.square(dimension: 0);
  final key = GlobalKey();
  late final FloatingOverlayController controller;

  bool floating = false;

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
  void initState() {
    controller = widget.controller ?? FloatingOverlayController.relativeSize();
    super.initState();
  }

  @override
  void dispose() {
    widget.routeObserver?.unsubscribe(this);
    controller.dispose();
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
          WidgetsBinding.instance?.addPostFrameCallback((_) {
            final screen = MediaQuery.of(context).size;
            final box = key.currentContext!.findRenderObject()! as RenderBox;
            final offset = box.localToGlobal(Offset.zero);
            final padding = EdgeInsets.fromLTRB(
              offset.dx,
              offset.dy,
              screen.width - (offset.dx + constraints.maxWidth),
              screen.height - (offset.dy + constraints.maxHeight),
            );
            controller.initState(
              context,
              widget.floatingChild ?? empty,
              padding,
            );
          });
          return widget.child ?? empty;
        },
      ),
    );
  }
}
