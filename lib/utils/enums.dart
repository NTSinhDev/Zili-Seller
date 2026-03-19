// ignore_for_file: constant_identifier_names
extension EnumExt on Enum {
  String parseToStr() {
    return toString().split('.').last;
  }

  String convertToString() {
    final key = toString().split('.').last.split('_');
    return "${key[0]}-${key[1]}";
  }

  /// Chuyển đổi enum name từ lowerCamelCase thành UPPER_SNAKE_CASE
  ///
  /// Ví dụ:
  /// - preMerger → PRE_MERGER
  /// - postMerger → POST_MERGER
  /// - lowerCamelCase → LOWER_CAMEL_CASE
  String get toConstant {
    final enumName = parseToStr();
    return enumName.toUpperSnakeCase();
  }

  int toInt() => this == Gender.male
      ? 0
      : this == Gender.female
      ? 1
      : 2;
}

/// Extension trên String để chuyển đổi lowerCamelCase thành UPPER_SNAKE_CASE
extension StringCaseExtension on String {
  /// Chuyển đổi string từ lowerCamelCase thành UPPER_SNAKE_CASE
  ///
  /// Ví dụ:
  /// - "preMerger" → "PRE_MERGER"
  /// - "postMerger" → "POST_MERGER"
  /// - "lowerCamelCase" → "LOWER_CAMEL_CASE"
  String toUpperSnakeCase() {
    if (isEmpty) return '';

    final buffer = StringBuffer();
    for (int i = 0; i < length; i++) {
      final char = this[i];
      if (i > 0 && char == char.toUpperCase() && char != char.toLowerCase()) {
        // Nếu là chữ cái viết hoa và không phải ký tự đầu tiên
        buffer.write('_');
      }
      buffer.write(char.toUpperCase());
    }
    return buffer.toString();
  }
}

enum LayoutView { horizontal, vertical, none }

enum DateTimeFormat { ddMMyyyy }

extension DateTimeFormatExt on DateTimeFormat {
  String get value {
    if (this == DateTimeFormat.ddMMyyyy) {
      return "dd-MM-yyyy";
    }
    return '';
  }
}

enum MediaType { image, video, undefine }

enum NavbarItems {
  home,
  customer,
  rating,
  orders,
  quotations,
  products,
  setting,
  warehouse,
  roastingSlip,
  packingSlip,
}

enum Gender { male, female, other }

enum PaymentMethodEnum { COD, MOMO, ZALO_PAY }

enum MessageType { admin, user }

enum MessageNotificationType { info, warning, success, error }

enum ForgotPasswordSteps { inputEmail, verifyCode, inputNewPassword, error }

enum LocationLevel { Province_City, District, Ward_Town }

enum SignInType { Google, Facebook, Normal }

enum TypeProductRequest {
  sp_new,

  /// Sản phẩm bán chạy
  sp_best,

  /// Dòng caffee trải nghiệm cao cấp
  sp_first,

  /// DÒNG CÀ PHÊ CAO CẤP TRUYỀN THỐNG
  sp_second,

  /// DÒNG CÀ PHÊ CHO QUÁN
  sp_three,

  /// Giới thiệu
  sp_intro,
  // sp_slider,
  // sp_more,
}

enum CommonStateEvent { refresh, loadMore, get, post, loaded }

enum TimeFormat {
  defaultFormat("dd/MM/yyyy HH:mm:ss"),
  ddMMyyyyS1("dd/MM/yyyy"),
  ddMMyyyyS2("dd-MM-yyyy"),
  ddMMyyyyHHmm("dd/MM/yyyy HH:mm"),
  hhmmddMMyyyy("HH:mm dd/MM/yyyy"),
  hhmmssddMMyyyy("HH:mm:ss dd/MM/yyyy"),
  dayMonth("dd/MM"),
  yyyyMMdd("yyyy-MM-dd");

  const TimeFormat(this.value);
  final String value;
}

enum TimeOption {
  today("Hôm nay"),
  yesterday("Hôm qua"),
  thisWeek("Tuần này"),
  lastWeek("Tuần trước"),
  thisMonth("Tháng này"),
  lastMonth("Tháng trước"),
  thisYear("Năm này"),
  lastYear("Năm trước");

  const TimeOption(this.label);
  final String label;
}

enum CurrentPlatform { android, ios, web }

enum Role {
  guest,
  manager,
  chiefAccountant,
  accountant,
  saleManager,
  saleStaff,
  technicalManager,
  technicalStaff,
  packingManager,
  packingStaff,
}

enum CRUDType { create, update, get, delete }
