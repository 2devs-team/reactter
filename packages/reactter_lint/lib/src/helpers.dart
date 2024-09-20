import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:reactter_lint/src/consts.dart';
import 'package:reactter_lint/src/extensions.dart';

/// The function checks if a given declaration is a hook register.
///
/// Args:
///   node (Declaration): The "node" parameter is a Declaration object.
bool isRegisterDeclaration(Declaration node) {
  if (node is FieldDeclaration) {
    final name = node.fields.variables.first.name.toString();
    return name == HOOK_REGISTER_VAR;
  }

  if (node is MethodDeclaration) {
    return node.name.toString() == HOOK_REGISTER_VAR;
  }

  return false;
}

/// The function `getElementFromDeclaration` returns an `Element` object from a given `Declaration`
/// node.
///
/// Args:
///   node (Declaration): The `node` parameter is an object of type `Declaration`.
Element? getElementFromDeclaration(Declaration node) {
  if (node is FieldDeclaration) {
    return node.fields.variables.first.declaredElement;
  }

  return node.declaredElement;
}

/// Returns whether the canonical elements of [element1] and [element2] are
/// equal.
bool canonicalElementsAreEqual(Element? element1, Element? element2) =>
    element1?.canonicalElement == element2?.canonicalElement;

/// Returns whether the canonical elements from two nodes are equal.
///
/// As in, [NullableAstNodeExtension.canonicalElement], the two nodes must be
/// [Expression]s in order to be compared (otherwise `false` is returned).
///
/// The two nodes must both be a [SimpleIdentifier], [PrefixedIdentifier], or
/// [PropertyAccess] (otherwise `false` is returned).
///
/// If the two nodes are PrefixedIdentifiers, or PropertyAccess nodes, then
/// `true` is returned only if their canonical elements are equal, in
/// addition to their prefixes' and targets' (respectfully) canonical
/// elements.
///
/// There is an inherent assumption about pure getters. For example:
///
///     A a1 = ...
///     A a2 = ...
///     a1.b.c; // statement 1
///     a2.b.c; // statement 2
///     a1.b.c; // statement 3
///
/// The canonical elements from statements 1 and 2 are different, because a1
/// is not the same element as a2.  The canonical elements from statements 1
/// and 3 are considered to be equal, even though `A.b` may have side effects
/// which alter the returned value.
bool canonicalElementsFromIdentifiersAreEqual(
    Expression? rawExpression1, Expression? rawExpression2) {
  if (rawExpression1 == null || rawExpression2 == null) return false;

  var expression1 = rawExpression1.unParenthesized;
  var expression2 = rawExpression2.unParenthesized;

  print("EXPRESSION 1: ${expression1.runtimeType}");
  print("EXPRESSION 2: ${expression2.runtimeType}");

  if (expression1 is SimpleIdentifier) {
    print("EXPRESSION SimpleIdentifier 1: $expression1");
    print("EXPRESSION SimpleIdentifier 2: $expression2");
    return expression2 is SimpleIdentifier &&
        canonicalElementsAreEqual(getWriteOrReadElement(expression1),
            getWriteOrReadElement(expression2));
  }

  if (expression1 is PrefixedIdentifier) {
    print("EXPRESSION PrefixedIdentifier 1: $expression1");
    print("EXPRESSION PrefixedIdentifier 2: $expression2");
    return expression2 is PrefixedIdentifier &&
        canonicalElementsAreEqual(expression1.prefix.staticElement,
            expression2.prefix.staticElement) &&
        canonicalElementsAreEqual(getWriteOrReadElement(expression1.identifier),
            getWriteOrReadElement(expression2.identifier));
  }

  if (expression1 is PropertyAccess && expression2 is PropertyAccess) {
    print("EXPRESSION PropertyAccess 1: $expression1");
    print("EXPRESSION PropertyAccess 2: $expression2");
    var target1 = expression1.target;
    var target2 = expression2.target;
    return canonicalElementsFromIdentifiersAreEqual(target1, target2) &&
        canonicalElementsAreEqual(
            getWriteOrReadElement(expression1.propertyName),
            getWriteOrReadElement(expression2.propertyName));
  }

  if (expression1 is InstanceCreationExpression &&
      expression2 is InstanceCreationExpression) {
    print(
        "EXPRESSION InstanceCreationExpression 1: ${expression1.staticParameterElement}");
    print(
        "EXPRESSION InstanceCreationExpression 2: ${expression2.staticParameterElement}");

    return expression1 == expression2;
  }

  return false;
}

/// If the [node] is the finishing identifier of an assignment, return its
/// "writeElement", otherwise return its "staticElement", which might be
/// thought as the "readElement".
Element? getWriteOrReadElement(SimpleIdentifier node) {
  var writeElement = _getWriteElement(node);
  if (writeElement != null) {
    return writeElement;
  }
  return node.staticElement;
}

/// If the [node] is the target of a [CompoundAssignmentExpression],
/// return the corresponding "writeElement", which is the local variable,
/// the setter referenced with a [SimpleIdentifier] or a [PropertyAccess],
/// or the `[]=` operator.
Element? _getWriteElement(AstNode node) {
  var parent = node.parent;
  if (parent is AssignmentExpression && parent.leftHandSide == node) {
    return parent.writeElement;
  }
  if (parent is PostfixExpression) {
    return parent.writeElement;
  }
  if (parent is PrefixExpression) {
    return parent.writeElement;
  }

  if (parent is PrefixedIdentifier && parent.identifier == node) {
    return _getWriteElement(parent);
  }

  if (parent is PropertyAccess && parent.propertyName == node) {
    return _getWriteElement(parent);
  }

  return null;
}
