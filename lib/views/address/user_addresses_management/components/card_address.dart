part of '../user_addresses_screen.dart';

class _CardAddress extends StatelessWidget {
  final CustomerAddress? address;
  final Function()? onSelect;
  const _CardAddress({this.address, this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6.r),
        child: InkWell(
          onTap: onSelect,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (address != null && address!.isDefaultAddress)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'ĐỊA CHỈ NHẬN HÀNG'.toUpperCase(),
                            style: AppStyles.text.semiBold(fSize: 14.sp),
                          ),
                          width(width: 4),
                          Container(
                            padding: EdgeInsets.all(3.w),
                            decoration: BoxDecoration(
                              border: Border.all(color: AppColors.green),
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                            child: Text(
                              'Mặc định'.toUpperCase(),
                              style: AppStyles.text.medium(
                                fSize: 8.sp,
                                color: AppColors.green,
                              ),
                            ),
                          ),
                          // Icon
                        ],
                      )
                    else
                      Text(
                        'ĐỊA CHỈ NHẬN HÀNG'.toUpperCase(),
                        style: AppStyles.text.semiBold(fSize: 14.sp),
                      ),
                    _editAdressWidget(context),
                  ],
                ),
              ),
              Divider(color: AppColors.black, height: 1.w, thickness: 1.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    PlaceholderWidget(
                      width: 86.w,
                      height: 17.h,
                      borderRadius: false,
                      condition: address != null,
                      child: Text(
                        address?.name! ?? '',
                        style: AppStyles.text.semiBold(fSize: 14.sp),
                      ),
                    ),
                    height(height: 8),
                    PlaceholderWidget(
                      width: 150.w,
                      height: 17.h,
                      borderRadius: false,
                      condition: address != null,
                      child: CustomRichTextWidget(
                        defaultStyle: AppStyles.text.semiBold(fSize: 13.sp),
                        texts: [
                          'Số điện thoại:\t\t',
                          TextSpan(
                            text: address?.phone ?? "",
                            style: AppStyles.text.medium(fSize: 13.sp),
                          )
                        ],
                      ),
                    ),
                    height(height: 8),
                    PlaceholderWidget(
                      width: 350.w,
                      height: 17.h,
                      borderRadius: false,
                      condition: address != null,
                      child: CustomRichTextWidget(
                        defaultStyle: AppStyles.text.semiBold(fSize: 13.sp),
                        texts: [
                          'Địa chỉ:\t\t',
                          TextSpan(
                            text: address?.address(),
                            style: AppStyles.text.medium(
                              fSize: 13.sp,
                              height: 1.1,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _editAdressWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        context.navigator.push(MaterialPageRoute(
          builder: (context) => AddAddressScreen(
            address: address,
            title: "Chỉnh sửa địa chỉ nhận hàng",
          ),
        ));
      },
      child: Container(
        padding: EdgeInsets.all(4.r),
        child: Row(
          children: [
            Text(
              'Thay đổi',
              style: AppStyles.text.semiBold(
                fSize: 12.sp,
                color: AppColors.primary,
              ),
            ),
            width(width: 4),
            Icon(
              CupertinoIcons.chevron_forward,
              size: 12.sp,
              color: AppColors.primary,
            )
          ],
        ),
      ),
    );
  }
}
