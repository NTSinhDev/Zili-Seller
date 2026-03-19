part of "../products_control_panel_screen.dart";

class _SliverAppBar extends StatefulWidget {
  const _SliverAppBar();

  @override
  State<_SliverAppBar> createState() => _SliverAppBarState();
}

class _SliverAppBarState extends State<_SliverAppBar> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      floating: true,
      forceElevated: true,
      backgroundColor: AppColors.white,
      toolbarHeight: 64.h,
      elevation: 3,
      expandedHeight: 0,
      title: Row(
        children: [
          Avatar(
            avatar:
                "https://www.sapo.vn/Upload/ImageManager/Image/cafe-zili%20%2810%29.jpg",
            size: 52.r,
          ),
          width(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Cửa hàng 01".toUpperCase(),
                style: AppStyles.text.semiBold(
                  fSize: 16.sp,
                  // color: AppColors.white,
                ),
              ),
              height(height: 5),
              Text(
                "Phường 7, Gò Vấp, HCM",
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.gray6A,
                ),
              ),
            ],
          ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(148.h),
        child: Container(
          width: Spaces.screenWidth(context),
          padding: EdgeInsets.symmetric(vertical: 14.h),
          child: Wrap(
            children: [
              _actionComp(
                icon: CupertinoIcons.cube_box_fill,
                label: "Sản phẩm",
                isActive: _index == 0,
                onTap: () => _onChange(0),
              ),
              _actionComp(
                icon: Icons.category,
                label: "Danh mục",
                isActive: _index == 1,
                onTap: () => _onChange(1),
              ),
              _actionComp(
                icon: CupertinoIcons.circle_grid_hex_fill,
                label: "Combo",
                isActive: _index == 2,
                onTap: () => _onChange(2),
              ),
              _actionComp(
                icon: Icons.card_giftcard_rounded,
                label: "Chương trình",
                isActive: _index == 3,
                onTap: () => _onChange(3),
              ),
              _actionComp(
                icon: Icons.newspaper_rounded,
                label: "Bài viết",
                isActive: _index == 4,
                onTap: () => _onChange(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onChange(int index) {
    setState(() {
      _index = index;
    });
  }

  Widget _actionComp({
    required String label,
    required IconData icon,
    required bool isActive,
    Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      child: SizedBox(
        width: 76.w,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : null,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                icon,
                color: isActive ? AppColors.white : AppColors.greyB3,
              ),
            ),
            height(height: 10),
            Text(
              label,
              style: AppStyles.text.bold(
                fSize: 12.sp,
                color: isActive ? AppColors.primary : AppColors.grey84,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
