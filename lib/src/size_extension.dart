part of 'floating_overlay.dart';

extension _SizeExtension on Size {
  /// Gives the lowest scale between this and [other] height and width.
  ///
  /// e.g. this.height / other.height
  double div(Size other) {
    final infinity = double.infinity;
    final heightScale = (other.height != 0) ? (height / other.height) : infinity;
    final widthScale = (other.width != 0) ? (width / other.width) : infinity;
    return (widthScale < heightScale) ? widthScale : heightScale;
  }

  /// Returns this size clamped to be in the range lowerLimit-upperLimit.
  ///
  /// The arguments lowerLimit and upperLimit must form a valid range where
  /// lowerLimit < upperLimit.
  Size clamp(Size lowerLimit, Size upperLimit) {
    assert(lowerLimit < upperLimit);
    if (this < lowerLimit) return lowerLimit;
    if (this > upperLimit) return upperLimit;
    return this;
  }
}
