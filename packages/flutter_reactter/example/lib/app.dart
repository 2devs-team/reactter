import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:examples/examples_page.dart';
import 'package:examples/page_404.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      darkTheme: ThemeData.dark().copyWith(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ExamplesPage(),
        for (final e in examples) e.routeName: (context) => e.renderPage(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (_) => const Page404(),
        );
      },
      navigatorObservers: [TitleRouteObserver()],
    );
  }
}

class TitleRouteObserver extends RouteObserver<PageRoute> {
  static Map<String, String> titleRoute = {
    '/': 'Examples',
    for (final e in examples) e.routeName: e.title,
  };

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (route is PageRoute && previousRoute is PageRoute) {
      setTitle(titleRoute[route.settings.name]);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (newRoute is PageRoute && oldRoute is PageRoute) {
      setTitle(titleRoute[newRoute.settings.name]);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (route is PageRoute && previousRoute is PageRoute) {
      setTitle(titleRoute[previousRoute.settings.name]);
    }
  }

  void setTitle([String? title]) async {
    Future.microtask(() {
      SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
          label: "Reactter | ${title ?? ''}",
          primaryColor: Colors.blue.value, // your app primary color
        ),
      );
    });
  }
}
