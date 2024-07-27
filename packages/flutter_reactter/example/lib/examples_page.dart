import 'package:flutter/material.dart';
import 'package:examples/custom_list.dart';

import 'examples/1_counter/counter_page.dart';
import 'examples/2_calculator/calculator_page.dart';
import 'examples/4_shopping_cart/shopping_cart_page.dart';
import 'examples/3_tree/tree_page.dart';
import 'examples/5_api/api_page.dart';
import 'examples/6_todo/todo_page.dart';
import 'examples/7_animation/animation_page.dart';

final examples = [
  ExampleItem(
    "/counter",
    "1. Counter",
    "Increase and decrease the counter",
    [
      "ReactterWatcher",
      "Signal",
    ],
    () => const CounterPage(),
  ),
  ExampleItem(
    "/calculator",
    "2. Calculator",
    "Performs simple arithmetic operations on numbers",
    [
      "BuilContext.use",
      "Rt.batch",
      "RtConsumer",
      "RtProvider",
      "ReactterSelector",
      "ReactterWatcher",
      "Signal",
    ],
    () => const CalculatorPage(),
  ),
  ExampleItem(
    "/tree",
    "3. Tree widget",
    "Add, remove and hide child widget with counter.",
    [
      "BuilContext.use",
      "BuilContext.watchId",
      "Rt.lazyState",
      "RtComponent",
      "RtProvider",
      "UseCompute",
      "UseEffect",
      "UseState",
    ],
    () => const TreePage(),
  ),
  ExampleItem(
    "/shopping-cart",
    "4. Shopping Cart",
    "Add, remove product to cart and checkout",
    [
      "Rt.lazyState",
      "RtComponent",
      "RtConsumer",
      "RtProvider",
      "ReactterProviders",
      "ReactterSelector",
      "UseDependency",
      "UseState",
    ],
    () => const ShoppingCartPage(),
  ),
  ExampleItem(
    "/api",
    "5. Github Search",
    "Search user or repository and show info about it.",
    [
      "Memo",
      "RtConsumer",
      "RtProvider",
      "UseAsyncState",
    ],
    () => const ApiPage(),
  ),
  ExampleItem(
    "/todo",
    "6. To-Do List",
    "Add and remove to-do, mark and unmark to-do as done and filter to-do list",
    [
      "Rt.lazyState",
      "RtActionCallable",
      "RtComponent",
      "RtConsumer",
      "RtProvider",
      "ReactterSelector",
      "UseReducer",
    ],
    () => const TodoPage(),
  ),
  ExampleItem(
    "/animation",
    "7. Animate widget",
    "Change size, shape and color.",
    [
      "Rt.lazyState",
      "RtConsumer",
      "RtHook",
      "RtProvider",
      "ReactterSelector",
      "UseEffect",
      "UseState",
    ],
    () => const AnimationPage(),
  ),
];

class ExamplesPage extends StatelessWidget {
  const ExamplesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Title(
      title: 'Reactter | Exmaples',
      color: Theme.of(context).primaryColor,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Examples"),
        ),
        body: CustomList(items: examples),
      ),
    );
  }
}

/// A ListItem that contains data to display a message.
class ExampleItem implements ListItem {
  final String routeName;
  final String title;
  final String description;
  final List<String> tags;
  final Widget Function() renderPage;

  const ExampleItem(
    this.routeName,
    this.title,
    this.description,
    this.tags,
    this.renderPage,
  );

  @override
  Widget buildTitle(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleMedium);
  }

  @override
  Widget buildSubtitle(BuildContext context) {
    return Text(description);
  }

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

  @override
  void onTap(BuildContext context) {
    Navigator.of(context).pushNamed(routeName);
  }
}
