import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'example_page.dart';
import 'package:reactter/reactter.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(RoutingController());

    final _routingController = Get.find<RoutingController>();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      smartManagement: SmartManagement.keepFactory,
      supportedLocales: const [
        Locale('es'),
        Locale('en'),
      ],
      routingCallback: _routingController.routingCallback,
      initialRoute: '/example_page',
      getPages: [
        GetPage(
          name: '/example_page',
          page: () => const ExamplePage(),
          transition: Transition.noTransition,
        ),
      ],
      navigatorObservers: [_routingController],
    );
  }
}
