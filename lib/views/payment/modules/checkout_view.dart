import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/order/order_cubit.dart';
import 'package:zili_coffee/data/models/cart/deliver_price.dart';
import 'package:zili_coffee/data/models/client_models/transaction_status.dart';
import 'package:zili_coffee/data/repositories/cart_repository.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/int.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/web_view/web_view_screen.dart';

class CheckoutView extends StatelessWidget {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartRepository cartRepo = di<CartRepository>();
    final OrderCubit cubit = di<OrderCubit>();
    return BlocListener<OrderCubit, OrderState>(
      bloc: cubit,
      listener: listener,
      child: StreamBuilder<DeliverPrice>(
          stream: cartRepo.deliverPriceStream,
          builder: (context, snapshot) {
            final deliverPrice = snapshot.hasData && snapshot.data != null
                ? snapshot.data!.price ?? 0
                : 0;
            final totalPrice = cartRepo.cart?.totalPrice ?? 0;
            return BottomViewWidget(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tạm tính',
                      style: AppStyles.text.medium(
                        fSize: 18.sp,
                        color: AppColors.primary,
                        height: 1.18,
                      ),
                    ),
                    Text(
                      totalPrice.toPrice(),
                      style: AppStyles.text.bold(
                        fSize: 18.sp,
                        color: AppColors.primary,
                        height: 1.18,
                      ),
                    ),
                  ],
                ),
                height(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Phí vận chuyển',
                      style: AppStyles.text.medium(
                        fSize: 18.sp,
                        color: AppColors.primary,
                        height: 1.18,
                      ),
                    ),
                    Text(
                      deliverPrice.toPrice(),
                      style: AppStyles.text.bold(
                        fSize: 18.sp,
                        color: AppColors.primary,
                        height: 1.18,
                      ),
                    ),
                  ],
                ),
                height(height: 14),
                Divider(
                  color: AppColors.primary,
                  thickness: 0.8,
                  height: 0.8.h,
                ),
                height(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tổng tiền',
                      style: AppStyles.text.medium(
                        fSize: 18.sp,
                        color: AppColors.primary,
                        height: 1.18,
                      ),
                    ),
                    Text(
                      (deliverPrice + totalPrice).toPrice(),
                      style: AppStyles.text.bold(
                        fSize: 18.sp,
                        color: AppColors.primary,
                        height: 1.18,
                      ),
                    ),
                  ],
                ),
                height(height: 20),
                CustomButtonWidget(
                  onTap: () async {
                    await cubit.updateOrder();
                  },
                  label: 'Thanh toán ngay',
                ),
              ],
            );
          }),
    );
  }

  Future<void> listener(BuildContext context, OrderState state) async {
    final CartRepository cartRepo = di<CartRepository>();

    if (state is UpdatingOrderState) {
      context.showLoading(message: 'Đang xử lý đơn hàng...');
    } else if (state is UpdatedOrderState) {
      // Order placed successfully
      cartRepo.clean().then((value) {
        context
          ..hideLoading()
          ..showCustomDialog(
            canPhysicalBack: false,
            canDismiss: false,
            child: UINotificationProvider.checkoutSuccess(context),
          );
      });
    } else if (state is UpdateFailedOrderState) {
      // Order failed
      context
        ..hideLoading()
        ..showNotificationDialog(
          message: state.error.errorMessage,
          cancelWidget: Container(),
          action: "Đóng",
        );
    } else if (state is OnlinePaymentState) {
      context.hideLoading();
      // Navigation to webview
      if (state.url.isNotEmpty) {
        context.navigator.push(route(url: state.url)).then((_) {
          // Payment online by momo, zalo, vnp
          final TransactionStatus? transaction =
              di<OrderRepository>().transactionStatusStream.valueOrNull;

          if (transaction == null) {
            return context.showCustomDialog(
              canPhysicalBack: false,
              canDismiss: false,
              barrierColor: Colors.black26,
              child: UINotificationProvider.checkoutFailed(context),
            );
          }

          if (transaction.vnp_ResponseCode == '00' &&
              transaction.vnp_TransactionStatus == '00') {
            // Order placed successfully
            cartRepo.clean().then((_) {
              context.showCustomDialog(
                barrierColor: Colors.black26,
                canPhysicalBack: false,
                canDismiss: false,
                child: UINotificationProvider.checkoutSuccess(context),
              );
            });
          } else {
            // Order failed
            context.showCustomDialog(
              canPhysicalBack: false,
              canDismiss: false,
              barrierColor: Colors.black26,
              child: UINotificationProvider.checkoutFailed(context),
            );
          }
        });
      }
    }
  }

  Route<T> route<T>({required String url}) {
    return MaterialPageRoute(builder: (context) => WebViewScreen(webURL: url));
  }
}
