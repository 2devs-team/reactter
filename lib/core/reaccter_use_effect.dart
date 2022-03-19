library reactter;

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class UseEffect<T extends GetxController> extends GetBuilder<T> {
  const UseEffect({
    Key? key,
    required final GetControllerBuilder<T> builder,
    final bool global = true,
    final Object? id,
    final String? tag,
    final bool autoRemove = true,
    final bool assignId = false,
    final Object Function(T value)? filter,
    final void Function(GetBuilderState<T> state)? initState,
    dispose,
    didChangeDependencies,
    final void Function(GetBuilder oldWidget, GetBuilderState<T> state)?
        didUpdateWidget,
    final T? init,
  }) : super(
          key: key,
          init: init,
          global: global,
          builder: builder,
          autoRemove: autoRemove,
          assignId: assignId,
          initState: initState,
          filter: filter,
          tag: tag,
          dispose: dispose,
          id: id,
          didChangeDependencies: didChangeDependencies,
          didUpdateWidget: didUpdateWidget,
        );
  @override
  UseEffectState<T> createState() => UseEffectState<T>();
}

class UseEffectState<T extends GetxController> extends GetBuilderState<T> {
  List<VoidCallback?>? _removes;
  Object? _filter;
  @override
  void initState() {
    super.initState();
    if (widget.filter != null) {
      _filter = widget.filter!(controller!);
    }
    _subscribeToController();
  }

  @override
  void dispose() {
    _filter = null;
    _removeAll();
    super.dispose();
  }

  @override
  void didUpdateWidget(GetBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    // to avoid conflicts when modifying a "grouped" id list.
    if (oldWidget.id != widget.id) {
      _subscribeToController();
    }
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    _removeAll();
    if (widget.id != null && widget.id is List) {
      for (var _id in (widget.id as List)) {
        final _remove = controller?.addListenerId(_id, () {
          _filter != null ? _filterUpdate() : getUpdate();
        });
        _removes?.add(_remove);
      }
    }
  }

  void _filterUpdate() {
    var newFilter = widget.filter!(controller!);
    if (newFilter != _filter) {
      _filter = newFilter;
      getUpdate();
    }
  }

  void _removeAll() {
    _removes?.forEach((_remove) => _remove?.call());
    _removes = [];
  }
}
