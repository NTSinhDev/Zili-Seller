part of '../fill_info_payment_screen.dart';

class _PaymentMethodView extends StatefulWidget {
  final Function() nextStep;
  const _PaymentMethodView({super.key, required this.nextStep});

  @override
  State<_PaymentMethodView> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<_PaymentMethodView> {
  String currentMethod = "COD";
  final OrderRepository orderRerpo = di<OrderRepository>();
  final CartRepository cartRepo = di<CartRepository>();
  List<PaymentMethod> paymentMethods = [];

  @override
  void initState() {
    super.initState();
    paymentMethods = cartRepo.paymenMethods;
    paymentMethods.sort((a, b) {
      if (a.paymentEnum == currentMethod) {
        return 0;
      }
      return 1;
    });
    // orderRerpo.currentOrder = orderRerpo.currentOrder!.copyWith(
    //   paymentDetail: PaymentDetail(
    //     paymentMethod: paymentMethods[0],
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 20.h),
          child: Text(
            'PHƯƠNG THỨC THANH TOÁN',
            style: AppStyles.text.semiBold(
              fSize: 18.sp,
              color: AppColors.primary,
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                height(height: 8.h),
                ...paymentMethods
                    .map((method) => Container(
                          margin: EdgeInsets.only(bottom: 20.w),
                          child: PaymentMethodCard(
                            isSelected: currentMethod == method.paymentEnum,
                            selected: () => _selected(method),
                            method: method.name,
                            icon: method.url!,
                          ),
                        ))
                    ,
                const Spacer(),
                CustomButtonWidget(onTap: onContinue, label: 'Tiếp tục'),
                height(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void onContinue() {
    for (PaymentMethod method in paymentMethods) {
      if (method.paymentEnum == currentMethod) {
        // orderRerpo.currentOrder = orderRerpo.currentOrder!.copyWith(
        //   paymentDetail: PaymentDetail(
        //     paymentMethod: method,
        //   ),
        // );
      }
    }

    widget.nextStep();
  }

  void _selected(PaymentMethod method) {
    if (currentMethod == method.paymentEnum) return;
    setState(() {
      currentMethod = method.paymentEnum;
    });
  }
}
