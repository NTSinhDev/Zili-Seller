import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/cart/cart_cubit.dart';
import 'package:zili_coffee/data/models/cart/cart.dart';
import 'package:zili_coffee/data/models/cart/product_cart.dart';
import 'package:zili_coffee/data/models/order/order_export.dart';
import 'package:zili_coffee/data/repositories/cart_repository.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/module_common/address_form/address_form.dart';
import 'package:zili_coffee/views/payment/modules/checkout_view.dart';
import 'package:zili_coffee/views/payment/modules/discount_code.dart';
import 'package:zili_coffee/views/payment/modules/payment_method_card.dart';
part 'components/add_recipient_information_view.dart';
part 'components/bill_view.dart';
part 'components/payment_method_view.dart';

class FillInfoPaymentScreen extends StatefulWidget {
  const FillInfoPaymentScreen({super.key});
  static String keyName = '/fill-info-payment';

  @override
  State<FillInfoPaymentScreen> createState() => _FillInfoPaymentScreenState();
}

class _FillInfoPaymentScreenState extends State<FillInfoPaymentScreen> {
  int currentStep = 0;
  final pageController = PageController(initialPage: 0, keepPage: true);

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popScreen(context),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProgressStepperWidget(
                currentStep: currentStep,
                labels: const [
                  'Nhập thông tin nhận hàng',
                  'Chọn phương thức thanh toán',
                  'Xác nhận đơn và thanh toán',
                ],
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _AddRecipientInfoView(
                      nextStep: () {
                        setState(() => currentStep = 1);
                        pageController.animateToPage(
                          currentStep,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    _PaymentMethodView(
                      nextStep: () {
                        setState(() => currentStep = 2);
                        pageController.animateToPage(
                          currentStep,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                    ),
                    const _BillView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showNotification(BuildContext context) {
    context.showNotificationDialog(
      title: 'Thông báo',
      message: "Đơn hàng chưa được thanh toán, bạn có muốn thoát trang?",
      cancelWidget: CustomButtonWidget(
        onTap: () {
          context.navigator
            ..pop()
            ..pop();
        },
        width: 80.w,
        height: 32.h,
        radius: 4.r,
        borderColor: AppColors.primary,
        color: AppColors.white,
        boxShadows: const [],
        child: Center(
          child: Text(
            "Thoát",
            style: AppStyles.text.semiBold(
              fSize: 12.sp,
              color: AppColors.primary,
            ),
          ),
        ),
      ),
      action: "Ở lại",
    );
  }

  Future<bool> popScreen(BuildContext context) async {
    showNotification(context);
    return false;
  }
}
