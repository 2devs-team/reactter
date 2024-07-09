import 'package:reactter/reactter.dart';

enum CustomEvent { myEvent }

class MyDependency {
  final stateA = Signal(0);
  final stateB = Signal('InitialValue');
}
