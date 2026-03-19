import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/category/category_cubit.dart';
import 'package:zili_coffee/data/models/category.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class ProductsByLineageScreen extends StatelessWidget {
  const ProductsByLineageScreen({super.key});
  static String keyName = '/products-by-lineages';

  @override
  Widget build(BuildContext context) {
    final arguments = context.route!.settings.arguments as Map<int, dynamic>;
    final List<Product> products = arguments[0] as List<Product>;
    final title = arguments[1] as String;
    final Category? category =
        arguments[2] != null ? arguments[2] as Category : null;
    final CategoryCubit cubit = di<CategoryCubit>();

    return products.isNotEmpty
        ? Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBarWidget.lightAppBar(context, label: title),
            body: GridView.builder(
              padding: EdgeInsets.all(20.w),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20.w,
                mainAxisSpacing: 20.w,
                childAspectRatio: 0.59,
              ),
              itemCount: products.length,
              clipBehavior: Clip.none,
              itemBuilder: (BuildContext context, int index) =>
                  CustomCardWidget.product(product: products[index]),
            ),
          )
        : Scaffold(
            backgroundColor: AppColors.white,
            appBar: AppBarWidget.lightAppBar(context, label: title),
            body: FutureBuilder<List<Product>>(
              future: cubit.getProductsByCategory(category: category!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container();
                }
                if (snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "Sản phẩm không được tìm thấy",
                      style: AppStyles.text.mediumItalic(
                        fSize: 15.sp,
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.all(20.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.w,
                    mainAxisSpacing: 20.w,
                    childAspectRatio: 0.59,
                  ),
                  itemCount: snapshot.hasData ? snapshot.data!.length : 4,
                  clipBehavior: Clip.none,
                  itemBuilder: (BuildContext context, int index) =>
                      CustomCardWidget.product(product: snapshot.data?[index]),
                );
              },
            ),
          );
  }
}
