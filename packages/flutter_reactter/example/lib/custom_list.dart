import 'package:flutter/material.dart';

class CustomList extends StatelessWidget {
  final List<ListItem> items;

  const CustomList({Key? key, required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        final item = items[index];

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
          onTap: () => item.onTap(context),
        );
      },
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);

  /// The tags to show in a list item.
  Widget buildTags(BuildContext context);

  /// The callback function to call when the item is tapped.
  void onTap(BuildContext context);
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

  @override
  void onTap(BuildContext context) {}
}
