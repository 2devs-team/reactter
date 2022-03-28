library reactter;

import 'package:reactter/core/reactter_types.dart';
import 'package:reactter/hooks/reactter_hook.dart';

class UseState<T> extends ReactterHookAbstract {
  UseState(
    this.initial, {
    this.alwaysUpdate = false,
    UpdateCallback<T>? willUpdate,
    UpdateCallback<T>? didUpdate,
    ReactterHook? context,
  })  : _willUpdate = willUpdate,
        _didUpdate = didUpdate {
    context?.listenHooks([this]);
  }

  T initial;
  final bool alwaysUpdate;
  final UpdateCallback<T>? _didUpdate;
  final UpdateCallback<T>? _willUpdate;
  final List<UpdateCallback<T>> _didUpdateList = [];
  final List<UpdateCallback<T>> _willUpdateList = [];

  late T _value = initial;
  T get value => _value;
  set value(T value) {
    if (value != _value || alwaysUpdate || value.hashCode != _value.hashCode) {
      final oldValue = _value;

      _onWillUpdate(oldValue, value);

      _value = value;

      update();

      _onDidUpdate(oldValue, value);

      publish();
    }
  }

  void Function() willUpdate(UpdateCallback<T> listener) {
    _willUpdateList.add(listener);
    return () => _willUpdateList.remove(listener);
  }

  void Function() didUpdate(UpdateCallback<T> listener) {
    _didUpdateList.add(listener);
    return () => _didUpdateList.remove(listener);
  }

  void reset() {
    value = initial;
  }

  void update() {
    // _update?.call([key]);
  }

  void _onWillUpdate(T oldValue, T value) {
    _willUpdate?.call(oldValue, value);

    for (final listener in _willUpdateList) {
      listener(oldValue, value);
    }
  }

  void _onDidUpdate(T oldValue, T value) {
    _didUpdate?.call(oldValue, value);

    for (final listener in _didUpdateList) {
      listener(oldValue, value);
    }
  }
}
