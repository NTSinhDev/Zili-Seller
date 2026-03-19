/// File này được tự động generate bởi script generate_assets.dart
/// Chạy: dart run tools/generate_assets/generate_assets.dart
/// Hoặc: flutter pub run tools/generate_assets/generate_assets.dart
/// 
/// Để tự động generate sau mỗi lần pub get, thêm vào pubspec.yaml:
/// scripts:
///   post_get: dart run tools/generate_assets/generate_assets.dart

class AppAssets {
  AppAssets._();

  // Assets root path
  static const String assets = 'assets';

  // Android assets
  static final AssetAndroid android = AssetAndroid._();

  // Animations assets
  static final AssetAnimations animations = AssetAnimations._();

  // Icons assets
  static final AssetIcons icons = AssetIcons._();

  // Images assets
  static final AssetImages images = AssetImages._();

  // Ios assets
  static final AssetIos ios = AssetIos._();

  // Logos assets
  static final AssetLogos logos = AssetLogos._();

}

class AssetAndroid {
  AssetAndroid._();

  // Base path
  static const String path = 'assets/android';

  // Android
  static const String adaptiveIconBackgroundPng = 'assets/android/adaptive_icon_background.png';
  static const String adaptiveMonochromeImagePng = 'assets/android/adaptive_monochrome_image.png';
  static const String bgLauncherPng = 'assets/android/bg_launcher.png';
  static const String icLauncherPng = 'assets/android/ic_launcher.png';
  static const String padLogo768Png = 'assets/android/pad_logo_768.png';
}

class AssetAnimations {
  AssetAnimations._();

  // Base path
  static const String path = 'assets/animations';

  // Animations
  static const String aniFailedJson = 'assets/animations/ani_failed.json';
  static const String aniLostConnectionJson = 'assets/animations/ani_lost_connection.json';
  static const String aniSuccessJson = 'assets/animations/ani_success.json';
  static const String aniTrashJson = 'assets/animations/ani_trash.json';
}

class AssetIcons {
  AssetIcons._();

  // Base path
  static const String path = 'assets/icons';

  // Icons
  static const String bgAccountScreenSvg = 'assets/icons/bg_account_screen.svg';
  static const String bgBottomLeftMountSvg = 'assets/icons/bg_bottom_left_mount.svg';
  static const String bgBottomLeftRegisterSvg = 'assets/icons/bg_bottom_left_register.svg';
  static const String bgBottomRightMountSvg = 'assets/icons/bg_bottom_right_mount.svg';
  static const String bgBottomRightRegisterSvg = 'assets/icons/bg_bottom_right_register.svg';
  static const String bgEditUserInformationScreenSvg = 'assets/icons/bg_edit_user_information_screen.svg';
  static const String bgLeftMountRegisterSvg = 'assets/icons/bg_left_mount_register.svg';
  static const String bgRightMountSvg = 'assets/icons/bg_right_mount.svg';
  static const String bgRightMountRegisterSvg = 'assets/icons/bg_right_mount_register.svg';
  static const String bgTopCenterRegisterSvg = 'assets/icons/bg_top_center_register.svg';
  static const String bgTopLeftCoffeeSvg = 'assets/icons/bg_top_left_coffee.svg';
  static const String bgTopLeftRegisterSvg = 'assets/icons/bg_top_left_register.svg';
  static const String bgTopRightCoffeeSvg = 'assets/icons/bg_top_right_coffee.svg';
  static const String bgTopRightRegisterSvg = 'assets/icons/bg_top_right_register.svg';
  static const String i2faSvg = 'assets/icons/i_2fa.svg';
  static const String iAddCustomerSvg = 'assets/icons/i_add_customer.svg';
  static const String iArrowLeftCircleSvg = 'assets/icons/i_arrow_left_circle.svg';
  static const String iArticlePersonSvg = 'assets/icons/i_article_person.svg';
  static const String iBarcodeSvg = 'assets/icons/i_barcode.svg';
  static const String iBellFillSvg = 'assets/icons/i_bell_fill.svg';
  static const String iBellOutlineSvg = 'assets/icons/i_bell_outline.svg';
  static const String iBellOutlineBoldSvg = 'assets/icons/i_bell_outline_bold.svg';
  static const String iBoxSvg = 'assets/icons/i_box.svg';
  static const String iBranchSvg = 'assets/icons/i_branch.svg';
  static const String iCartSvg = 'assets/icons/i_cart.svg';
  static const String iChatSvg = 'assets/icons/i_chat.svg';
  static const String iCheckRadioSvg = 'assets/icons/i_check_radio.svg';
  static const String iCreateNewPasswordSvg = 'assets/icons/i_create_new_password.svg';
  static const String iCustomerSvg = 'assets/icons/i_customer.svg';
  static const String iDeliverySvg = 'assets/icons/i_delivery.svg';
  static const String iDeliveryTruckSvg = 'assets/icons/i_delivery_truck.svg';
  static const String iDisLikeSvg = 'assets/icons/i_dis_like.svg';
  static const String iEditSvg = 'assets/icons/i_edit.svg';
  static const String iExportPackingSvg = 'assets/icons/i_export_packing.svg';
  static const String iExportWarehouseSvg = 'assets/icons/i_export_warehouse.svg';
  static const String iEyeSvg = 'assets/icons/i_eye.svg';
  static const String iEyeOffSvg = 'assets/icons/i_eye_off.svg';
  static const String iFilterSvg = 'assets/icons/i_filter.svg';
  static const String iGreenBeansSvg = 'assets/icons/i_green_beans.svg';
  static const String iGroupPeopleSvg = 'assets/icons/i_group_people.svg';
  static const String iHandThumbDownSvg = 'assets/icons/i_hand_thumb_down.svg';
  static const String iHandThumbUpSvg = 'assets/icons/i_hand_thumb_up.svg';
  static const String iHomeSvg = 'assets/icons/i_home.svg';
  static const String iLikeSvg = 'assets/icons/i_like.svg';
  static const String iLockSvg = 'assets/icons/i_lock.svg';
  static const String iLockLargeSvg = 'assets/icons/i_lock_large.svg';
  static const String iLogOutSvg = 'assets/icons/i_log_out.svg';
  static const String iMailSvg = 'assets/icons/i_mail.svg';
  static const String iMapPinSvg = 'assets/icons/i_map_pin.svg';
  static const String iOrderManagementSvg = 'assets/icons/i_order_management.svg';
  static const String iPackageSvg = 'assets/icons/i_package.svg';
  static const String iPhoneSvg = 'assets/icons/i_phone.svg';
  static const String iPostSvg = 'assets/icons/i_post.svg';
  static const String iPrintSvg = 'assets/icons/i_print.svg';
  static const String iProductManagementSvg = 'assets/icons/i_product_management.svg';
  static const String iQuotationSvg = 'assets/icons/i_quotation.svg';
  static const String iRefreshSvg = 'assets/icons/i_refresh.svg';
  static const String iRemoveCircleSvg = 'assets/icons/i_remove_circle.svg';
  static const String iRepliedSvg = 'assets/icons/i_replied.svg';
  static const String iReviewSvg = 'assets/icons/i_review.svg';
  static const String iSettingSvg = 'assets/icons/i_setting.svg';
  static const String iShieldLockSvg = 'assets/icons/i_shield_lock.svg';
  static const String iShoppingCartSvg = 'assets/icons/i_shopping_cart.svg';
  static const String iShoppingCartFillSvg = 'assets/icons/i_shopping_cart_fill.svg';
  static const String iSpeakerWaveSvg = 'assets/icons/i_speaker_wave.svg';
  static const String iSpeakerXMarkSvg = 'assets/icons/i_speaker_x_mark.svg';
  static const String iStarSvg = 'assets/icons/i_star.svg';
  static const String iStarHalfSvg = 'assets/icons/i_star_half.svg';
  static const String iStarNoneSvg = 'assets/icons/i_star_none.svg';
  static const String iStarOutlineSvg = 'assets/icons/i_star_outline.svg';
  static const String iSucceedingRegisterSvg = 'assets/icons/i_succeeding_register.svg';
  static const String iUserSvg = 'assets/icons/i_user.svg';
  static const String iVerifyEmailLargeSvg = 'assets/icons/i_verify_email_large.svg';
  static const String iVoucherSvg = 'assets/icons/i_voucher.svg';
  static const String iVoucherBlackSvg = 'assets/icons/i_voucher_black.svg';
  static const String iWarehouseManagementSvg = 'assets/icons/i_warehouse_management.svg';
  static const String iXmarkSvg = 'assets/icons/i_xmark.svg';
  static const String iXmarkXlSvg = 'assets/icons/i_xmark_xl.svg';
  static const String imgDividerDashedSvg = 'assets/icons/img_divider_dashed.svg';
  static const String logoSvg = 'assets/icons/logo.svg';
  static const String logoFacebookSvg = 'assets/icons/logo_facebook.svg';
  static const String logoGoogleSvg = 'assets/icons/logo_google.svg';
  static const String logoMinimalistSvg = 'assets/icons/logo_minimalist.svg';
}

