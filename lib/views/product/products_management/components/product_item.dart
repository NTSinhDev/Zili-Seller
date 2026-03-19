part of "../products_management_screen.dart";

class _ProductItem extends StatefulWidget {
  final bool loading;
  final Function()? onLongPress;
  final Function()? onTap;
  const _ProductItem({this.onTap, this.onLongPress, this.loading = false});

  @override
  State<_ProductItem> createState() => _ProductItemState();
}

class _ProductItemState extends State<_ProductItem> {
  bool isSelected = false;
  final ProductRepository productRepository = di<ProductRepository>();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSelected
          ? () {
              setState(() {
                isSelected = !isSelected;
              });
            }
          : widget.onTap,
      onLongPress: () {
        setState(() {
          isSelected = !isSelected;
        });
        productRepository.actionType.sink.add(isSelected);
      },
      child: Row(
        children: [
          width(width: 20),
          if (isSelected) ...[
            width(width: 10),
            const Icon(Icons.check_box_outlined, color: AppColors.primary),
            width(width: 10),
          ],
          Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 8.h),
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: AppColors.black.withOpacity(0.15),
                    offset: const Offset(0, 1),
                    blurRadius: 4.r,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80.w,
                        height: 80.w,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: ImageLoadingWidget(
                            width: 80.w,
                            height: 80.w,
                            borderRadius: false,
                            url: widget.loading
                                ? 'https://media.zili.vn/files/images/9725b435-1359-4675-8c3a-033e964edc05/ROBUSTA HONEY- COASTER_.webp'
                                : "",
                          ),
                        ),
                      ),
                      width(width: 15),
                      Expanded(
                        child: height(
                          height: 80.w,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              PlaceholderWidget(
                                width: 200.w,
                                height: 13.h,
                                borderRadius: false,
                                condition: widget.loading,
                                child: Text(
                                  "Cà phê đen truyền thống",
                                  style: AppStyles.text.semiBold(
                                    fSize: 17.5.sp,
                                  ),
                                ),
                              ),
                              PlaceholderWidget(
                                width: 200.w,
                                height: 13.h,
                                borderRadius: false,
                                condition: widget.loading,
                                child: Row(
                                  children: [
                                    Text(
                                      "1000112345",
                                      style: AppStyles.text.medium(
                                        fSize: 14.sp,
                                        color: AppColors.gray7,
                                      ),
                                    ),
                                    width(width: 10),
                                    Text(
                                      "#Caffee",
                                      style: AppStyles.text.semiBold(
                                        fSize: 14.sp,
                                        color: AppColors.gray7,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PlaceholderWidget(
                                width: 200.w,
                                height: 13.h,
                                borderRadius: false,
                                condition: widget.loading,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const RatingBarWidget(
                                      value: 4.5,
                                      size: 12,
                                      spacing: 3,
                                    ),
                                    width(width: 4),
                                    Text(
                                      "4.5/5",
                                      style: AppStyles.text.semiBold(
                                        fSize: 13.5.sp,
                                        color: AppColors.grey,
                                      ),
                                    ),
                                    width(width: 5),
                                    Text(
                                      "(18)",
                                      style: AppStyles.text.semiBold(
                                        fSize: 13.5.sp,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              height(height: 1),
                              PlaceholderWidget(
                                width: 120.w,
                                height: 18.h,
                                borderRadius: false,
                                condition: widget.loading,
                                child: Text(
                                  356000.toPrice(),
                                  style: AppStyles.text.semiBold(fSize: 15.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!isSelected) width(width: 20),
        ],
      ),
    );
  }
}
