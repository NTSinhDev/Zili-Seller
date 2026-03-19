// ignore_for_file: constant_identifier_names
import 'package:flutter/material.dart';
part 'svg.dart';
part 'animation.dart';
part 'image.dart';
part 'string.dart';
part 'order.dart';

const String _imgRoute = 'assets/images/';
const String _svgRoute = 'assets/icons/';
const String _svgBGRoute = 'assets/icons/background_onboarding/';
const String _aniRoute = 'assets/animations/';

class NavArgsKey {
  static const String fromHome = 'trang chủ';
  static const String fromLogin = 'đăng nhập';
  static const String fromRegister = 'from-register';
  static const String fromPayment = 'from-payment';
  static const String fromCart = 'giỏ hàng';
  static const String fromReview = 'đánh giá sản phẩm';
  static const String fromChangePassword = '';
}

class OrderConstant {
  static const String finalized = 'finalized';
  static const String completed = 'completed';
  static const String cancelled = 'cancelled';
  static const String waitingConfirmation = 'waiting_confirmation';
  static const String waitingPayment = 'waiting_payment';
  static const String successful = 'successful';
  static const String shipped = "shipped";
  static const String packed = "packed";
  static const String returnStatus = "return";
  static const String refund = "refund";
  static const String unreturned = "unreturned";
  static const String vnp_TxnRef = "vnp_TxnRef";
  static const String vnp_ResponseCode = "vnp_ResponseCode";
  static const String vnp_TransactionStatus = "vnp_TransactionStatus";
  static final orderStatus = _OrderStatus();
}

class AppConstant {
  static final images = _Images();
  static final svgs = _SVGs();
  static final strings = _Strings();
  static final animations = _Animations();
}