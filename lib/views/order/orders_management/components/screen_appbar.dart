part of '../orders_management_screen.dart';

class _ScreenSliverAppbar extends StatelessWidget {
  final bool hideShadowSearchBar;
  final TextEditingController searchController;
  const _ScreenSliverAppbar({
    this.hideShadowSearchBar = false,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    final expandedHeight = 180.h;
    final appbarHeight = 40.h;
    const backgroundColor = AppColors.white;
    const foregroundColor = AppColors.black;

    return SliverAppBar(
      pinned: true,
      backgroundColor: backgroundColor,
      expandedHeight: expandedHeight,
      toolbarHeight: appbarHeight,
      elevation: 3,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: EdgeInsets.only(bottom: 88.h),
        title: Text(
          "Đơn hàng".toUpperCase(),
          style: AppStyles.text.bold(fSize: 18.sp, color: foregroundColor),
        ),
        centerTitle: true,
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(104.h),
        child: _SearchBar(
          hideShadow: hideShadowSearchBar,
          controller: searchController,
        ),
      ),
      actions: [
        _appbarButton(
          icon: Icons.history,
          onTap: () => context.navigator.pushNamed(OrdersHistoryScreen.keyName),
          icColor: foregroundColor,
        ),
        // width(width: 20),
        // _appbarButton(
        //   icon: Icons.qr_code_scanner_rounded,
        //   onTap: () => context.navigator.pushNamed(QRCodeScannerScreen.keyName),
        //   icColor: foregroundColor,
        // ),
        width(width: 20),
      ],
    );
  }

  Widget _appbarButton({IconData? icon, Function()? onTap, Color? icColor}) =>
      IconButton(
        onPressed: onTap,
        icon: Icon(icon),
        splashRadius: 24.r,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(minWidth: 28, maxWidth: 56),
        color: icColor,
      );
}
