import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

import '../../../data/repositories/warehouse_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/widgets/widgets.dart';
import '../brands/export.dart';
import '../green_beans/green_beans_screen.dart';
import '../roasted_beans/roasted_beans_screen.dart';

class WarehouseEntryItem {
  final String title;
  final String description;
  final VoidCallback onTap;
  final ValueStream<int>? streamCounter;
  const WarehouseEntryItem({
    required this.title,
    required this.description,
    required this.onTap,
    this.streamCounter,
  });
}

class WarehouseEntryScreen extends StatelessWidget {
  const WarehouseEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColumnWidget(
        backgroundColor: Colors.white,
        padding: .symmetric(horizontal: 20.w, vertical: 20.h),
        gap: 20.w,
        children: <WarehouseEntryItem>[
          .new(
            title: 'Nhân xanh',
            description: 'Kho sản phẩm dành cho nhân xanh',
            onTap: () =>
                context.navigator.pushNamed(GreenBeansScreen.routeName),
            streamCounter:
                di<WarehouseRepository>().newRoastingSlipsCounter.stream,
          ),
          .new(
            title: 'Hạt rang',
            description: 'Kho sản phẩm cho hạt rang',
            onTap: () =>
                context.navigator.pushNamed(RoastedBeansScreen.routeName),
          ),
          .new(
            title: 'Thương hiệu',
            description: 'Kho sản phẩm cho thương hiệu',
            onTap: () => context.navigator.pushNamed(BrandsScreen.routeName),
            streamCounter:
                di<WarehouseRepository>().newPackingSlipsCounter.stream,
          ),
        ].map((item) => _WarehouseEntryCard(item)).toList(),
      ),
    );
  }
}

class _WarehouseEntryCard extends StatelessWidget {
  final WarehouseEntryItem data;
  const _WarehouseEntryCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: .circular(10.r),
        onTap: data.onTap,
        child: Container(
          width: .infinity,
          padding: .symmetric(horizontal: 10.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: AppColors.lightGrey,
            borderRadius: .circular(10.r),
            border: .all(color: AppColors.grayEA),
          ),
          child: Row(
            crossAxisAlignment: .center,
            children: [
              Expanded(
                child: ColumnWidget(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  gap: 6.h,
                  children: [
                    Text(
                      data.title,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: .w700,
                        height: 20 / 14,
                        letterSpacing: 0.25,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      data.description,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: .w400,
                        height: 16 / 12,
                        letterSpacing: 0.4,
                        color: AppColors.black3.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              if (data.streamCounter != null)
                StreamBuilder<int>(
                  stream: data.streamCounter,
                  builder: (context, asyncSnapshot) {
                    final count = asyncSnapshot.data ?? 0;
                    if (count == 0) return const SizedBox.shrink();
                    return Container(
                      padding: .all(4.w),
                      decoration: BoxDecoration(
                        borderRadius: .circular(100),
                        color: AppColors.scarlet,
                      ),
                      child: Text(
                        count < 100 ? '$count' : '99+',
                        style: AppStyles.text.medium(
                          fSize: 10.sp,
                          color: AppColors.white,
                        ),
                      ),
                    );
                  },
                ),
              SizedBox(width: 12.w),
              Transform.rotate(
                angle: -1.5708, // 270deg
                child: Icon(
                  Icons.keyboard_arrow_down,
                  size: 20.w,
                  color: AppColors.black3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
