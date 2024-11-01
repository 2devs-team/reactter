import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// Scrollbar that is offset by the amount specified by an [offsetController].
///
/// This makes it possible to create a [ListView] with both vertical and
/// horizontal scrollbars by wrapping the [ListView] in a
/// [SingleChildScrollView] that handles horizontal scrolling. The
/// [offsetController] is the offset of the parent [SingleChildScrollView] in
/// this example.
///
/// This class could be optimized if performance was a concern using a
/// [CustomPainter] instead of an [AnimatedBuilder] so that the
/// [OffsetScrollbar] widget does not need to build on each change to the
/// [offsetController].
class OffsetScrollbar extends StatefulWidget {
  const OffsetScrollbar({
    super.key,
    this.isAlwaysShown = false,
    required this.axis,
    required this.controller,
    required this.offsetController,
    required this.child,
    required this.offsetControllerViewportDimension,
  });

  final bool isAlwaysShown;
  final Axis axis;
  final ScrollController controller;
  final ScrollController offsetController;
  final Widget child;

  /// The current viewport dimension of the offsetController may not be
  /// available at build time as it is not updated until later so we require
  /// that the known correct viewport dimension is passed into this class.
  ///
  /// This is a workaround because we use an AnimatedBuilder to listen for
  /// changes to the offsetController rather than displaying the scrollbar at
  /// paint time which would be more difficult.
  final double offsetControllerViewportDimension;

  @override
  State<OffsetScrollbar> createState() => _OffsetScrollbarState();
}

class _OffsetScrollbarState extends State<OffsetScrollbar> {
  @override
  Widget build(BuildContext context) {
    if (!widget.offsetController.position.hasContentDimensions) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        if (widget.offsetController.position.hasViewportDimension && mounted) {
          // TODO(jacobr): find a cleaner way to be notified that the
          // offsetController now has a valid dimension. We would probably
          // have to implement our own ScrollbarPainter instead of being able
          // to use the existing Scrollbar widget.
          setState(() {});
        }
      });
    }
    return AnimatedBuilder(
      animation: widget.offsetController,
      builder: (context, child) {
        // Compute a delta to move the scrollbar from where it is by default to
        // where it should be given the viewport dimension of the
        // offsetController not the viewport that is the entire scroll extent
        // of the offsetController because this controller is nested within the
        // offset controller.
        double delta = 0.0;
        if (widget.offsetController.position.hasContentDimensions) {
          delta = widget.offsetController.offset -
              widget.offsetController.position.maxScrollExtent +
              widget.offsetController.position.minScrollExtent;
          if (widget.offsetController.position.hasViewportDimension) {
            // TODO(jacobr): this is a bit of a hack.
            // The viewport dimension from the offsetController may be one frame
            // behind the true viewport dimension. We add this delta so the
            // scrollbar always appears stuck to the side of the viewport.
            delta += widget.offsetControllerViewportDimension -
                widget.offsetController.position.viewportDimension;
          }
        }
        final offset = widget.axis == Axis.vertical
            ? Offset(delta, 0.0)
            : Offset(0.0, delta);
        return Transform.translate(
          offset: offset,
          child: Scrollbar(
            thumbVisibility: widget.isAlwaysShown,
            controller: widget.controller,
            child: Transform.translate(
              offset: -offset,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}
