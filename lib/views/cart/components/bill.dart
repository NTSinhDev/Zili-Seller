part of '../my_cart_screen.dart';

class _Bill extends StatelessWidget {
  final Cart? cart;
  final CartCubit cartCubit;
  const _Bill({required this.cart, required this.cartCubit});

  @override
  Widget build(BuildContext context) {
    final OrderCubit orderCubit = di<OrderCubit>();
    final AddressCubit addressCubit = di<AddressCubit>();
    final AddressRepository addressRepo = di<AddressRepository>();
    return BlocListener<OrderCubit, OrderState>(
      bloc: orderCubit,
      listener: (_, state) async {
        if (state is CreatingOrderState) {
          context.showLoading(message: 'Tạo đơn hàng...');
        } else if (state is CreatedOrderState) {
          addressCubit.getAllAddress().then((_) {
            cartCubit.getPaymentMethod().then((_) {
              if (addressRepo.addresses.hasValue) {
                final address = addressRepo.addresses.value;
                if (address.isNotEmpty) {
                  context.hideLoading();
                  context.navigator.pushNamed(CheckoutScreen.keyName);
                } else {
                  context.hideLoading();
                  context.navigator.pushNamed(FillInfoPaymentScreen.keyName);
                }
              }
            });
          });
        } else if (state is CreateFailedOrderState) {
          context
            ..hideLoading()
            ..showNotificationDialog(
              message: state.error.errorMessage,
              cancelWidget: Container(),
              action: "Đóng",
            );
        }
      },
      child: BottomViewWidget(
        children: [
          Text(
            'Thông tin đơn hàng',
            style: AppStyles.text.semiBold(fSize: 18.sp, height: 1.18),
          ),
          height(height: 6),
          Divider(
            color: AppColors.black.withOpacity(0.5),
            height: 1.h,
            thickness: 1,
          ),
          height(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Tổng tiền',
                style: AppStyles.text.medium(fSize: 18.sp, height: 1.18),
              ),
              Text(
                (cart?.totalPrice ?? 0).toPrice(),
                style: AppStyles.text.medium(fSize: 18.sp, height: 1.18),
              ),
            ],
          ),
          height(height: 12),
          Divider(
            color: AppColors.black.withOpacity(0.5),
            height: 1.h,
            thickness: 1,
          ),
          height(height: 8),
          Text(
            'Phí vận chuyển sẽ được tính ở trang thanh toán',
            style: AppStyles.text.mediumItalic(
              fSize: 16.sp,
              height: 1.18,
              color: AppColors.black.withOpacity(0.5),
            ),
          ),
          height(height: 15),
          BlocBuilder<CartCubit, CartState>(
              bloc: cartCubit,
              builder: (context, state) {
                return CustomButtonWidget(
                  onTap: state is CheckingCartState
                      ? () {}
                      : () async => hanldeOnPressPayment(context, orderCubit),
                  label: state is CheckingCartState
                      ? ''
                      : 'Thanh toán - ${(cart?.totalPrice ?? 0).toPrice()}',
                );
              }),
        ],
      ),
    );
  }

  Future<void> hanldeOnPressPayment(BuildContext context, OrderCubit cubit) async {
    // Authen before checkout
    final AuthRepository authRepository = di<AuthRepository>();
    if (authRepository.currentAuth == null) {
      context.showCustomDialog(
        height: 160.h,
        barrierColor: Colors.black38,
        canDismiss: false,
        backgroundColor: AppColors.white,
        child: UINotificationProvider.blockedIfNotAuthentication(
          context,
          notificationContent:
              "Vui lòng đăng nhập trước khi thực hiện thanh toán đơn hàng!",
          passArgsToAuthScreen: NavArgsKey.fromCart,
        ),
      );
      return;
    }

    // checkout my cart
    await cubit.createOrder(cart!.products);
  }
}
