// ignore_for_file: body_might_complete_normally_nullable

import 'package:bike_life/utils/constants.dart';

String? passwordValidator(String? value) {
  if (value == null || value.isEmpty || value.length < minPasswordSize) {
    return 'Mot de passe invalide, la taille mininum est $minPasswordSize';
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

String? lengthValidator(String? value) {
  if (value == null || value.isEmpty || value.length > maxBikeName) {
    return 'Saisie invalide, le nom doit faire entre 1 et $maxBikeName caractères';
  }
}

String? emptyValidator(String? value) {}
