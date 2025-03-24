import 'package:lucid_validation/lucid_validation.dart';

import '../entities/project.dart';

class ProjectValidator extends LucidValidator<Project> {
  ProjectValidator() {
    ruleFor((p) => p.name, key: 'name') //
        .notEmpty(message: 'notEmpty')
        .minLength(3, message: 'minLength')
        .maxLength(50, message: 'maxLength')
        .matchesPattern(r'^[a-z][a-z0-9_]*$', code: 'invalidName');

    ruleFor((p) => p.description, key: 'description') //
        .notEmpty(message: 'notEmpty')
        .minLength(3, message: 'minLength')
        .maxLength(100, message: 'maxLength');

    ruleFor((p) => p.dartVersion, key: 'dartVersion') //
        .notEmpty(message: 'notEmpty')
        .matchesPattern(r'^\d+\.\d+\.\d+$', code: 'invalidVersion');
  }
}
