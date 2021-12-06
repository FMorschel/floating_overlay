A widget wrapper that allows a floating widget be dragged and rescaled.

## Features

- Floating widget on top of the screen
- Resizing and repositioning the floating widget
- Constrainable space to float inside the tree (optional)
- Limiting borders with padding
- State managment when pushing and poping screens (needs the RouteObserver for managing push)

![FloatingOverlay](https://user-images.githubusercontent.com/52160996/144409885-bbb6e850-c570-4c81-a920-12a08183449d.gif)

## Getting started

Add to your ```pubspec.yaml``` file:

```yaml
dependencies:
  flutter:
    sdk: flutter
  floating_overlay: ^1.0.2
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
