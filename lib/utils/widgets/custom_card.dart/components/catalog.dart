part of '../custom_card_widget.dart';

class _Catalog extends StatelessWidget {
  final Category? category;
  const _Catalog({this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 125.w,
      height: 233.h,
      padding: EdgeInsets.all(15.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: AppColors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: AppColors.black.withOpacity(0.15),
            offset: const Offset(0.0, 0.0),
            blurRadius: 3.r,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: AppColors.lightGrey,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.r),
              child: ImageLoadingWidget(
                width: 95.w,
                height: 95.w,
                borderRadius: false,
                url: category?.imageUrlThumb ?? category?.imageUrl ?? '',
              ),
            ),
          ),
          Column(
            children: [
              PlaceholderWidget(
                width: 96.w,
                height: 17.h,
                borderRadius: false,
                condition: category != null && category!.category != null,
                child: Text(
                  category?.category ?? '',
                  maxLines: 3,
                  style: AppStyles.text.semiBold(fSize: 16.sp),
                  textAlign: TextAlign.center,
                ),
              ),
              if (category == null || category?.category == null) ...[
                height(height: 4),
                PlaceholderWidget(
                  width: 96.w,
                  height: 17.h,
                  borderRadius: false,
                ),
              ]
            ],
          ),
          PlaceholderWidget(
            width: 46.w,
            height: 46.w,
            shapeCircle: true,
            condition: category != null && category!.category != null,
            child: InkWell(
              onTap: () {
                context.navigator.pushNamed(
                  ProductsByLineageScreen.keyName,
                  arguments: {0: <Product>[], 1: category!.name, 2: category},
                );
              },
              child: Container(
                width: 46.w,
                height: 46.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
                child: Center(
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.white,
                    size: 25.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
