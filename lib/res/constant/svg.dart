part of 'ui_constant.dart';

class _SVGs {
  final String logoApp = '${_svgRoute}logo.svg';
  final String minimalistLogoApp = '${_svgRoute}logo_minimalist.svg';
  final String logoGoogle = '${_svgRoute}logo_google.svg';
  final String logoFacebook = '${_svgRoute}logo_facebook.svg';
  final String icBranch = '${_svgRoute}i_branch.svg';
  final String iRefresh = '${_svgRoute}i_refresh.svg';
  final String iSpeakerWave = '${_svgRoute}i_speaker_wave.svg';
  final String iSpeakerXMark = '${_svgRoute}i_speaker_x_mark.svg';
  final String icCheckRadio = '${_svgRoute}i_check_radio.svg';
  final String icXmarkXl = '${_svgRoute}i_xmark_xl.svg';
  final String icXmark = '${_svgRoute}i_xmark.svg';
  final String icVoucherBlack = '${_svgRoute}i_voucher_black.svg';
  final String icStarNone = '${_svgRoute}i_star_none.svg';
  final String icStarHalf = '${_svgRoute}i_star_half.svg';
  final String icStar = '${_svgRoute}i_star.svg';
  final String icOrder = '${_svgRoute}i_order.svg';
  final String icMapPin = '${_svgRoute}i_map_pin.svg';
  final String icLogOut = '${_svgRoute}i_log_out.svg';
  final String icLock = '${_svgRoute}i_lock.svg';
  final String icDisLike = '${_svgRoute}i_dis_like.svg';
  final String icLike = '${_svgRoute}i_like.svg';
  final String icReplied = '${_svgRoute}i_replied.svg';
  final String icHandThumbUp = '${_svgRoute}i_hand_thumb_up.svg';
  final String icHandThumbDown = '${_svgRoute}i_hand_thumb_down.svg';
  final String icStarOutLine = '${_svgRoute}i_star_outline.svg';
  final String icOrderManagement = '${_svgRoute}i_order_management.svg';
  final String icProductManagement = '${_svgRoute}i_product_management.svg';
  final String icSetting = '${_svgRoute}i_setting.svg';
  final String icFilter = '${_svgRoute}i_filter.svg';
  final String icEdit = '${_svgRoute}i_edit.svg';
  final String icEye = '${_svgRoute}i_eye.svg';
  final String icEyeOff = '${_svgRoute}i_eye_off.svg';
  final String icArrowLeftCircle = '${_svgRoute}i_arrow_left_circle.svg';
  final String icLockLarge = '${_svgRoute}i_lock_large.svg';
  final String icVerifyEmailLarge = '${_svgRoute}i_verify_email_large.svg';
  final String icCreateNewPassword = '${_svgRoute}i_create_new_password.svg';
  final String icSucceedingRegister = '${_svgRoute}i_succeeding_register.svg';
  final String icBellFill = '${_svgRoute}i_bell_fill.svg';
  final String icBellOutline = '${_svgRoute}i_bell_outline.svg';
  final String icBellOutlineBold = '${_svgRoute}i_bell_outline_bold.svg';
  final String icShoppingCart = '${_svgRoute}i_shopping_cart.svg';
  final String icShoppingCartFill = '${_svgRoute}i_shopping_cart_fill.svg';
  final String icHome = '${_svgRoute}i_home.svg';
  final String icUser = '${_svgRoute}i_user.svg';
  final String icCustomer = '${_svgRoute}i_customer.svg';
  final String icBarcode = '${_svgRoute}i_barcode.svg';
  final String icVoucher = '${_svgRoute}i_voucher.svg';
  final String icCart = '${_svgRoute}i_cart.svg';
  final String icChat = '${_svgRoute}i_chat.svg';
  final String icBox = '${_svgRoute}i_box.svg';
  final String icPost = '${_svgRoute}i_post.svg';
  final String icPhone = '${_svgRoute}i_phone.svg';
  final String icMail = '${_svgRoute}i_mail.svg';
  final String icPackage = '${_svgRoute}i_package.svg';
  final String icDelivery = '${_svgRoute}i_delivery.svg';
  final String icDeliveryTruck = '${_svgRoute}i_delivery_truck.svg';
  final String icReview = '${_svgRoute}i_review.svg';
  final String icRemoveCircle = '${_svgRoute}i_remove_circle.svg';
  final String bgScreen = '${_svgRoute}bg_edit_user_information_screen.svg';
  final String bgAccountScreen = '${_svgRoute}bg_account_screen.svg';
  final String bgTopLeftCoffee = '${_svgRoute}bg_top_left_coffee.svg';
  final String bgTopRightCoffee = '${_svgRoute}bg_top_right_coffee.svg';
  final String bgBottomRightMount = '${_svgRoute}bg_bottom_right_mount.svg';
  final String bgRightMount = '${_svgRoute}bg_right_mount.svg';
  final String bgBottomLeftMount = '${_svgRoute}bg_bottom_left_mount.svg';
  final String bgTopRightRegister = '${_svgRoute}bg_top_right_register.svg';
  final String bgTopCenterRegister = '${_svgRoute}bg_top_center_register.svg';
  final String bgTopLeftRegister = '${_svgRoute}bg_top_left_register.svg';
  final String bgBottomRightRegister =
      '${_svgRoute}bg_bottom_right_register.svg';
  final String bgBottomLeftRegister = '${_svgRoute}bg_bottom_left_register.svg';
  final String bgRightMountRegister = '${_svgRoute}bg_right_mount_register.svg';
  final String bgLeftMountRegister = '${_svgRoute}bg_left_mount_register.svg';
  final String imgDividerDashed = '${_svgRoute}img_divider_dashed.svg';

  _Onboarding onboarding(Brightness theme) => _Onboarding(theme);
}

class _Onboarding {
  late final String bgBottomLeftCoffee;
  late final String bgBottomCenterCoffee;
  late final String bgBottomRightCoffee;
  late final String bgBottomMount;
  late final String bgRightMount;
  late final String bgLeftMount;
  _Onboarding(Brightness theme) {
    if (theme == Brightness.light) {
      bgBottomLeftCoffee = '${_svgBGRoute}bg_bottom_left_coffee.svg';
      bgBottomCenterCoffee = '${_svgBGRoute}bg_bottom_center_coffee.svg';
      bgBottomRightCoffee = '${_svgBGRoute}bg_bottom_right_coffee.svg';
      bgBottomMount = '${_svgBGRoute}bg_bottom_mount.svg';
      bgRightMount = '${_svgBGRoute}bg_right_mount.svg';
      bgLeftMount = '${_svgBGRoute}bg_left_mount.svg';
    } else {
      bgBottomLeftCoffee = '${_svgBGRoute}bg_bottom_left_coffee_dark.svg';
      bgBottomCenterCoffee = '${_svgBGRoute}bg_bottom_center_coffee_dark.svg';
      bgBottomRightCoffee = '${_svgBGRoute}bg_bottom_right_coffee_dark.svg';
      bgBottomMount = '${_svgBGRoute}bg_bottom_mount_dark.svg';
      bgRightMount = '${_svgBGRoute}bg_right_mount_dark.svg';
      bgLeftMount = '${_svgBGRoute}bg_left_mount_dark.svg';
    }
  }
}
