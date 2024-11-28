import 'package:flutter/material.dart';
import 'package:reactter_devtools_extension/src/constants.dart';

class InstanceIcon extends StatelessWidget {
  final NodeKind? nodeKind;
  final bool isDependency;

  const InstanceIcon({
    super.key,
    required this.nodeKind,
    this.isDependency = false,
  });

  @override
  Widget build(BuildContext context) {
    if (nodeKind == null) return const SizedBox();

    return SizedBox.square(
      dimension: 24,
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Badge(
          backgroundColor: isDependency ? Colors.teal : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Center(
              child: CircleAvatar(
                backgroundColor: nodeKind!.color,
                child: Text(
                  nodeKind!.abbr,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
