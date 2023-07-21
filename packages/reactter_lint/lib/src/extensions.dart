import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';

extension ElementExtension on Element? {
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
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}
