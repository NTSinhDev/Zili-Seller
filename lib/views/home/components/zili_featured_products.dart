part of '../home_screen.dart';

class _ZiliFeaturedProducts extends StatefulWidget {
  const _ZiliFeaturedProducts();

  @override
  State<_ZiliFeaturedProducts> createState() => _ZiliFeaturedProductsState();
}

class _ZiliFeaturedProductsState extends State<_ZiliFeaturedProducts> {
  final ProductRepository productRepo = di<ProductRepository>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCubit, ProductState>(
      bloc: di<ProductCubit>()..getFeaturedProduct(),
      listener: (context, state) {
        if (state is GotProductsState) {
          setState(() {});
        }
      },
      child: Column(
        children: [
          RowWidget(
            padding: .symmetric(horizontal: 20.w),
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                alignment: .center,
                decoration: BoxDecoration(
                  borderRadius: .circular(4.r),
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.black.withValues(alpha: 0.2),
                      offset: const Offset(1, 1),
                      blurRadius: 2.r,
                    ),
                  ],
                ),
                child: Text(
                  "Z",
                  style: AppStyles.text.bold(
                    fSize: 16.sp,
                    color: AppColors.white,
                  ),
                ),
                // SvgPicture.asset(
                //   AppConstant.svgs.icCart,
                //   width: 14.w,
                //   height: 14.w,
                //   fit: BoxFit.fill,
                //   colorFilter: const ColorFilter.mode(
                //     AppColors.white,
                //     BlendMode.srcIn,
                //   ),
                // ),
              ),
              width(width: 10),
              Text(
                'Sản phẩm Zili',
                style: AppStyles.text.semiBold(fSize: 16.sp),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  if (!await launchUrl(Uri.parse(NetworkUrl.baseURLWebSite))) {
                    throw Exception('Could not browse to Zili website');
                  }
                },
                child: Padding(
                  padding: .symmetric(horizontal: 12.w, vertical: 4.h),
                  child: Text(
                    'Xem thêm',
                    style: AppStyles.text.bold(
                      fSize: 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: .horizontal,
            clipBehavior: .none,
            padding: .symmetric(horizontal: 20.w, vertical: 16.h),
            child: RowWidget(
              gap: 20.w,
              children: productRepo.featuredProducts.isEmpty
                  ? [
                      CustomCardWidget.product(),
                      CustomCardWidget.product(),
                      CustomCardWidget.product(),
                    ]
                  : productRepo.featuredProducts
                        .map((e) => CustomCardWidget.product(product: e))
                        .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
