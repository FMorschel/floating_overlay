import 'package:flutter/material.dart';
import 'package:floating_overlay/floating_overlay.dart';

import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // Create one of this and pass it to the FloatingOverlay, to be able to pop 
    // and push new pages and the floating overlay don't continue showing in 
    // all new pages on top and show again when you come back
    final routeObserver = RouteObserver<ModalRoute<void>>();
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
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = FloatingOverlayController.absoluteSize(
      maxSize: const Size(200, 200),
      minSize: const Size(100, 100),
      padding: const EdgeInsets.all(20.0),
      constrained: true,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Floating Overlay Example'),
        centerTitle: true,
      ),
      body: FloatingOverlay(
        // Passing the RouteObserver created at line 17 as a parameter, will
        // make so that when you push pages on top of this one, the floating
        // child will vanish and reappear when you return.
        routeObserver: Provider.of<RouteObserver>(context, listen: false),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('Toggle Overlay'),
                  onPressed: () {
                    controller.toggle();
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: const Text('New Page'),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const NewPage()),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
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
