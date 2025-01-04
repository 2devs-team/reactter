import 'package:flutter/material.dart';
import 'package:examples/custom_list.dart';

import 'examples/1_counter/counter_page.dart';
import 'examples/2_calculator/calculator_page.dart';
import 'examples/3_shopping_cart/shopping_cart_page.dart';
import 'examples/6_tree/tree_page.dart';
import 'examples/4_github_search/github_search_page.dart';
import 'examples/5_todo/todo_page.dart';
import 'examples/7_animation/animation_page.dart';

final examples = [
  ExampleItem(
    "/counter",
    "1. Counter",
    "Increase and decrease the counter",
    [
      "RtWatcher",
      "UseState",
    ],
    () => const CounterPage(),
  ),
  ExampleItem(
    "/calculator",
    "2. Calculator",
    "Performs simple arithmetic operations on numbers",
    [
      "BuilContext.use",
      "RtProvider",
      "RtSelector",
      "RtWatcher",
      "UseState",
    ],
    () => const CalculatorPage(),
  ),
  ExampleItem(
    "/shopping-cart",
    "3. Shopping Cart",
    "Add, remove product to cart and checkout",
    [
      "Rt.lazyState",
      "RtComponent",
      "RtConsumer",
      "RtProvider",
      "RtMultiProvider",
      "RtSelector",
      "RtWatcher",
      "UseDependency",
      "UseState",
    ],
    () => const ShoppingCartPage(),
  ),
  ExampleItem(
    "/github-search",
    "4. Github Search",
    "Search user or repository and show info about it.",
    [
      "Memo",
      "Rt.lazyState",
      "RtConsumer",
      "RtProvider",
      "UseAsyncState",
      "UseDependency",
    ],
    () => const GithubSearchPage(),
  ),
  ExampleItem(
    "/todo",
    "5. To-Do List",
    "Add and remove to-do, mark and unmark to-do as done and filter to-do list",
    [
      "Rt.lazyState",
      "RtActionCallable",
      "RtComponent",
      "RtConsumer",
      "RtProvider",
      "RtSelector",
      "UseReducer",
    ],
    () => const TodoPage(),
  ),
  ExampleItem(
    "/tree",
    "6. Tree widget",
    "Add, remove and hide child widget with counter.",
    [
      "Rt.batch",
      "Rt.createSate",
      "Rt.lazyState",
      "RtContextMixin",
      "RtComponent",
      "RtConsumer",
      "RtProvider",
      "RtState",
      "RtWatcher",
      "UseCompute",
      "UseEffect",
      "UseState",
    ],
    () => const TreePage(),
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
      "RtSelector",
      "UseEffect",
      "UseState",
    ],
    () => const AnimationPage(),
  ),
];

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
