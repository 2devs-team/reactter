import 'package:flutter/material.dart';
import '../../engine/widgets/reactter_inherit_provider.dart';
import '../../engine/widgets/reactter_inherit_provider_scope_element.dart';

class ReactterInheritedProviderScope extends InheritedWidget {
  const ReactterInheritedProviderScope({
    required this.owner,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  final ReactterInheritedProvider owner;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  @override
  ReactterInheritedProviderScopeElement createElement() {
    return ReactterInheritedProviderScopeElement(this);
  }
}
