import 'package:flutter/material.dart';

const kCoverColors = [...Colors.primaries, ...Colors.accents];

class ProductCover extends StatelessWidget {
  final int index;

  const ProductCover({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kCoverColors[index % kCoverColors.length],
      child: FittedBox(
        child: Text(
          String.fromCharCode(index + 65),
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }
}
