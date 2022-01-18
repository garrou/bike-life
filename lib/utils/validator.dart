import 'package:bike_life/utils/constants.dart';

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty || value.length < minPasswordSize) {
    return 'Mot de passe invalide';
  }
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty || !value.contains('@')) {
    return 'Email invalide';
  }
}

String? fieldValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Saisie invalide';
  }
}

String? kmValidator(String? value) {
  if (value == null ||
      value.isEmpty ||
      double.tryParse(value) == null ||
      double.tryParse(value)! < 0) {
    return 'Saisie invalide';
  }
}

String? emptyValidator(String? value) {}
