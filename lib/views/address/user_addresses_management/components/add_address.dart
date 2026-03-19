part of '../user_addresses_screen.dart';

class _AddAddress extends StatelessWidget {
  const _AddAddress();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Spaces.screenWidth(context),
      height: 60.h,
      margin: EdgeInsets.only(top: 10.h),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.black),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: InkWell(
        onTap: () => context.navigator.pushNamed(AddAddressScreen.keyName),
        splashColor: AppColors.primary.withOpacity(0.3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              Icons.add_rounded,
              color: AppColors.primary,
              size: 18.sp,
            ),
            width(width: 6.w),
            Text(
              'Thêm địa chỉ nhận hàng',
              style: AppStyles.text.semiBold(
                fSize: 13.sp,
                color: AppColors.primary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
