// import 'dart:io';
// import 'package:analyzer/dart/analysis/utilities.dart';
// import 'package:analyzer/dart/ast/ast.dart';
// import 'package:analyzer/dart/ast/token.dart';
// import 'package:analyzer/dart/ast/visitor.dart';

// /// Extracts all kinds of hard-coded strings, including string literals,
// /// string interpolation, concatenation, and multi-line strings.
// class HardCodedStringExtractor {
//   List<String> extractHardCodedStrings(String dartCode) {
//     // Parse the Dart code into an AST.
//     var parseResult = parseString(content: dartCode, throwIfDiagnostics: false);
//     var compilationUnit = parseResult.unit;

//     // Visitor to traverse the AST.
//     var visitor = _HardCodedStringVisitor();

//     // Visit all nodes in the AST.
//     compilationUnit.visitChildren(visitor);

//     // Return the list of extracted hard-coded strings, removing duplicates and empty strings.
//     return visitor.hardCodedStrings.toList()..removeWhere((str) => str.isEmpty || str.contains('dart:') || str.contains('ignored string'));
//   }
// }

// class _HardCodedStringVisitor extends RecursiveAstVisitor<void> {
//   final Set<String> hardCodedStrings = {}; // Use a Set to avoid duplicates.

//   @override
//   void visitSimpleStringLiteral(SimpleStringLiteral node) {
//     // Directly add string literals (simple strings).
//     hardCodedStrings.add(node.stringValue ?? "");
//     super.visitSimpleStringLiteral(node);
//   }

//   @override
//   void visitInterpolationExpression(InterpolationExpression node) {
//     // Add the entire interpolation expression, including the interpolation syntax.
//     var interpolationString = node.toSource(); // Get the full interpolation string (including $ and {})
//     hardCodedStrings.add(interpolationString);
//     super.visitInterpolationExpression(node);
//   }

//   @override
//   void visitBinaryExpression(BinaryExpression node) {
//     // Handle string concatenation (e.g., 'some' + 'text')
//     if (node.operator.type == TokenType.PLUS) {
//       String? leftStr = (node.leftOperand is StringLiteral) ? (node.leftOperand as StringLiteral).stringValue : null;
//       String? rightStr = (node.rightOperand is StringLiteral) ? (node.rightOperand as StringLiteral).stringValue : null;

//       // If both sides are literals, add them as a concatenated string
//       if (leftStr != null && rightStr != null) {
//         hardCodedStrings.add(leftStr + rightStr);
//       }

//       // If one side is a string literal, add it
//       if (leftStr != null) hardCodedStrings.add(leftStr);
//       if (rightStr != null) hardCodedStrings.add(rightStr);
//     }
//     super.visitBinaryExpression(node);
//   }

//   @override
//   void visitVariableDeclaration(VariableDeclaration node) {
//     // Handle string assigned to variables (final String var = 'data')
//     if (node.initializer is StringLiteral) {
//       hardCodedStrings.add((node.initializer as StringLiteral).stringValue ?? "");
//     }
//     super.visitVariableDeclaration(node);
//   }

//   @override
//   void visitNamedExpression(NamedExpression node) {
//     // Handle string inside named arguments in function calls
//     if (node.expression is StringLiteral) {
//       hardCodedStrings.add((node.expression as StringLiteral).stringValue ?? "");
//     }
//     super.visitNamedExpression(node);
//   }

//   @override
//   void visitAnnotation(Annotation node) {
//     // Exclude strings inside annotations (e.g., @SomeAnnotation('ignored string'))
//     if (node.arguments != null && node.arguments!.arguments.isNotEmpty) {
//       for (var argument in node.arguments!.arguments) {
//         if (argument is NamedExpression && argument.expression is StringLiteral) {
//           var annotationString = (argument.expression as StringLiteral).stringValue ?? "";
//           if (annotationString.contains("ignored string")) {
//             return; // Ignore these strings
//           }
//         }
//       }
//     }
//     super.visitAnnotation(node);
//   }
// }
