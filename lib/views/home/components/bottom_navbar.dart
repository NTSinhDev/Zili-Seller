part of '../home_screen.dart';

class _BottomNavbar extends StatelessWidget {
  final Function(int) onChangePage;
  final List<_TabConfig> items;
  final int currentIndex;
  const _BottomNavbar({
    required this.onChangePage,
    required this.items,
    required this.currentIndex,
  });

  double _heightByPlatform(BuildContext context) =>
      76.h + (MediaQuery.of(context).padding.bottom);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Spaces.screenWidth(context),
      height: _heightByPlatform(context),
      decoration: BoxDecoration(
        borderRadius: .vertical(top: .circular(10.r)),
        color: AppColors.white,
        boxShadow: <BoxShadow>[
          .new(
            color: AppColors.black.withValues(alpha: 0.25),
            offset: const Offset(0.0, -1.0),
            blurRadius: 4.r,
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: .spaceEvenly,
          crossAxisAlignment: .center,
          children: List.generate(
            items.length,
            (index) => _NavbarItem(
              streamingCounter: items[index].counter,
              iconRoute: items[index].iconRoute,
              isActive: currentIndex == index,
              label: items[index].label,
              onTap: () {
                if (currentIndex == index) return;
                onChangePage(index);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavbarItem extends StatelessWidget {
  final bool isActive;
  final String label;
  final String iconRoute;
  final ValueStream<int>? streamingCounter;
  final Function() onTap;
  const _NavbarItem({
    required this.isActive,
    required this.label,
    required this.onTap,
    required this.iconRoute,
    required this.streamingCounter,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: StreamBuilder<int>(
        stream: streamingCounter,
        builder: (context, asyncSnapshot) {
          final count = asyncSnapshot.data ?? 0;
          return Column(
            mainAxisAlignment: .start,
            crossAxisAlignment: .center,
            children: [
              height(height: 2),
              const Spacer(),
              Badge(
                label: count > 0
                    ? Text(
                        count < 100 ? '$count' : '99+',
                        style: AppStyles.text.medium(
                          fSize: 8.sp,
                          color: AppColors.white,
                        ),
                      )
                    : null,
                backgroundColor: AppColors.scarlet,
                isLabelVisible: count > 0,
                child: Container(
                  padding: .all(10.w),
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: isActive
                        ? AppColors.primary.withValues(alpha: 0.7)
                        : AppColors.lightGrey,
                    gradient: isActive
                        ? LinearGradient(
                            colors: [
                              AppColors.primary.withValues(alpha: 0.1),
                              AppColors.primary.withValues(alpha: 0.2),
                              AppColors.primary.withValues(alpha: 0.3),
                              AppColors.primary.withValues(alpha: 0.4),
                            ],
                          )
                        : null,
                  ),
                  child: SvgPicture.asset(
                    iconRoute,
                    width: 20.w,
                    height: 20.w,
                    colorFilter: .mode(
                      isActive ? AppColors.primary : AppColors.grey,
                      .srcIn,
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                label,
                style: isActive
                    ? AppStyles.text.semiBold(
                        fSize: 12.sp,
                        color: AppColors.primary,
                      )
                    : AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.grey,
                      ),
              ),
              const Spacer(),
            ],
          );
        },
      ),
    );
  }
}
