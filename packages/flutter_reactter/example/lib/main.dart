// This file contains the main entry point of the example app.
// It also contains a small example using a global state for the theme mode.
// The main app widget contains a list of examples that can be navigated to.
// Each example has its own page that demonstrates the use of the Reactter package.
// For viewing the examples online, you can visit https://zapp.run/pub/flutter_reactter

import 'package:examples/custom_list.dart';
import 'package:examples/title_oute_observer.dart';
import 'package:examples/examples.dart';
import 'package:examples/page_404.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reactter/flutter_reactter.dart';

// Global state for theme mode
final uThemeMode = UseState(ThemeMode.dark);

class IndexPage extends StatelessWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Reactter | Examples',
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Examples"),
          actions: [
            IconButton(
              tooltip: "Change theme mode",
              icon: RtWatcher((context, watch) {
                // Get and watch the global state
                // This will rebuild the icon button when the global state changes
                // and update the icon to reflect the current theme mode
                final themeMode = watch(uThemeMode).value;

                return Icon(
                  // Use the value of the global state to determine the icon
                  themeMode == ThemeMode.dark
                      ? Icons.light_mode
                      : Icons.dark_mode,
                );
              }),
              onPressed: () {
                // Change the value of the global state to toggle the theme mode
                uThemeMode.value = uThemeMode.value == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              },
            ),
          ],
        ),
        body: CustomList(items: examples),
      ),
    );
  }
}

const indexRoute = '/';
final indexPageKey = GlobalKey();
final routes = {
  indexRoute: (context) => IndexPage(key: indexPageKey),
  for (final e in examples) e.routeName: (context) => e.renderPage(),
};

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RtWatcher((context, watch) {
      // Get and watch the global state
      // This will rebuild the app when the global state changes
      final themeMode = watch(uThemeMode).value;

      return MaterialApp(
        debugShowCheckedModeBanner: false,
        // Use the value of the global state
        themeMode: themeMode,
        theme: ThemeData.light().copyWith(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        darkTheme: ThemeData.dark().copyWith(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        initialRoute: indexRoute,
        routes: routes,
        navigatorObservers: [TitleRouteObserver()],
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (_) => const Page404(),
          );
        },
      );
    });
  }
}

void main() {
  Rt.initializeDevTools();
  runApp(const MyApp());
}
