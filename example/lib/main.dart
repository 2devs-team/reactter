import 'package:example/app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reactter/presentation/reactter_create_context.dart';
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CreateContext(
        controllers: [
          ContextProvider<AppController>(() => AppController(), init: true)
        ],
        child: CreateContext(
          controllers: [
            ContextProvider<AppController>(() => AppController(), init: true)
          ],
          child: const ExamplePage(),
        ),
      ),
      navigatorObservers: [_routingController],
    );
  }
}