class AssetImages {
  AssetImages._();

  // Base path
  static const String path = 'assets/images';

  // Images
  static const String bgStatisticChartJpg = 'assets/images/bg-statistic-chart.jpg';
  static const String bgVoucherFramePng = 'assets/images/bg_voucher_frame.png';
  static const String emptyBoxPng = 'assets/images/empty-box.png';
  static const String logoPng = 'assets/images/logo.png';
  static const String newsPng = 'assets/images/news.png';
  static const String productDesc1Png = 'assets/images/product_desc1.png';
  static const String ziliTeaPng = 'assets/images/zili_tea.png';
}

class AssetIos {
  AssetIos._();

  // Base path
  static const String path = 'assets/ios';

  // Launch_background
  static const String launchBackground = 'assets/ios/launch_background';
  // Launch_background
  static const String launchBackgroundBgLaunchScreen1xPng = 'assets/ios/launch_background/bg_launch_screen_1x.png';
  static const String launchBackgroundBgLaunchScreen2xPng = 'assets/ios/launch_background/bg_launch_screen_2x.png';
  static const String launchBackgroundBgLaunchScreen3xPng = 'assets/ios/launch_background/bg_launch_screen_3x.png';

  // Launch_image
  static const String launchImage = 'assets/ios/launch_image';
  // Launch_image
  static const String launchImageIconLaunchScreen1xPng = 'assets/ios/launch_image/icon_launch_screen_1x.png';
  static const String launchImageIconLaunchScreen2xPng = 'assets/ios/launch_image/icon_launch_screen_2x.png';
  static const String launchImageIconLaunchScreen3xPng = 'assets/ios/launch_image/icon_launch_screen_3x.png';

  // Ios
  static const String icLauncherPng = 'assets/ios/ic_launcher.png';
}

class AssetLogos {
  AssetLogos._();

  // Base path
  static const String path = 'assets/logos';

  // Logos
  static const String baseLogoPng = 'assets/logos/base_logo.png';
  static const String logoPng = 'assets/logos/logo.png';
  static const String logoLauncherPng = 'assets/logos/logo_launcher.png';
}

