import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_types.dart';
import 'package:reactter/engine/widgets/reactter_inherit_provider_scope.dart';
import 'package:reactter/widgets/reactter_use_provider.dart';

class _Dependency<T> {
  bool shouldClearSelectors = false;
  bool shouldClearMutationScheduled = false;
  final selectors = <SelectorAspect<T>>[];
}

class ReactterInheritedProviderScopeElement extends InheritedElement {
  ReactterInheritedProviderScopeElement(ReactterInheritedProviderScope widget)
      : super(widget);

  // static int _nextProviderId = 0;

  // bool _shouldNotifyDependents = false;
  // bool _debugInheritLocked = false;
  // bool _isNotifyDependentsEnabled = true;
  // bool _firstBuild = true;
  bool _updatedShouldNotify = false;
  // bool _isBuildFromExternalSources = false;
  // late String _debugId;

  @override
  ReactterInheritedProviderScope get widget =>
      super.widget as ReactterInheritedProviderScope;

  T? getInstance<T>() {
    return (widget.owner as UseProvider).getInstance<T>();
  }

  // @override
  // void reassemble() {
  //   super.reassemble();

  //   final value = _delegateState.hasValue ? _delegateState.value : null;
  //   if (value is ReassembleHandler) {
  //     value.reassemble();
  //   }
  // }

  @override
  void mount(Element? parent, dynamic newSlot) {
    (widget.owner as UseProvider).didMount(this);

    super.mount(parent, newSlot);
  }

  @override
  void updateDependencies(Element dependent, Object? aspect) {
    final dependencies = getDependencies(dependent);
    // once subscribed to everything once, it always stays subscribed to everything

    if (dependencies != null && dependencies is! _Dependency) {
      return;
    }

    if (aspect is SelectorAspect) {
      final selectorDependency = (dependencies ?? _Dependency()) as _Dependency;

      if (selectorDependency.shouldClearSelectors) {
        selectorDependency.shouldClearSelectors = false;
        selectorDependency.selectors.clear();
      }
      if (selectorDependency.shouldClearMutationScheduled == false) {
        selectorDependency.shouldClearMutationScheduled = true;
        Future.microtask(() {
          selectorDependency
            ..shouldClearMutationScheduled = false
            ..shouldClearSelectors = true;
        });
      }
      selectorDependency.selectors.add(aspect);
      setDependencies(dependent, selectorDependency);
    } else {
      // subscribes to everything
      setDependencies(dependent, const Object());
    }
  }

  @override
  void notifyDependent(InheritedWidget oldWidget, Element dependent) {
    final dependencies = getDependencies(dependent);

    // if (kDebugMode) {
    //   ProviderBinding.debugInstance.providerDidChange(_debugId);
    // }

    var shouldNotify = false;
    if (dependencies != null) {
      if (dependencies is _Dependency) {
        // select can never be used inside `didChangeDependencies`, so if the
        // dependent is already marked as needed build, there is no point
        // in executing the selectors.
        if (dependent.dirty) {
          return;
        }

        for (final updateShouldNotify in dependencies.selectors) {
          try {
            // assert(() {
            //   _debugIsSelecting = true;
            //   return true;
            // }());
            shouldNotify = updateShouldNotify(this);
            // shouldNotify = updateShouldNotify(value);
          } finally {
            // assert(() {
            //   _debugIsSelecting = false;
            //   return true;
            // }());
          }
          if (shouldNotify) {
            break;
          }
        }
      } else {
        shouldNotify = true;
      }
    }

    if (shouldNotify) {
      dependent.didChangeDependencies();
    }
  }

  // @override
  // void performRebuild() {
  //   if (_firstBuild) {
  //     _firstBuild = false;
  //     _delegateState = widget.owner._delegate.createState()..element = this;
  //   }
  //   super.performRebuild();
  // }

  @override
  void update(ReactterInheritedProviderScope newWidget) {
//     assert(() {
//       if (widget.owner._delegate.runtimeType !=
//           newWidget.owner._delegate.runtimeType) {
//         throw StateError('''
// Rebuilt $widget using a different constructor.

// This is likely a mistake and is unsupported.
// If you're in this situation, consider passing a `key` unique to each individual constructor.
// ''');
//       }
//       return true;
//     }());

    // _isBuildFromExternalSources = true;
    // _updatedShouldNotify =
    //     _delegateState.willUpdateDelegate(newWidget.owner._delegate);
    _updatedShouldNotify = true;
    super.update(newWidget);
    _updatedShouldNotify = false;
  }

  @override
  void updated(InheritedWidget oldWidget) {
    super.updated(oldWidget);
    if (_updatedShouldNotify) {
      notifyClients(oldWidget);
    }
  }

  // @override
  // void didChangeDependencies() {
  //   // _isBuildFromExternalSources = true;
  //   super.didChangeDependencies();
  // }

  @override
  Widget build() {
    // if (widget.owner._lazy == false) {
    // value; // this will force the value to be computed.
    // }
    // _delegateState.build(
    //   isBuildFromExternalSources: _isBuildFromExternalSources,
    // );
    // _isBuildFromExternalSources = false;
    // if (_shouldNotifyDependents) {
    // _shouldNotifyDependents = false;
    notifyClients(widget);
    // }
    return super.build();
  }

  @override
  void unmount() {
    // _delegateState.dispose();
    // if (kDebugMode) {
    //   ProviderBinding.debugInstance.providerDetails = {
    //     ...ProviderBinding.debugInstance.providerDetails,
    //   }..remove(_debugId);
    // }
    (widget.owner as UseProvider).willUnmount(this);
    super.unmount();
  }

  // @override
  // bool get hasValue => _delegateState.hasValue;

  // // @override
  // void markNeedsNotifyDependents() {
  //   // if (!_isNotifyDependentsEnabled) {
  //   //   return;
  //   // }

  //   markNeedsBuild();
  //   _shouldNotifyDependents = true;
  // }

  // bool _debugSetInheritedLock(bool value) {
  //   assert(() {
  //     _debugInheritLocked = value;
  //     return true;
  //   }());
  //   return true;
  // }

  // @override
  // T get value => _delegateState.value;

//   @override
//   InheritedWidget dependOnInheritedElement(
//     InheritedElement ancestor, {
//     Object? aspect,
//   }) {
//     assert(() {
//       if (_debugInheritLocked) {
//         throw FlutterError.fromParts(
//           <DiagnosticsNode>[
//             ErrorSummary(
//               'Tried to listen to an InheritedWidget '
//               'in a life-cycle that will never be called again.',
//             ),
//             ErrorDescription('''
// This error typically happens when calling Provider.of with `listen` to `true`,
// in a situation where listening to the provider doesn't make sense, such as:
// - initState of a StatefulWidget
// - the "create" callback of a provider

// This is undesired because these life-cycles are called only once in the
// lifetime of a widget. As such, while `listen` is `true`, the widget has
// no mean to handle the update scenario.

// To fix, consider:
// - passing `listen: false` to `Provider.of`
// - use a life-cycle that handles updates (like didChangeDependencies)
// - use a provider that handles updates (like ProxyProvider).
// '''),
//           ],
//         );
//       }
//       return true;
//     }());
//     return super.dependOnInheritedElement(ancestor, aspect: aspect);
//   }

  // @override
  // void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  //   super.debugFillProperties(properties);
  //   _delegateState.debugFillProperties(properties);
  // }
}
