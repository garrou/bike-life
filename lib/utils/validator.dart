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

String? kmValidator(String? value) {
  if (value == null ||
      value.isEmpty ||
      int.tryParse(value) == null ||
      int.tryParse(value)! < 0) {
    return 'Saisie invalide';
  }
}

String? emptyValidator(String? value) {}
