import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

extension ElementExtension on Element? {
  /// The `node` is a getter method defined as an extension on the `Element` class in
  /// Dart. It allows you to retrieve the AST (Abstract Syntax Tree) node associated with an element.
  AstNode? get node {
    if (this == null) return null;

    if (this?.library == null) return null;

    final parsedLibrary = this
        ?.session
        ?.getParsedLibraryByElement(this!.library!) as ParsedLibraryResult?;
    final declaration = parsedLibrary?.getElementDeclaration(this!);

    return declaration?.node;
  }
}

extension InterableExtension<T> on Iterable<T> {
  /// The `firstWhereOrNull` function returns the first element in a collection that satisfies a given
  /// condition, or null if no such element is found.
  ///
  /// Args:
  ///   test (bool Function(T element)): A function that takes an element of type T as input and returns
  /// a boolean value.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
