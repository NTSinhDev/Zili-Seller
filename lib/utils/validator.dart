class Validator {
  static const _regexVietNameseName =
      r'^[A-ZÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ][a-záàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵ]*(\s[A-ZÁÀẢÃẠĂẮẰẲẴẶÂẤẦẨẪẬĐÉÈẺẼẸÊẾỀỂỄỆÍÌỈĨỊÓÒỎÕỌÔỐỒỔỖỘƠỚỜỞỠỢÚÙỦŨỤƯỨỪỬỮỰÝỲỶỸỴ][a-záàảãạăắằẳẵặâấầẩẫậđéèẻẽẹêếềểễệíìỉĩịóòỏõọôốồổỗộơớờởỡợúùủũụưứừửữựýỳỷỹỵ]*)*$';
  static const _regexEmail =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const _regexPassword = r'^(?=.*[a-zA-Z])(?=.*\d)[A-Za-z\d]{8,}$';
  static const _regexFirstLetterIsUppercase = r'^[A-Z].*$';
  static const _regexPhone = r'^0[1-9]\d{8}$';
  static bool _validate(String string, String pattern) {
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(string);
  }

  static bool validateName(String name) =>
      _validate(name, _regexVietNameseName);

  static bool validatePhone(String phone) => _validate(phone, _regexPhone);
  

  static bool validateEmail(String email) => _validate(email, _regexEmail);

  static bool validatePassword(String password) =>
      _validate(password, _regexPassword);

  static bool firstLetterIsUppercase(String string) =>
      _validate(string, _regexFirstLetterIsUppercase);
}
