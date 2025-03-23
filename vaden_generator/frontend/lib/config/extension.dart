import 'package:localization/localization.dart';

extension ValidatorI18nExtension on String? Function(String?)? {
  String? Function(String?)? i18n() {
    return (String? value) {
      final result = this?.call(value);
      return result?.i18n();
    };
  }
}
