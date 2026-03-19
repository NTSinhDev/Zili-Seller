part of '../fill_info_payment_screen.dart';

class _AddRecipientInfoView extends StatelessWidget {
  final Function() nextStep;
  const _AddRecipientInfoView({required this.nextStep});

  @override
  Widget build(BuildContext context) {
    final cartCubit = di<CartCubit>();
    final OrderRepository orderRepository = di<OrderRepository>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 20.h),
          child: Text(
            'THÔNG TIN ĐỊA CHỈ',
            style: AppStyles.text.semiBold(
              fSize: 18.sp,
              color: AppColors.primary,
            ),
          ),
        ),
        Expanded(
          child: AddressForm(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            labelSubmitBtn: "Tiếp tục",
            onCreatedAddress: (address) async {
              await cartCubit.getDeliverPrice(
                address.province!.id,
                address.district!.id,
              );
              // orderRepository.currentOrder = orderRepository.currentOrder!
              //     .copyWith(shippingAddress: address);
              nextStep();
            },
          ),
        ),
      ],
    );
  }
}
