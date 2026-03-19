import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../data/models/warehouse/packing_slip.dart';
import '../../data/models/warehouse/slip_entity.dart';
import '../../res/res.dart';
import '../../utils/widgets/widgets.dart';

class SlipCard extends StatelessWidget {
  final SlipEntity slip;
  final Function()? onTap;
  const SlipCard({super.key, required this.slip, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: .symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: slip.cardColor?.withValues(alpha: 0.1),
          border: (slip.cardColor).isNotNull
              ? .all(color: slip.cardColor!)
              : null,
          borderRadius: .circular(10.r),
        ),
        padding: .all(10.w),
        child: ColumnWidget(
          gap: 8.h,
          children: [
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        slip.code,
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.black3,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Container(
                        padding: .symmetric(horizontal: 12.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: slip.statusLabelColor?.withValues(alpha: 0.1),
                          borderRadius: .circular(999),
                        ),
                        child: Text(
                          slip.statusLabel ??
                              AppConstant.strings.DEFAULT_EMPTY_VALUE,
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: slip.statusLabelColor ?? AppColors.black3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (slip is PackingSlip)
                  if ((slip as PackingSlip).totalProcessingSlip > 0)
                    Text(
                      "(${(slip as PackingSlip).totalProcessingSlip})",
                      style: AppStyles.text.semiBold(
                        fSize: 12.sp,
                        color: AppColors.black5,
                      ),
                    ),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: AppColors.black3,
                  size: 20.w,
                ),
              ],
            ),
            Divider(height: 1, color: AppColors.black.withValues(alpha: 0.2)),
            ...slip.infoRows?.map(
                  (e) => _InfoRow(label: e.key, value: e.value),
                ) ??
                [],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          label,
          style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.grey84),
        ),
        Text(
          value,
          style: AppStyles.text.medium(fSize: 12.sp, color: AppColors.black3),
        ),
      ],
    );
  }
}
