part of '../change_password_screen.dart';

class _ScreenScaffold extends StatelessWidget {
  final CustomerCubit customerCubit;
  final void Function(BuildContext, CustomerState) listener;
  final List<Widget> children;
  final Function() onSubmitNewPassword;
  const _ScreenScaffold({
    required this.customerCubit,
    required this.listener,
    required this.children,
    required this.onSubmitNewPassword,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerCubit, CustomerState>(
      bloc: customerCubit,
      listener: listener,
      child: Scaffold(
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Thay đổi mật khẩu',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
        ),
        backgroundColor: AppColors.white,
        body: Stack(
          children: [
            // Positioned(
            //   top: 45,
            //   left: 0,
            //   child: SvgPicture.asset(
            //     AssetIcons.bgEditUserInformationScreenSvg,
            //   ),
            // ),
            GestureDetector(
              onTap: context.focus.unfocus,
              child: SizedBox(
                width: Spaces.screenWidth(context),
                height: Spaces.screenHeight(context),
                child: SingleChildScrollView(
                  padding: .symmetric(horizontal: 20.w),
                  child: ColumnWidget(
                    mainAxisAlignment: .start,
                    crossAxisAlignment: .center,
                    padding: .only(top: 40.h),
                    children: children,
                  ),
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomScaffoldButton(
          onTap: onSubmitNewPassword,
          label: "Cập nhật mật khẩu",
        ),
      ),
    );
  }
}
