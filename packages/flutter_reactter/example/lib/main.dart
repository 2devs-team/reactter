import 'package:flutter/material.dart';

import 'animation/animation_page.dart';
import 'api/api_page.dart';
import 'calculator/calculator_page.dart';
import 'counter/counter_page.dart';
import 'shopping_cart/shopping_cart_page.dart';
import 'todo/todo_page.dart';
import 'tree/tree_page.dart';

final items = [
  ExampleItem(
    "Counter",
    "Increase and decrease the counter",
    [
      "ReactterWatcher",
      "Signal",
    ],
    () => const CounterPage(),
  ),
  ExampleItem(
    "Calculator",
    "Performs simple arithmetic operations on numbers",
    [
      "BuilContext.use",
      "ReactterConsumer",
      "ReactterProvider",
      "ReactterSelector",
      "ReactterWatcher",
      "Signal",
    ],
    () => const CalculatorPage(),
  ),
  ExampleItem(
    "Shopping Cart",
    "Add, remove product to cart and checkout",
    [
      "ReactterComponent",
      "ReactterConsumer",
      "ReactterProvider",
      "ReactterProviders",
      "ReactterSelector",
      "UseInstance",
      "UseState",
    ],
    () => const ShoppingCartPage(),
  ),
  ExampleItem(
    "Tree widget",
    "Add, remove and hide child widget with counter.",
    [
      "BuilContext.use",
      "BuilContext.watchId",
      "Reactter.lazyState",
      "ReactterComponent",
      "ReactterProvider",
      "UseCompute",
      "UseEffect",
      "UseState",
    ],
    () => const TreePage(),
  ),
  ExampleItem(
    "Github Search",
    "Search user or repository and show info about it.",
    [
      "Memo",
      "ReactterConsumer",
      "ReactterProvider",
      "UseAsyncState",
    ],
    () => const ApiPage(),
  ),
  ExampleItem(
    "To-Do List",
    "Add and remove to-do, mark and unmark to-do as done and filter to-do list",
    [
      "Reactter.lazyState",
      "ReactterActionCallable",
      "ReactterComponent",
      "ReactterConsumer",
      "ReactterProvider",
      "ReactterSelector",
      "UseReducer",
    ],
    () => const TodoPage(),
  ),
  ExampleItem(
    "Animate widget",
    "Change size, shape and color.",
    [
      "Reactter.lazyState",
      "ReactterConsumer",
      "ReactterHook",
      "ReactterProvider",
      "ReactterSelector",
      "UseEffect",
      "UseState",
    ],
    () => const AnimationPage(),
  ),
];

final lightTheme = ThemeData.light().copyWith(
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

final darkTheme = ThemeData.dark().copyWith(
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
);

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Reactter Examples"),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = items[index];
            final onTap = item is HeadingItem
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => (item).view(),
                      ),
                    );

            return ListTile(
              title: item.buildTitle(context),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item.buildSubtitle(context),
                  const SizedBox(height: 4),
                  item.buildTags(context),
                ],
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ).copyWith(
                top: item is HeadingItem ? 16 : 8,
              ),
              onTap: onTap,
            );
          },
        ),
      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);

  Widget buildTags(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  const HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();

  @override
  Widget buildTags(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class ExampleItem implements ListItem {
  final String sender;
  final String body;
  final List<String> tags;
  final Widget Function() view;

  const ExampleItem(this.sender, this.body, this.tags, this.view);

  @override
  Widget buildTitle(BuildContext context) =>
      Text(sender, style: Theme.of(context).textTheme.titleMedium);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);

  @override
  Widget buildTags(BuildContext context) {
    tags.sort();

    return Wrap(
      direction: Axis.horizontal,
      spacing: 4,
      runSpacing: 4,
      children: tags.map<Widget>(
        (tag) {
          return Chip(
            labelStyle: Theme.of(context).textTheme.labelMedium,
            label: Text(tag),
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        },
      ).toList(),
    );
  }
}
