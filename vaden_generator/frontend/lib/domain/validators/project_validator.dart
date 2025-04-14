import 'package:lucid_validation/lucid_validation.dart';

import '../entities/project.dart';

class ProjectValidator extends LucidValidator<Project> {
  // List of Dart reserved keywords and framework name
  static final List<String> _reservedKeywords = [
    'abstract', 'as', 'assert', 'async', 'await', 'break', 'case', 'catch',
    'class', 'const', 'continue', 'covariant', 'default', 'deferred', 'do',
    'dynamic', 'else', 'enum', 'export', 'extends', 'extension', 'external',
    'factory', 'false', 'final', 'finally', 'for', 'Function', 'get', 'hide',
    'if', 'implements', 'import', 'in', 'interface', 'is', 'late', 'library',
    'mixin', 'new', 'null', 'on', 'operator', 'part', 'required', 'rethrow',
    'return', 'set', 'show', 'static', 'super', 'switch', 'sync', 'this',
    'throw', 'true', 'try', 'typedef', 'var', 'void', 'while', 'with', 'yield',
    // Framework name
    'vaden'
  ];

  ProjectValidator() {
    ruleFor((p) => p.name, key: 'name') //
        .notEmpty(message: 'notEmpty')
        .minLength(3, message: 'minLength')
        .maxLength(50, message: 'maxLength')
        .matchesPattern(r'^[a-z][a-z0-9_]*$', code: 'invalidName')
        .must((name) => !_reservedKeywords.contains(name.toLowerCase()), 'reservedKeyword',
            'reservedKeyword');

    ruleFor((p) => p.description, key: 'description') //
        .notEmpty(message: 'notEmpty')
        .minLength(3, message: 'minLength')
        .maxLength(100, message: 'maxLength');

    ruleFor((p) => p.dartVersion, key: 'dartVersion') //
        .notEmpty(message: 'notEmpty')
        .matchesPattern(r'^\d+\.\d+\.\d+$', code: 'invalidVersion');
  }
}
