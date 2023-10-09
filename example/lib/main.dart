import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:floating_overlay/floating_overlay.dart';
import 'package:logging/logging.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final StreamSubscription<LogRecord> _subscription;

  @override
  void initState() {
    super.initState();
    Logger.root.level = Level.ALL;
    _subscription = Logger.root.onRecord.listen(_listener);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Create one of this and pass it to the FloatingOverlay, to be able to pop
    // and push new pages and the floating overlay don't continue showing in
    // all new pages on top and show again when you come back
    final routeObserver = RouteObserver();
    return MaterialApp(
      title: 'Floating Overlay Example',
      navigatorObservers: [routeObserver], // Give it to the main materialApp
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Provider<RouteObserver>(
        // One way to make it avaliable through all your files and pages, but
        // global variables and other means will work just fine as well.
        create: (_) => routeObserver,
        child: const HomePage(),
      ),
    );
  }

  void _listener(LogRecord record) {
    log(
      record.message,
      level: record.level.value,
      name: record.loggerName,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      stackTrace: record.stackTrace,
      error: record.error,
      zone: record.zone,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controller = FloatingOverlayController.absoluteSize(
    prototype: const SizedBox.square(dimension: 100.0),
    padding: const EdgeInsets.all(20.0),
    maxSize: const Size(200, 200),
    minSize: const Size(100, 100),
    constrained: true,
  );

  late RouteObserver<Route<dynamic>> routeObserver;

  @override
  void didChangeDependencies() {
    routeObserver = Provider.of<RouteObserver>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Overlay Example'),
        centerTitle: true,
      ),
      body: FloatingOverlay(
        // Passing the RouteObserver created at line 17 as a parameter, will
        // make so that when you push pages on top of this one, the floating
        // child will vanish and reappear when you return.
        routeObserver: routeObserver,
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
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomButton(
                title: 'Toggle Overlay',
                onPressed: () {
                  controller.toggle();
                },
              ),
              CustomButton(
                title: 'Set Screen Center Offset',
                onPressed: () {
                  final size = MediaQuery.of(context).size;
                  final rect = Rect.fromPoints(
                    Offset.zero,
                    Offset(size.width, size.height),
                  );
                  controller.offset = rect.center;
                },
              ),
              CustomButton(
                title: 'Set Scale to 2.0',
                onPressed: () {
                  controller.scale = 2.0;
                },
              ),
              CustomButton(
                title: 'New Page',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const NewPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    Key? key,
    required this.onPressed,
    required this.title,
  }) : super(key: key);

  final VoidCallback onPressed;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        child: Text(title),
        onPressed: onPressed,
      ),
    );
  }
}

class NewPage extends StatelessWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Page'), centerTitle: true),
    );
  }
}
