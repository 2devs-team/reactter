import 'package:reactter/utils/reactter_types.dart';

class Reactter<T> {
  Reactter(
    this.key,
    this.initial, {
    this.alwayUpdate = false,
    UpdateCallback<T>? beforeUpdate,
    UpdateCallback<T>? afterUpdate,
    void Function([List<Object>?, bool])? update,
  })  : _update = update,
        _beforeUpdate = beforeUpdate,
        _afterUpdate = afterUpdate;

  final String key;
  T initial;
  final bool alwayUpdate;
  final UpdateCallback<T>? _afterUpdate;
  final UpdateCallback<T>? _beforeUpdate;
  final List<UpdateCallback<T>> _beforeUpdateList = [];
  final List<UpdateCallback<T>> _afterUpdateList = [];
  final void Function([List<Object>?, bool])? _update;

  late T _value = initial;
  T get value => _value;
  set value(T value) {
    if (value != _value || alwayUpdate || value.hashCode != _value.hashCode) {
      final oldValue = _value;

      _onBeforeUpdate(oldValue, value);

      _value = value;

      update();

      _onAfterUpdate(oldValue, value);
    }
  }

  Function beforeUpdate(UpdateCallback<T> listener) {
    _beforeUpdateList.add(listener);
    return () => _beforeUpdateList.remove(listener);
  }

  Function afterUpdate(UpdateCallback<T> listener) {
    _afterUpdateList.add(listener);
    return () => _afterUpdateList.remove(listener);
  }

  void reset() {
    value = initial;
  }

  void update() {
    _update?.call([key]);
  }

  void _onBeforeUpdate(T oldValue, T value) {
    _beforeUpdate?.call(oldValue, value);

    for (final listener in _beforeUpdateList) {
      listener(oldValue, value);
    }
  }

  void _onAfterUpdate(T oldValue, T value) {
    _afterUpdate?.call(oldValue, value);

    for (final listener in _afterUpdateList) {
      listener(oldValue, value);
    }
  }
}
