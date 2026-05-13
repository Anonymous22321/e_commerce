class AppValidators {
  static String? displayNameValidator(String? displayName) {
    if (displayName == null || displayName.isEmpty) {
      return 'Display name cannot be empty';
    }
    if (displayName.length < 3 || displayName.length > 20) {
      return 'Display name must be between 3 and 20 characters';
    }

    return null; // Return null if display name is valid
  }
  static String? addressValidator(String? address){
    if(address == null|| address.trim().isEmpty){
      return 'Required Field';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter an email';
    }
    if (!RegExp(r'\b[A-Za-z0-9._%+-]+@mail.com\b').hasMatch(value)) {
      return 'The email is not valid';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter';
    }

    return null;
  }

  static String? repeatPasswordValidator({String? value, String? password}) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }
}
