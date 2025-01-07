sealed class Validators {
  static String? validateEmail(String? email) {
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if (!isEmailValid) {
      return 'لطفا یک ایمیل معتبر وارد کنید';
    }
    return null;
  }

  static String? validatePassword(String? password) {
    if (password == null) {
      return 'لطفا یک رمز عبور وارد کنید';
    }
    if (password.length < 6) {
      return 'رمز عبور شما باید دست کم 6 کاراکتر باشد';
    }
    return null;
  }

  static String? validateName(String? name) {
    final nameRegex = RegExp(r'^[a-zA-Z\s]{1,50}$');
    if (name == null) {
      return 'نام نمیتواند خالی باشد';
    } else if (name.isEmpty) {
      return 'نام باید دست کم 3 کاراکتر داشته باشد';
    } else if (!nameRegex.hasMatch(name)) {
      return 'لطفا یک نام معتبر وارد کنید';
    } else {
      return null;
    }
  }

  static String? validateOTP(String? otp) {
    if (otp == null) {
      return 'لطفا کد را وارد کنید';
    }
    if (otp.length != 6) {
      return 'کد باید دقیقا 6 کاراکتر باشد';
    }
    return null;
  }

  static String? validatePhone(String? phone) {
    RegExp phoneRegex =
        RegExp(r'^\+?[0-9]{10,15}$'); // Allows optional '+' and 10-15 digits.
    final isPhoneValid = phoneRegex.hasMatch(phone ?? '');
    if (!isPhoneValid) {
      return 'Please enter a valid phone number.';
    }
    return null;
  }

  Validators._();
}
