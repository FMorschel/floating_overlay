part of 'floating_overlay.dart';

class FloatingOverlayData extends Equatable {
  const FloatingOverlayData({
    required this.childSize,
    required this.scale,
    required this.position,
  });

  final Size childSize;
  final double scale;
  final Offset position;

  Rect get childRect => position & (childSize * scale);

  @override
  String toString() {
    return 'FloatingOverlayData('
        'childSize: $childSize, '
        'scale: $scale, '
        'position: $position'
        ')';
  }

  FloatingOverlayData copyWith({
    Size? childSize,
    double? scale,
    Offset? position,
  }) {
    return FloatingOverlayData(
      childSize: (childSize != Size.zero) && (childSize != null)
          ? childSize
          : this.childSize,
      position: position ?? this.position,
      scale: scale ?? this.scale,
    );
  }

  @override
  List<Object?> get props => [childSize, scale, position];
}
