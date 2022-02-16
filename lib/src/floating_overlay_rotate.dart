part of 'floating_overlay.dart';

class FloatingOverlayRotation {
  const FloatingOverlayRotation.degrees({
    double? min,
    double? max,
  })  : minimum = min ?? 0.0,
        maximum = max ?? 0.0,
        assert((min ?? 0) <= (max ?? 0));

  const FloatingOverlayRotation.radians({
    double? min,
    double? max,
  })  : minimum = (min ?? 0.0) / (2 * pi) * 360,
        maximum = (max ?? 0.0) / (2 * pi) * 360,
        assert((min ?? 0) <= (max ?? 0));

  static const noRotation = FloatingOverlayRotation.degrees(
    min: 0,
    max: 0,
  );

  static const fullRotation = FloatingOverlayRotation.degrees(
    min: 0,
    max: 360,
  );

  final double minimum;
  final double maximum;
}

class _FloatingOverlayRotation extends Cubit<double> {
  _FloatingOverlayRotation({
    double? initialState,
    double? min,
    double? max,
  })  : assert((min ?? 0.0) <= (max ?? 0.0)),
        _min = (initialState ?? 0) - (min ?? 0.0),
        _max = (initialState ?? 0) + (max ?? 0.0),
        _lastRotation = initialState ?? 0,
        super(initialState ?? 0) {
    if (_max - _min >= 360) {
      _max = double.infinity;
      _min = double.negativeInfinity;
    }
    if (_max.isNegative && _min.isNegative) {
      _max += 360;
      _min += 360;
    }
  }

  factory _FloatingOverlayRotation.fromRotationValues({
    double? initialState,
    FloatingOverlayRotation rotation = FloatingOverlayRotation.noRotation,
  }) {
    return _FloatingOverlayRotation(
      initialState: initialState,
      max: rotation.maximum,
      min: rotation.minimum,
    );
  }

  double _min;
  double _max;
  double _lastRotation;

  bool get canRotate => min != max;

  void onUpdate(double rotation, FloatingOverlayData data) {
    emit((_lastRotation + rotation).clamp(_min, _max));
  }

  void set(double rotation, FloatingOverlayData data) {
    emit(rotation.clamp(_min, _max));
    onEnd();
  }

  void onEnd() {
    _lastRotation = state;
  }

  void rotateWithOffset(Offset offset, FloatingOverlayData data) {
    final rotation = _degreeFrom(offset);
    onUpdate(_lastRotation - rotation, data);
  }

  double _degreeFrom(Offset offset) {
    final opposite = offset.dx;
    final adjacent = offset.dy;
    final hypotenuse = _hypotenuseFrom(opposite, adjacent);
    final degreeFromSine = _sineFrom(adjacent, hypotenuse);
    final degreeFromCosine = _cosineFrom(opposite, hypotenuse);
    switch (_quadrant(offset)) {
      case _Quadrant.first:
        return degreeFromSine;
      case _Quadrant.second:
        return degreeFromCosine;
      case _Quadrant.third:
        return 360 - degreeFromCosine;
      case _Quadrant.fourth:
        return 360 + degreeFromSine;
    }
  }

  double _hypotenuseFrom(double opposite, double adjacent) {
    return sqrt(pow(opposite, 2) + pow(adjacent, 2));
  }

  double _cosineFrom(double adjacent, double hypotenuse) {
    if (hypotenuse != 0) {
      return acos(adjacent / hypotenuse) / pi * 180;
    }
    return 0;
  }

  double _sineFrom(double opposite, double hypotenuse) {
    if (hypotenuse != 0) {
      return asin(opposite / hypotenuse) * 2 / pi * 90;
    }
    return 0;
  }

  _Quadrant _quadrant(Offset offset) {
    if (!offset.dy.isNegative) {
      if (!offset.dx.isNegative) {
        return _Quadrant.first;
      } else {
        return _Quadrant.second;
      }
    } else {
      if (!offset.dx.isNegative) {
        return _Quadrant.fourth;
      } else {
        return _Quadrant.third;
      }
    }
  }
}

enum _Quadrant {
  first,
  second,
  third,
  fourth,
}
