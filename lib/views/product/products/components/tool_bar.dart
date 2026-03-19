part of '../products_screen.dart';

class _Toolbar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final bool lengthFromSourceFilter;
  const _Toolbar({
    required this.scaffoldKey,
    this.lengthFromSourceFilter = false,
  });

  @override
  Widget build(BuildContext context) {
    final ProductRepository productRepository = di<ProductRepository>();
    return Container(
      width: Spaces.screenWidth(context),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      color: AppColors.lightGrey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (lengthFromSourceFilter)
            StreamBuilder<int>(
              stream: productRepository.behaviorFilterTotalRecord,
              builder: (context, snapshot) {
                return Text(
                  '${snapshot.data != null ? snapshot.data! : 0} sản phẩm',
                  style: AppStyles.text.semiBold(fSize: 12.sp),
                );
              },
            )
          else
            StreamBuilder<Map<String, dynamic>>(
              stream: productRepository.productsScreenStreamData.stream,
              builder: (context, snapshot) {
                int totalProduct = 0;
                if (snapshot.hasData) {
                  final data = snapshot.data?['categories'] ?? [];
                  for (var i = 0; i < data.length; i++) {
                    final products = snapshot.data!['productsByCategoryIndex']
                        as Map<int, List<Product>>;
                    totalProduct += products[i]!.length;
                  }
                }
                return Text(
                  '$totalProduct sản phẩm',
                  style: AppStyles.text.semiBold(fSize: 12.sp),
                );
              },
            ),
          InkWell(
            onTap: () {
              if (scaffoldKey.currentState != null) {
                scaffoldKey.currentState!.openEndDrawer();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(AppConstant.svgs.icFilter),
                width(width: 6),
                Text('Sắp xếp', style: AppStyles.text.medium(fSize: 14.sp)),
                width(width: 12),
                CustomIconStyle(
                  icon: CupertinoIcons.chevron_down,
                  style: AppStyles.text.semiBold(fSize: 16.sp),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
