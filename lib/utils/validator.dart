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

bool kmValivdator(String? value) {
  if (value == null || value.isEmpty || int.parse(value) < 0) {
    return false;
  }
  return true;
}
