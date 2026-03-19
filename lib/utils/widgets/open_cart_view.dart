import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:zili_coffee/data/models/cart/cart.dart';
import 'package:zili_coffee/data/repositories/cart_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/views/cart/my_cart_screen.dart';

class OpenCartView extends StatelessWidget {
  final Color? color;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  const OpenCartView({
    super.key,
    this.color,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final CartRepository cartRepository = di<CartRepository>();
    return Container(
      padding: padding,
      margin: margin,
      height: 46.h,
      child: InkWell(
        onTap: () => context.navigator.pushNamed(MyCartScreen.keyName),
        borderRadius: BorderRadius.circular(1000),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                      width: 50.w,
                      child: SvgPicture.asset(
                        AppConstant.svgs.icShoppingCartFill,
                        colorFilter: ColorFilter.mode(
                          color ?? AppColors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
            ),
            StreamBuilder<Cart>(
                stream: cartRepository.cartStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      snapshot.data == null ||
                      snapshot.data!.products.isEmpty) {
                    return Container();
                  }
                  return Positioned(
                    top: 0.h,
                    right: 8.w,
                    child: Container(
                      width: 15.w,
                      height: 15.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.scarlet,
                      ),
                      child: Center(
                        child: Text(
                          snapshot.data!.products.length.toString(),
                          style: AppStyles.text.medium(
                            fSize: 9.sp,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
