import 'package:flutter/material.dart';
import 'package:reactter_devtools_extension/src/widgets/offset_scrollbar.dart';

class BidirectionalScrollView extends StatelessWidget {
  final double maxWidth;
  final Widget Function(BuildContext, BoxConstraints) builder;
  final ScrollController? scrollControllerX;
  final ScrollController? scrollControllerY;

  const BidirectionalScrollView({
    super.key,
    this.scrollControllerX,
    this.scrollControllerY,
    required this.maxWidth,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final scrollControllerX = this.scrollControllerX ?? ScrollController();
    final scrollControllerY = this.scrollControllerY ?? ScrollController();

    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;

        return Scrollbar(
          controller: scrollControllerX,
          thumbVisibility: true,
          child: SingleChildScrollView(
            controller: scrollControllerX,
            scrollDirection: Axis.horizontal,
            child: Material(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: viewportWidth > maxWidth ? viewportWidth : maxWidth,
                ),
                child: OffsetScrollbar(
                  isAlwaysShown: true,
                  axis: Axis.vertical,
                  controller: scrollControllerY,
                  offsetController: scrollControllerX,
                  offsetControllerViewportDimension: viewportWidth,
                  child: builder(context, constraints),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
