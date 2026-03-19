import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/product/product_cubit.dart';
import '../../../data/models/product/company_product.dart';
import '../../../data/repositories/product_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/company_product_variant_card.dart';
import '../../common/shimmer_view.dart';

class VariantsView extends StatelessWidget {
  final int tabIndex; 
  const VariantsView({super.key, required this.tabIndex});

  @override
  Widget build(BuildContext context) {
    return Offstage(
      offstage: tabIndex != 1,
      child: StreamBuilder<CompanyProduct?>(
        stream: di<ProductRepository>().companyProductDetailStreamData.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const ShimmerView(type: .normal);
          }

          final CompanyProduct? data = snapshot.data;
          
          return CommonLoadMoreRefreshWrapper.refresh(
            context,
            onRefresh: data?.id != null
                ? () async => await di<ProductCubit>()
                      .fetchCompanyProductDetail(productId: data!.id)
                : () async {},
            child: SingleChildScrollView(
              child: ColumnWidget(
                margin: .symmetric(vertical: 16.h),
                gap: 12.h,
                children:
                    data?.productVariants
                        .map((e) => CompanyProductVariantCard(data: e))
                        .toList() ??
                    [],
              ),
            ),
          );
        },
      ),
    );
  }
}
