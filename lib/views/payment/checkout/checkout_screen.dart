import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/cart/cart.dart';
import 'package:zili_coffee/data/models/cart/product_cart.dart';
import 'package:zili_coffee/data/models/order/order_export.dart';
import 'package:zili_coffee/data/repositories/cart_repository.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/order_recipient_info.dart';
import 'package:zili_coffee/views/payment/modules/checkout_view.dart';
import 'package:zili_coffee/views/payment/modules/discount_code.dart';
import 'package:zili_coffee/views/payment/modules/payment_method_card.dart';
part 'components/payment_method.dart';
part 'components/products_info.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});
  static String keyName = '/check-out';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showNotification(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Thanh toán',
          onBack: () => showNotification(context),
        ),
        backgroundColor: AppColors.white,
        body: SizedBox(
          width: Spaces.screenWidth(context),
          height: Spaces.screenHeight(context),
          child: Stack(
            children: [
              Scrollbar(
                radius: Radius.circular(4.r),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const OrderRecipientInfo(readOnly: false),
                      const _PaymentMethod(),
                      height(height: 20),
                      Divider(
                        color: AppColors.lightGrey,
                        height: 1.h,
                        thickness: 1,
                      ),
                      const _ProductsInfo(),
                    ],
                  ),
                ),
              ),
              const CheckoutView(),
            ],
          ),
        ),
      ),
    );
  }

  void showNotification(BuildContext context) {
    context.showCustomDialog(
      height: 160.h,
      barrierColor: Colors.black12,
      canDismiss: false,
      backgroundColor: AppColors.white,
      child: UINotificationProvider.common(
        context,
        title: 'Thông báo',
        content: 'Đơn hàng chưa được thanh toán, bạn có muốn thoát trang?',
        leftButton: 'Tiếp tục',
        rightButton: 'Thoát',
        onTap: () => context.navigator.pop(),
      ),
    );
  }
}
