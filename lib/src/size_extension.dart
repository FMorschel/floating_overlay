part of 'floating_overlay.dart';

extension _SizeExtension on Size {
  /// Gives the lowest scale between this and [other] height and width.
  ///
  /// e.g. this.height / other.height
  double div(Size other) {
    final infinity = double.infinity;
    final heightScale =
        (other.height != 0) ? (height / other.height) : infinity;
    final widthScale = (other.width != 0) ? (width / other.width) : infinity;
    return (widthScale < heightScale) ? widthScale : heightScale;
  }

  /// Returns this size clamped to be in the range lowerLimit-upperLimit.
  ///
  /// The arguments lowerLimit and upperLimit must form a valid range where
  /// `(lowerLimit.height < upperLimit.height) && (lowerLimit.width <
  /// upperLimit.width)`.
  Size clamp(Size lowerLimit, Size upperLimit) {
    assert(lowerLimit.height < upperLimit.height);
    assert(lowerLimit.width < upperLimit.width);
    if (height < lowerLimit.height) return lowerLimit;
    if (width < lowerLimit.width) return lowerLimit;
    if (height > upperLimit.height) return upperLimit;
    if (width > upperLimit.width) return upperLimit;
    return this;
  }
}
