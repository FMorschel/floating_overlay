part of 'floating_overlay.dart';

class FloatingOverlayData {
  FloatingOverlayData({
    required this.childSize,
    required this.scale,
    required this.position,
  });

  final Size childSize;
  final double scale;
  final Offset position;

  @override
  String toString() {
    return 'FloatingOverlayData('
        'childSize: $childSize, '
        'scale: $scale, '
        'position: $position'
        ')';
  }
}
