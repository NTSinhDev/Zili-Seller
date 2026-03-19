part of '../setting_screen.dart';

class _SettingFeatures extends StatelessWidget {
  final User? user;
  final AppCubit cubit;
  const _SettingFeatures({this.user, required this.cubit});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _featureItem(
          context: context,
          icon: AssetIcons.iUserSvg,
          label: 'Thông tin tài khoản',
          onTap: () {
            context.navigator.pushNamed(AccountInformationScreen.keyName);
          },
        ),
        Divider(height: 1.h, thickness: 1.5, color: AppColors.lightGrey),
        _featureItem(
          context: context,
          icon: AssetIcons.iLockSvg,
          label: 'Thay đổi mật khẩu',
          onTap: () {
            if (user == null) {
              context.showNotificationDialog(
                message: "Vui lòng đăng nhập để sử dụng!",
                cancelWidget: Container(),
                action: "Đóng",
              );
              return;
            }
            context.navigator.pushNamed(ChangePasswordScreen.keyName);
          },
        ),
        Divider(height: 1.h, thickness: 1.5, color: AppColors.lightGrey),
        _featureItem(
          context: context,
          icon: AssetIcons.iShieldLockSvg,
          label: 'Cập nhật mã pin',
        ),
        Divider(height: 1.h, thickness: 1.5, color: AppColors.lightGrey),
        _featureItem(
          context: context,
          icon: AssetIcons.i2faSvg,
          label: 'Xác thực 2 yếu tố',
        ),
        Divider(height: 1.h, thickness: 1.5, color: AppColors.lightGrey),
        _featureItem(
          context: context,
          icon: AssetIcons.iPrintSvg,
          label: 'In tài liệu',
          onTap: () {
            di<SettingCubit>().getPrinters();
            PrintersBottomSheet().showPrintersBottomSheet(context);
          },
        ),
        Divider(height: 1.h, thickness: 1.5, color: AppColors.lightGrey),
        // _featureItem(
        //   onTap: () async {
        // if (user == null) {
        //   context.showNotificationDialog(
        //     message: "Vui lòng đăng nhập để sử dụng!",
        //     cancelWidget: Container(),
        //     action: "Đóng",
        //   );
        //   return;
        // }
        // final messageFuture = di<AuthCubit>().deleteAccount();
        // final messageStream = Stream.fromFuture(messageFuture);
        // messageStream.listen(
        //   (MessageNotification message) async {
        //     if (message.type == MessageNotificationType.success) {
        //       await cubit.logout();
        //     } else if (message.type == MessageNotificationType.info) {
        //       context.showNotificationDialog(
        //         message: message.message,
        //         cancelWidget: Container(),
        //         ontap: () async {
        //           await cubit.logout();
        //         },
        //         action: "Đóng",
        //       );
        //     } else if (message.type == MessageNotificationType.warning) {
        //       context.showNotificationDialog(
        //         message: message.message,
        //         cancelWidget: Container(),
        //         action: "Đóng",
        //       );
        //     } else {
        //       context.showNotificationDialog(
        //         title: "Lỗi",
        //         themeColor: AppColors.scarlet,
        //         message: message.message,
        //         cancelWidget: Container(),
        //         action: "Đóng",
        //       );
        //     }
        //   },
        //   onError: (e) {
        //     context.showNotificationDialog(
        //       title: "Lỗi",
        //       themeColor: AppColors.scarlet,
        //       message: "Lỗi xảy ra trong quá trình thực hiện tác vụ!",
        //       cancelWidget: Container(),
        //       action: "Đóng",
        //     );
        //   },
        // );
        //   },
        //   context: context,
        //   icon: AppConstant.svgs.icRemoveCircle,
        //   label: 'Xóa tài khoản',
        // ),
        Divider(height: 1.h, thickness: 1.5, color: AppColors.lightGrey),
        _featureItem(
          context: context,
          icon: AppConstant.svgs.icLogOut,
          label: 'Đăng xuất',
          onTap: () async {
            if (user == null) {
              context.showNotificationDialog(
                message: "Vui lòng đăng nhập để sử dụng!",
                cancelWidget: Container(),
                action: "Đóng",
              );
              return;
            }

            di<AuthCubit>().logout().then((isLogoutOnServer) {
              if (isLogoutOnServer) {
                cubit.logout();
                AppWireFrame.logout();
              }
            });
          },
        ),
      ],
    );
  }

  Widget _featureItem({
    required String icon,
    required String label,
    Function()? onTap,
    required BuildContext context,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: Spaces.screenWidth(context),
        padding: .all(20.w),
        color: Colors.white.withValues(alpha: 0.01),
        child: RowWidget(
          gap: 10.w,
          children: [
            SvgPicture.asset(
              icon,
              width: 24.w,
              height: 24.w,
              colorFilter: const .mode(AppColors.black, .srcIn),
            ),
            Expanded(
              child: Text(label, style: AppStyles.text.semiBold(fSize: 16.sp)),
            ),
            CustomIconStyle(
              icon: CupertinoIcons.chevron_right,
              style: AppStyles.text.semiBold(fSize: 16.sp),
              align: .right,
            ),
          ],
        ),
      ),
    );
  }
}
