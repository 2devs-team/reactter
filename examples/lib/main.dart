import 'package:examples/calculator/calculator_page.dart';
import 'package:flutter/material.dart';

import 'animation/animation_page.dart';
import 'api/api_page.dart';
import 'counter/counter_page.dart';
import 'shopping_cart/shopping_cart_page.dart';
import 'todos/todos_page.dart';
import 'tree/tree_page.dart';

Future<void> main() async {
  runApp(const MyApp());
}

final items = <ListItem>[
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
      "ReactterContext",
      "ReactterProvider",
      "ReactterWatcher",
      "Signal",
    ],
    () => const CalculatorPage(),
  ),
  ExampleItem(
    "Todos",
    "Add and remove to-do, mark and unmark to-do as done and filter to-do list",
    [
      "ReactterActionCallable",
      "ReactterContext",
      "ReactterProvider",
      "UseReducer",
    ],
    () => const TodosPage(),
  ),
  ExampleItem(
    "Shopping Cart",
    "Add, remove product to cart and checkout",
    [
      "ReactterComponent",
      "ReactterContext",
      "ReactterProvider",
      "ReactterProviders",
      "ReactterScope",
      "UseState",
    ],
    () => const ShoppingCartPage(),
  ),
  ExampleItem(
    "Tree widget",
    "Add, remove and hide child widget with counter.",
    [
      "ReactterComponent",
      "ReactterContext",
      "ReactterProvider",
      "UseState",
    ],
    () => const TreePage(),
  ),
  ExampleItem(
    "Github Search",
    "Search user or repository and show info about it.",
    [
      "ReactterContext",
      "ReactterProvider",
      "UseAsyncState",
    ],
    () => const ApiPage(),
  ),
  ExampleItem(
    "Animate widget",
    "Change size, shape and color.",
    [
      "ReactterContext",
      "ReactterHook",
      "ReactterProvider",
      "UseEvent",
    ],
    () => const AnimationPage(),
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark().copyWith(
        toggleableActiveColor: ThemeData.dark().colorScheme.primary,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Reactter Examples"),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            final item = items[index];

            return ListTile(
              onTap: item is HeadingItem
                  ? null
                  : () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => (item as ExampleItem).view(),
                        ),
                      ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 8, horizontal: 16)
                      .copyWith(top: item is HeadingItem ? 16 : 8),
              title: item.buildTitle(context),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  item.buildSubtitle(context),
                  const SizedBox(
                    height: 4,
                  ),
                  item.buildTags(context),
                ],
              ),
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

  HeadingItem(this.heading);

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
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

  ExampleItem(this.sender, this.body, this.tags, this.view);

  @override
  Widget buildTitle(BuildContext context) => Text(sender);

  @override
  Widget buildSubtitle(BuildContext context) => Text(body);

  @override
  Widget buildTags(BuildContext context) {
    tags.sort();

    return Wrap(
      direction: Axis.horizontal,
      spacing: 4,
      children: tags
          .map<Widget>(
            (tag) => Text(
              tag,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: Colors.blue),
            ),
          )
          .toList(),
    );
  }
}
