part of 'floating_overlay.dart';

class FloatingOverlayData extends Equatable {
  const FloatingOverlayData({
    required this.childSize,
    required this.scale,
    required this.position,
    required this.rotation,
  });

  final Size childSize;
  final double scale;
  final Offset position;
  final double rotation;

  Rect get childRect => position & (childSize * scale);

  Rect get rotatedRect {
    final rotatedSize = (childSize * scale).rotationed(rotation);
    final size = rotatedSize - childRect.size;
    return (position - (size as Offset) / 2) & rotatedSize;
  }

  @override
  String toString() {
    return 'FloatingOverlayData('
        'childSize: $childSize, '
        'scale: $scale, '
        'rotation: $rotation, '
        'position: $position'
        ')';
  }

  FloatingOverlayData copyWith({
    Size? childSize,
    double? scale,
    Offset? position,
    double? rotation,
  }) {
    return FloatingOverlayData(
      childSize: (childSize != Size.zero) && (childSize != null)
          ? childSize
          : this.childSize,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
    );
  }

  @override
  List<Object?> get props => [childSize, scale, position, rotation];
}
