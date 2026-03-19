part of '../checkout_screen.dart';

class _PaymentMethod extends StatefulWidget {
  const _PaymentMethod({super.key});

  @override
  State<_PaymentMethod> createState() => _PaymentMethodViewState();
}

class _PaymentMethodViewState extends State<_PaymentMethod> {
  int currentMethod = 0;
  final OrderRepository orderRerpo = di<OrderRepository>();
  final CartRepository cartRepo = di<CartRepository>();
  List<PaymentMethod> paymentMethods = [];

  @override
  void initState() {
    super.initState();
    paymentMethods = cartRepo.paymenMethods;
    paymentMethods.sort((a, b) {
      if (a.paymentEnum == "COD") return 0;
      return 1;
    });
    // orderRerpo.currentOrder = orderRerpo.currentOrder!.copyWith(
    //   paymentDetail: PaymentDetail(
    //     paymentMethod: paymentMethods[currentMethod],
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
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: paymentMethods.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.only(bottom: 20.w),
              child: PaymentMethodCard(
                isSelected: currentMethod == index,
                selected: () => _selected(index),
                method: paymentMethods[index].name,
                icon: paymentMethods[index].url!,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _selected(int index) {
    if (currentMethod == index) return;
    setState(() {
      currentMethod = index;
    });
    // orderRerpo.currentOrder = orderRerpo.currentOrder!.copyWith(
    //   paymentDetail: PaymentDetail(paymentMethod: paymentMethods[index]),
    // );
  }
}
