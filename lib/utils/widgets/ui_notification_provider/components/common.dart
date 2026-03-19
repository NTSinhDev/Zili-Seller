part of '../ui_notification_provider.dart';

class _Common extends StatelessWidget {
  final Widget child;
  const _Common({required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _Background(top: -24.h, left: -24.w, size: 136.w, opacity: 0.04),
        _Background(top: 4.h, left: 124.w, size: 32.w, opacity: 0.05),
        _Background(top: 1.h, left: 108.w, size: 16.w, opacity: 0.05),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          color: Colors.transparent,
          child: child,
        ),
        Positioned(
          top: 0,
          right: 0,
          child: InkWell(
            onTap: () => context.navigator.pop(),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Icon(
                Icons.close_rounded,
                color: AppColors.black3,
                size: 20.sp,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
