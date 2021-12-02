<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

A widget wrapper that allows a floating widget be dragged and rescaled.

## Features

TODO: List what your package can do. Maybe include images, gifs, or videos.

## Getting started

Add to your ```pubspec.yaml``` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  floating_overlay: 1.0.0
```

Import the package

```dart
import 'package:floating_overlay/floating_overlay.dart';
```

## Usage

Create a FloatingOverlayController

```dart
final controller = FloatingOverlayController.absoluteSize(
  maxSize: const Size(200, 200),
  minSize: const Size(100, 100),
  start: Offset.zero,
  padding: const EdgeInsets.all(20.0),
  constrained: true,
);
```

or

```dart
final controller = FloatingOverlayController.relativeSize(
  maxScale: 2.0,
  minScale: 1.0,
  start: Offset.zero,
  padding: const EdgeInsets.all(20.0),
  constrained: true,
);
```

Insert the FloatingOverlay widget inside your widget tree and give it the controller, a child and a floatingChild.

```dart
FloatingOverlay(
  controller: controller,
  floatingChild: SizedBox.square(
    dimension: 100.0,
    child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(
          color: Colors.black,
          width: 5.0,
        ),
      ),
    ),
  ),
  child: Container(),
);
```

Then use the controller to make the floating child show or hide.

```dart
controller.hide();
controller.isFloating;
controller.show();
controller.toggle();
```
