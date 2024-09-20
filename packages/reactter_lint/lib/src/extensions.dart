import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/src/dart/element/member.dart'; // ignore: implementation_imports

extension ElementExtension on Element {
  /// The `node` is a getter method defined as an extension on the `Element` class in
  /// Dart. It allows you to retrieve the AST (Abstract Syntax Tree) node associated with an element.
  AstNode? get node {
    if (this.library == null) return null;

    final parsedLibrary = this.session?.getParsedLibraryByElement(this.library!)
        as ParsedLibraryResult?;
    final declaration = parsedLibrary?.getElementDeclaration(this);

    return declaration?.node;
  }

  Element get canonicalElement {
    var self = this;
    if (self is PropertyAccessorElement) {
      var variable = self.variable;
      if (variable is FieldMember) {
        // A field element defined in a parameterized type where the values of
        // the type parameters are known.
        //
        // This concept should be invisible when comparing FieldElements, but a
        // bug in the analyzer causes FieldElements to not evaluate as
        // equivalent to equivalent FieldMembers. See
        // https://github.com/dart-lang/sdk/issues/35343.
        return variable.declaration;
      } else {
        return variable;
      }
    } else {
      return self;
    }
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

extension BlockExtension on Block {
  /// Returns the last statement of this block, or `null` if this is empty.
  ///
  /// If the last immediate statement of this block is a [Block], recurses into
  /// it to find the last statement.
  Statement? get lastStatement {
    if (statements.isEmpty) {
      return null;
    }
    var lastStatement = statements.last;
    if (lastStatement is Block) {
      return lastStatement.lastStatement;
    }
    return lastStatement;
  }
}

extension FunctionExpressionExtension on FunctionExpression {
  Expression? get returnExpression {
    return body.returnExpression;
  }
}

extension FunctionBodyExtension on FunctionBody {
  Expression? get returnExpression {
    if (this is BlockFunctionBody) {
      var block = (this as BlockFunctionBody).block;
      if (block.statements.isEmpty) return null;
      var lastStatement = block.statements.last;

      if (lastStatement is ReturnStatement) {
        return lastStatement.expression;
      }
    }

    if (this is ExpressionFunctionBody) {
      return (this as ExpressionFunctionBody).expression;
    }

    return null;
  }
}

/// Operations on iterables.
extension IterableExtensions<T> on Iterable<T> {
  /// The first element of this iterator, or `null` if the iterable is empty.
  T? get firstOrNull {
    var iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }

  /// The last element of this iterable, or `null` if the iterable is empty.
  ///
  /// This computation may not be efficient.
  /// The last value is potentially found by iterating the entire iterable
  /// and temporarily storing every value.
  /// The process only iterates the iterable once.
  /// If iterating more than once is not a problem, it may be more efficient
  /// for some iterables to do:
  /// ```dart
  /// var lastOrNull = iterable.isEmpty ? null : iterable.last;
  /// ```
  T? get lastOrNull {
    if (isEmpty) return null;
    return last;
  }
}
