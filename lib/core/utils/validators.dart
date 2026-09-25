/// Form field validators used across Auth, Profile Setup, Hostel Setup,
/// and Place Bid screens. Each returns `null` when valid, or an error
/// string to show under the field.
class Validators {
  Validators._();

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  static String? name(String? value) {
    final requiredCheck = required(value, fieldName: 'Name');
    if (requiredCheck != null) return requiredCheck;
    if (value!.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    return null;
  }

  static String? email(String? value) {
    final requiredCheck = required(value, fieldName: 'Email');
    if (requiredCheck != null) return requiredCheck;
    final pattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!pattern.hasMatch(value!.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  static String? phone(String? value) {
    final requiredCheck = required(value, fieldName: 'Phone number');
    if (requiredCheck != null) return requiredCheck;
    final digitsOnly = value!.replaceAll(RegExp(r'\D'), '');
    if (digitsOnly.length < 10 || digitsOnly.length > 12) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  static String? password(String? value) {
    final requiredCheck = required(value, fieldName: 'Password');
    if (requiredCheck != null) return requiredCheck;
    if (value!.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    final requiredCheck = required(value, fieldName: 'Confirm password');
    if (requiredCheck != null) return requiredCheck;
    if (value != originalPassword) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? hostelName(String? value) {
    return required(value, fieldName: 'Hostel name');
  }

  static String? city(String? value) {
    return required(value, fieldName: 'City');
  }

  /// Used on Hostel Setup's "Total rooms" and Place Bid's "Offer amount".
  static String? positiveNumber(String? value, {String fieldName = 'Amount'}) {
    final requiredCheck = required(value, fieldName: fieldName);
    if (requiredCheck != null) return requiredCheck;
    final number = num.tryParse(value!.trim());
    if (number == null || number <= 0) {
      return '$fieldName must be a positive number';
    }
    return null;
  }

  /// Place Bid screen: offer must beat the current highest bid.
  static String? bidAmount(String? value, {required num currentHighest}) {
    final numberCheck = positiveNumber(value, fieldName: 'Bid amount');
    if (numberCheck != null) return numberCheck;
    final bid = num.parse(value!.trim());
    if (bid <= currentHighest) {
      return 'Bid must be higher than Rs $currentHighest';
    }
    return null;
  }
}
