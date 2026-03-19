import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/flash_sale/flash_sale_cubit.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/repositories/flash_sale_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/colors.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class FlashSaleScreen extends StatelessWidget {
  final FlashSaleRepository repository;
  const FlashSaleScreen({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    final FlashSaleCubit flashSaleCubit = di<FlashSaleCubit>();
    if (!repository.productStreamData.hasValue) {
      flashSaleCubit.getProductsSale();
    }
    return RefreshIndicator(
      onRefresh: () async {
        await repository.clean();
        await flashSaleCubit.getProductsSale();
      },
      color: AppColors.primary,
      child: Scrollbar(
        radius: Radius.circular(4.r),
        child: StreamBuilder<List<Product>>(
            stream: repository.productStreamData.stream,
            builder: (context, snapshot) {
              // if (snapshot.connectionState == ConnectionState.waiting) {
              //   return Container(
              //     color: AppColors.white,
              //     padding: EdgeInsets.only(bottom: 90.h),
              //     child: GridView.builder(
              //       padding: EdgeInsets.all(24.w),
              //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //         crossAxisCount: 2,
              //         crossAxisSpacing: 20.w,
              //         mainAxisSpacing: 20.w,
              //         childAspectRatio: 0.59,
              //       ),
              //       itemCount: 6,
              //       clipBehavior: Clip.none,
              //       itemBuilder: (BuildContext context, int index) =>
              //           CustomCardWidget.product(),
              //     ),
              //   );
              // }
              final List<Product>? products = snapshot.data;
              return Container(
                color: AppColors.white,
                padding: EdgeInsets.only(bottom: 90.h),
                child: GridView.builder(
                  padding: EdgeInsets.all(24.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.w,
                    mainAxisSpacing: 20.w,
                    childAspectRatio: 0.59,
                  ),
                  itemCount: products != null ? products.length : 6,
                  clipBehavior: Clip.none,
                  itemBuilder: (BuildContext context, int index) =>
                      CustomCardWidget.product(product: products?[index]),
                ),
              );
            }),
      ),
    );
  }
}
