part of '../login_screen.dart';

class _ChooseStore extends StatelessWidget {
  const _ChooseStore();

  @override
  Widget build(BuildContext context) {
    return LayoutModalBottomSheet.basic(
      height: 258.h,
      children: [
        height(height: 20),
        Text(
          'Chọn cửa hàng truy cập',
          style: AppStyles.text.semiBold(fSize: 16.sp),
        ),
        height(height: 12),
        Divider(
          color: AppColors.grayEA,
          height: 1.h,
          thickness: 1.sp,
        ),
        height(height: 6),
        ..._data.map((map) {
          final String storeNamed = map["name_store"]!;
          final storeHost = map["host_store"]!;
          return InkWell(
            onTap: () {
              context.navigator.popAndPushNamed(HomeScreen.keyName);
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                horizontal: 40.w,
                vertical: 8.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.beige,
                    ),
                    child: Icon(
                      Icons.storefront_outlined,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  width(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        storeNamed,
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                        ),
                      ),
                      height(height: 2),
                      Text(
                        storeHost,
                        style: AppStyles.text.medium(
                          fSize: 10.sp,
                          color: AppColors.black24,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
