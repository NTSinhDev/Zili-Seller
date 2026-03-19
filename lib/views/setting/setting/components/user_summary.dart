part of '../setting_screen.dart';

class _UserSummary extends StatelessWidget {
  final User? user;
  const _UserSummary({this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.lightFA,
      padding: .all(20.w),
      width: Spaces.screenWidth(context),
      child: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .center,
              children: [
                UserAvatar(avatarURL: user?.avatar),
                if (user != null) ...[
                  height(height: 12),
                  RowWidget(
                    gap: 8.w,
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        user!.name,
                        maxLines: 1,
                        overflow: .ellipsis,
                        style: AppStyles.text.bold(fSize: 16.sp),
                      ),
                      StatusBadge(
                        label: renderUserStatus(user!.status) ?? "",
                        color:
                            colorUserStatus(user!.status) ?? AppColors.lightF,
                      ),
                    ],
                  ),
                  height(height: 24),
                  RowWidget(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .center,
                    gap: 20.w,
                    children: [
                      if (user!.email != null) ...[
                        Expanded(
                          child: RowWidget(
                            gap: 4.w,
                            children: [
                              SvgPicture.asset(
                                AssetIcons.iMailSvg,
                                width: 20.w,
                                height: 20.w,
                              ),
                              Expanded(
                                child: Text(
                                  user!.email ?? '',
                                  maxLines: 1,
                                  overflow: .ellipsis,
                                  style: AppStyles.text.medium(fSize: 14.sp),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (user!.phone != null) ...[
                        RowWidget(
                          gap: 4.w,
                          children: [
                            SvgPicture.asset(
                              AssetIcons.iPhoneSvg,
                              width: 20.w,
                              height: 20.w,
                              colorFilter: const .mode(
                                AppColors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                            Text(
                              user!.phone!.toNumberPhone,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: AppStyles.text.medium(fSize: 14.sp),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                  // ..._userBaseInfo(context),
                ] else
                  ..._NotAuthenView.view(context),
              ],
            ),
            if (user != null)
              Positioned(
                top: 0,
                right: 0,
                child: InkWell(
                  onTap: () {
                    // if (user == null) return;
                    // context.navigator.pushNamed(
                    //   ChangeInformationScreen.keyName,
                    //   arguments: user,
                    // );
                  },
                  child: SvgPicture.asset(
                    AssetIcons.iEditSvg,
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Widget> _userBaseInfo(BuildContext context) {
    List<Widget> widgets = [];
    if (user!.email != null) {
      final emailInfoWidget = RowWidget(
        gap: 4.w,
        children: [
          SvgPicture.asset(AssetIcons.iMailSvg, width: 20.w, height: 20.w),
          Expanded(
            child: Text(
              user!.email ?? '',
              maxLines: 1,
              overflow: .ellipsis,
              style: AppStyles.text.medium(fSize: 14.sp),
            ),
          ),
        ],
      );
      widgets.add(emailInfoWidget);
    }

    if (user!.phone != null) {
      final phoneInfoWidget = RowWidget(
        gap: 4.w,
        children: [
          SvgPicture.asset(
            AssetIcons.iPhoneSvg,
            width: 20.w,
            height: 20.w,
            colorFilter: const .mode(AppColors.black, BlendMode.srcIn),
          ),
          Expanded(
            child: Text(
              user!.phone!.toNumberPhone,
              maxLines: 1,
              overflow: .ellipsis,
              style: AppStyles.text.medium(fSize: 14.sp),
            ),
          ),
        ],
      );
      widgets.add(phoneInfoWidget);
    }
    if (user!.username != null) {
      final usernameInfoWidget = RowWidget(
        gap: 4.w,
        children: [
          SvgPicture.asset(
            AssetIcons.iUserSvg,
            width: 20.w,
            height: 20.w,
            colorFilter: const .mode(AppColors.black, BlendMode.srcIn),
          ),
          Expanded(
            child: Text(
              user!.username ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
              maxLines: 1,
              overflow: .ellipsis,
              style: AppStyles.text.medium(fSize: 14.sp),
            ),
          ),
        ],
      );
      widgets.add(usernameInfoWidget);
    }

    return widgets;
  }
}

class _NotAuthenView {
  static List<Widget> view(BuildContext context) {
    Widget roundedBtn(String title) {
      return CustomButtonWidget(
        onTap: () {
          // if (title == 'Đăng nhập') {
          //   context.navigator.pushNamed(
          //     LoginScreen.keyName,
          //     arguments: NavArgsKey.fromHome,
          //   );
          // } else {
          //   context.navigator.pushNamed(
          //     RegisterScreen.keyName,
          //     arguments: NavArgsKey.fromHome,
          //   );
          // }
        },
        width: 120.w,
        height: 42.h,
        radius: 8.r,
        borderColor: title != 'Đăng nhập' ? AppColors.primary : null,
        color: title != 'Đăng nhập' ? AppColors.white : null,
        boxShadows: const [],
        child: Center(
          child: Text(
            title,
            style: AppStyles.text.semiBold(
              fSize: 14.sp,
              color: title == 'Đăng nhập' ? AppColors.white : AppColors.primary,
            ),
          ),
        ),
      );
    }

    return [
      height(height: 10),
      Text(
        'Hãy sử dụng một tài khoản để có trải nghiệm tốt hơn!',
        style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.primary),
      ),
      height(height: 10),
      Row(
        mainAxisAlignment: .center,
        crossAxisAlignment: .center,
        children: [
          roundedBtn('Đăng nhập'),
          width(width: 16),
          roundedBtn('Đăng ký'),
        ],
      ),
    ];
  }
}
