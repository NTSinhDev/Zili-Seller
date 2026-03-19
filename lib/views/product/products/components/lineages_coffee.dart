part of '../products_screen.dart';

class _LineagesCoffee extends StatelessWidget {
  const _LineagesCoffee();

  @override
  Widget build(BuildContext context) {
    final ProductRepository productRepository = di<ProductRepository>();
    return StreamBuilder<Map<String, dynamic>>(
        stream: productRepository.productsScreenStreamData.stream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [_item(), _item(), _item()],
              ),
            );
          }
          return Container();
          // return SliderWidget(
          //   height: 155.h,
          //   enableInfiniteScroll: false,
          //   items: ((snapshot.data?["categories"] ?? <Category>[]) as List<Category>)
          //       .groupList(3)
          //       .map((categories) {
          //     return Container(
          //       padding: EdgeInsets.symmetric(horizontal: 20.w),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         crossAxisAlignment: CrossAxisAlignment.center,
          //         children: categories.map((category) {
          //           return _item(
          //             imageURL: category.imageUrlThumb!,
          //             label: category.nameDisplay,
          //             onTap: () async {
          //               context.navigator.pushNamed(
          //                 ProductsByLineageScreen.keyName,
          //                 arguments: {
          //                   0: <Product>[],
          //                   1: category.name,
          //                   2: category,
          //                 },
          //               );
          //             },
          //           );
          //         }).toList(),
          //       ),
          //     );
          //   }).toList(),
          // );
        });
  }

  Widget _item({String? imageURL, String? label, Function()? onTap}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          height(height: 22),
          InkWell(
            onTap: onTap,
            child: Container(
              width: 70.w,
              height: 70.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.25),
                    offset: const Offset(0.0, 0.0),
                    blurRadius: 4.0,
                  ),
                ],
                color: AppColors.lightGrey,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(1000.r),
                child: ImageLoadingWidget(
                  url: imageURL ?? '',
                  width: 70.w,
                  height: 70.w,
                ),
              ),
            ),
          ),
          height(height: 12),
          Column(
            children: [
              PlaceholderWidget(
                width: 104.w,
                height: 17.h,
                condition: label != null,
                child: SizedBox(
                  width: 104.w,
                  height: 34.h,
                  child: Text(
                    label ?? '',
                    maxLines: 3,
                    style: AppStyles.text.medium(fSize: 14.sp, height: 1.295),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (label == null) ...[
                height(height: 4),
                PlaceholderWidget(
                  width: 74.w,
                  height: 17.h,
                  // borderRadius: false,
                ),
              ]
            ],
          ),
        ],
      ),
    );
  }
}
