import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/address/address_cubit.dart';
import 'package:zili_coffee/bloc/cart/cart_cubit.dart';
import 'package:zili_coffee/bloc/order/order_cubit.dart';
import 'package:zili_coffee/data/models/cart/cart.dart';
import 'package:zili_coffee/data/models/cart/product_cart.dart';
import 'package:zili_coffee/data/repositories/address_repository.dart';
import 'package:zili_coffee/data/repositories/auth_repository.dart';
import 'package:zili_coffee/data/repositories/cart_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/int.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/payment/checkout/checkout_screen.dart';
import 'package:zili_coffee/views/payment/fill_info_payment/fill_info_payment_screen.dart';
part 'components/bill.dart';

class MyCartScreen extends StatefulWidget {
  const MyCartScreen({super.key});
  static String keyName = '/cart';

  @override
  State<MyCartScreen> createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  final CartRepository cartRepository = di<CartRepository>();
  final CartCubit cartCubit = di<CartCubit>();

  @override
  void initState() {
    super.initState();
    getCartinfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Giỏ hàng của tôi',
      ),
      backgroundColor: AppColors.white,
      body: StreamBuilder<Cart>(
        stream: cartRepository.cartStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const EmptyListViewWidget();
          }
          final cart = snapshot.data!;
          if (cart.products.isEmpty) {
            return const EmptyListViewWidget();
          } else {
            return Stack(
              children: [
                SizedBox(
                  height: Spaces.screenHeight(context),
                  width: Spaces.screenWidth(context),
                  child: Scrollbar(
                    radius: Radius.circular(4.r),
                    child: SingleChildScrollView(
                      child: _fetchCartDataToWidget(context, cart.products),
                    ),
                  ),
                ),
                _Bill(cart: cart, cartCubit: cartCubit),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _fetchCartDataToWidget(BuildContext context, List<ProductCart> data) {
    if (data.isEmpty) return Container();
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 216.h),
      child: Column(
        children: [
          for (int i = 0; i < data.length; i++) ...[
            CustomCardWidget.cartItem(
              productCart: data[i],
              removeItem: () {
                context.showCustomDialog(
                  height: 140.h,
                  barrierColor: Colors.black38,
                  canDismiss: false,
                  backgroundColor: AppColors.white,
                  child: UINotificationProvider.common(
                    context,
                    title: 'Xác nhận xóa?',
                    content: "Bạn có chắc muốn xóa sản phẩm này?",
                    leftButton: 'Hủy',
                    rightButton: 'Xác nhận',
                    onTap: () => cartRepository.deleteCartItem(data[i]),
                  ),
                );
              },
            )
          ]
        ],
      ),
    );
  }

  void getCartinfo() {
    if (cartRepository.cart == null || cartRepository.cart!.products.isEmpty) {
      return;
    }
    for (var prod in cartRepository.cart!.products) {
      cartCubit.getProductInformation(prod);
    }
  }
}
