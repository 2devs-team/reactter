library reactter;

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
export 'package:get/get.dart';

class UseEffect<T extends GetxController> extends StatefulWidget {
  final GetControllerBuilder<T> builder;
  final bool global;
  final Object? id;
  final String? tag;
  final bool autoRemove;
  final bool assignId;
  final Object Function(T value)? filter;
  final void Function(UseEffectState<T> state)? initState,
      dispose,
      didChangeDependencies;
  final void Function(UseEffect oldWidget, UseEffectState<T> state)?
      didUpdateWidget;
  final T? init;

  const UseEffect({
    Key? key,
    this.init,
    this.global = true,
    required this.builder,
    this.autoRemove = true,
    this.assignId = false,
    this.initState,
    this.filter,
    this.tag,
    this.dispose,
    this.id,
    this.didChangeDependencies,
    this.didUpdateWidget,
  }) : super(key: key);

  @override
  UseEffectState<T> createState() => UseEffectState<T>();
}

class UseEffectState<T extends GetxController> extends State<UseEffect<T>>
    with GetStateUpdaterMixin {
  T? controller;
  bool? _isCreator = false;
  List<VoidCallback?>? _removes;
  Object? _filter;

  @override
  void initState() {
    super.initState();
    widget.initState?.call(this);

    var isRegistered = GetInstance().isRegistered<T>(tag: widget.tag);

    if (widget.global) {
      if (isRegistered) {
        if (GetInstance().isPrepared<T>(tag: widget.tag)) {
          _isCreator = true;
        } else {
          _isCreator = false;
        }
        controller = GetInstance().find<T>(tag: widget.tag);
      } else {
        controller = widget.init;
        _isCreator = true;
        GetInstance().put<T>(controller!, tag: widget.tag);
      }
    } else {
      controller = widget.init;
      _isCreator = true;
      controller?.onStart();
    }

    if (widget.filter != null) {
      _filter = widget.filter!(controller!);
    }

    _subscribeToController();
  }

  /// Register to listen Controller's events.
  /// It gets a reference to the remove() callback, to delete the
  /// setState "link" from the Controller.
  void _subscribeToController() {
    _removeAll();

    final _remove = (widget.id == null)
        ? controller?.addListener(
            _filter != null ? _filterUpdate : getUpdate,
          )
        : controller?.addListenerId(
            widget.id,
            _filter != null ? _filterUpdate : getUpdate,
          );

    _removes?.add(_remove);

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

  @override
  void dispose() {
    super.dispose();
    widget.dispose?.call(this);
    if (_isCreator! || widget.assignId) {
      if (widget.autoRemove && GetInstance().isRegistered<T>(tag: widget.tag)) {
        GetInstance().delete<T>(tag: widget.tag);
      }
    }

    _removeAll();

    controller = null;
    _isCreator = null;
    _filter = null;
  }

  void _removeAll() {
    _removes?.forEach((_remove) => _remove?.call());
    _removes = [];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.didChangeDependencies?.call(this);
  }

  @override
  void didUpdateWidget(UseEffect oldWidget) {
    super.didUpdateWidget(oldWidget as UseEffect<T>);
    // to avoid conflicts when modifying a "grouped" id list.
    if (oldWidget.id != widget.id) {
      _subscribeToController();
    }
    widget.didUpdateWidget?.call(oldWidget, this);
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(controller!);
  }
}
