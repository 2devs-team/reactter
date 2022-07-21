import 'package:flutter/material.dart';

import 'animation/animation_example.dart';
import 'api/api_example.dart';
import 'counter/counter_example.dart';
import 'shopping_cart/shopping_cart_example.dart';
import 'todos/todos_example.dart';
import 'tree/tree_example.dart';

Future<void> main() async {
  runApp(const MyApp());
}

final items = <ListItem>[
  ExampleItem(
    "Counter",
    "Increment and decrement counter",
    [
      "ReactterContext",
      "ReactterProvider",
      "ReactterScope",
      "UseContext",
      "UseState",
    ],
    () => const CounterExample(),
  ),
  ExampleItem(
    "Todos",
    "Add, remove todo to list, mark, unmark todo as completed and filter todo list",
    [
      "ReactterBuilder",
      "ReactterComponent",
      "ReactterContext",
      "ReactterProvider",
      "UseContext",
      "UseState",
      "UseEffect",
    ],
    () => const TodosExamples(),
  ),
  ExampleItem(
    "Shopping Cart",
    "Add, remove product to cart and checkout",
    [
      "ReactterBuilder",
      "ReactterComponent",
      "ReactterContext",
      "ReactterProvider",
      "ReactterProviders",
      "ReactterScope",
      "UseContext",
      "UseState",
      "UseEffect",
    ],
    () => const ShoppingCartExample(),
  ),
  ExampleItem(
    "Tree widget",
    "Add, remove and hide child widget with counter.",
    [
      "ReactterBuilder",
      "ReactterComponent",
      "ReactterContext",
      "ReactterProvider",
      "UseContext",
      "UseState",
    ],
    () => const TreeExample(),
  ),
  ExampleItem(
    "Github Search",
    "Search user or repository and show info about it.",
    [
      "ReactterBuilder",
      "ReactterContext",
      "ReactterComponent",
      "ReactterProvider",
      "UseContext",
      "UseAsyncState",
      "UseState",
    ],
    () => const ApiExample(),
  ),
  ExampleItem(
    "Animate widget",
    "Change size, shape and color.",
    [
      "ReactterBuilder",
      "ReactterContext",
      "ReactterHook",
      "ReactterProvider",
      "UseContext",
      "UseEvent",
    ],
    () => const AnimationExample(),
  ),
];

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData.dark(),
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
