// ignore_for_file: body_might_complete_normally_nullable

String? passwordValidator(String? value, int min, int max) {
  if (value == null ||
      value.isEmpty ||
      value.length < min ||
      value.length > max) {
    return 'Mot de passe invalide, la taille mininum est $min';
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

String? positiveValidator(String? value) {
  if (value == null ||
      value.isEmpty ||
      double.tryParse(value) == null ||
      double.tryParse(value)! < 0) {
    return 'Saisie invalide';
  }
}

String? lengthValidator(String? value, int max) {
  if (value == null || value.isEmpty || value.length > max) {
    return 'Saisie invalide, le champ doit faire entre 1 et $max caractères';
  }
}
