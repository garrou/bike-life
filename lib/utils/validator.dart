import 'package:bike_life/constants.dart';

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

bool isValidKm(String? value) {
  return value != null &&
      value.isNotEmpty &&
      (value.allMatches(".").length < 2 || value.allMatches(",").length < 2) &&
      double.parse(value.replaceAll(",", ".")) >= 0.0;
}

String? kmValidator(String? value) {
  if (value == null ||
      value.isEmpty ||
      value.allMatches(",").length > 1 ||
      value.allMatches(".").length > 1 ||
      double.parse(value.replaceAll(",", ".")) < 0.0) {
    return 'Saisie invalide';
  }
}
