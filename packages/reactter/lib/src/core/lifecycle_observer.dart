part of 'core.dart';

abstract class LifecycleObserver {
  /// This method is called when the instance is initialized.
  void onInitialized() {}

  /// This method is called when the instance is going to be mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  void onWillMount() {}

  /// This method is called when the instance has been successfully mounted
  /// in the widget tree(exclusive to `flutter_reactter`).
  void onDidMount() {}

  /// This method is called when the instance's state is about to be updated.
  /// The parameter is a [StateBase].
  void onWillUpdate(covariant StateBase? state) {}

  /// This method is called when the instance's state has been updated.
  /// The parameter is a [StateBase].
  void onDidUpdate(covariant StateBase? state) {}

  /// This method is called when the instance is going to be unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  void onWillUnmount() {}

  /// This method is called when the instance has been successfully unmounted
  /// from the widget tree(exclusive to `flutter_reactter`).
  void onDidUnmount() {}
}
