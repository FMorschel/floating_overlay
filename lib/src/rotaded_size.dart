part of 'floating_overlay.dart';

extension _RotatedSize on Size {
  Size rotationed(double rotation) {
    final degrees = _degrees(rotation);
    if ((degrees % 90) == 0) {
      return _unalteredSize(degrees, this);
    } else {
      return _alteredSize(degrees, this);
    }
  }

  static Size _alteredSize(double degrees, Size size) {
    final radians = (degrees * (2 * pi) / 360) % (pi / 2);
    switch (_quadrantFrom(degrees)) {
      case _Quadrant.first:
      case _Quadrant.third:
        return _rotatedAlteredSize(radians, size);
      case _Quadrant.second:
      case _Quadrant.fourth:
        return _rotatedAlteredSize(radians, size.flipped);
    }
  }

  static Size _rotatedAlteredSize(double radians, Size size) {
    final newWidth = _adjacent(size.height, radians) +
        _adjacent(size.width, (pi / 2) - radians);
    final newHeight = _opposite(size.height, radians) +
        _opposite(size.width, (pi / 2) - radians);
    return Size(newWidth, newHeight);
  }

  static Size _unalteredSize(double degrees, Size size) {
    if ((degrees ~/ 90).isEven) {
      return size;
    } else {
      return size.flipped;
    }
  }

  static double _degrees(double rotation) {
    double degrees = rotation % 360;
    if (degrees.isNegative) degrees += 360;
    return degrees;
  }

  static double _adjacent(double hypotenuse, double radians) {
    return cos(radians) * hypotenuse;
  }

  static double _opposite(double hypotenuse, double radians) {
    return sin(radians) * hypotenuse;
  }

  static _Quadrant _quadrantFrom(double rotation) {
    double degrees = rotation % 360;
    if (degrees.isNegative) degrees *= -1;
    if (degrees < 90) {
      return _Quadrant.first;
    } else if (degrees < 180) {
      return _Quadrant.second;
    } else if (degrees < 270) {
      return _Quadrant.third;
    } else {
      return _Quadrant.fourth;
    }
  }
}