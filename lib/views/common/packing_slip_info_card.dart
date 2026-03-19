import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../data/models/warehouse/packing_slip_item.dart';
import '../../res/res.dart';
import '../../utils/widgets/widgets.dart';

class PackingSlipInfoCard extends StatefulWidget {
  final PackingSlipDetailItem packingSlip;
  const PackingSlipInfoCard({super.key, required this.packingSlip});

  @override
  State<PackingSlipInfoCard> createState() => _PackingSlipInfoCardState();
}

class _PackingSlipInfoCardState extends State<PackingSlipInfoCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w).copyWith(bottom: 8.w),
      decoration: BoxDecoration(
        color: AppColors.lightGrey,
        borderRadius: .circular(12.r),
      ),
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 12.h,
        children: [
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Mã phiếu đóng gói:',
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black3,
                ),
              ),
              Text(
                widget.packingSlip.code,
                style: AppStyles.text.bold(
                  fSize: 14.sp,
                  color: AppColors.black3,
                ),
              ),
            ],
          ),
          Divider(height: 2.h, color: AppColors.green, thickness: 1.sp),
          ColumnWidget(
            gap: 8.h,
            children: [
              _InfoRow(
                label: 'Số lượng:',
                value: widget.packingSlip.quantity.toString(),
              ),
              _InfoRow(
                label: 'Khối lượng đóng gói:',
                value: '${widget.packingSlip.totalWeight.toUSD} (kg)',
              ),
              _InfoRow(
                label: 'Thời gian tạo:',
                value:
                    DateTime.tryParse(
                      widget.packingSlip.createdAt,
                    )?.formatWithTimezone() ??
                    AppConstant.strings.DEFAULT_EMPTY_VALUE,
              ),
            ],
          ),
          SizedBox(
            width: .infinity,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: _isExpanded
                  ? ColumnWidget(
                      gap: 8.h,
                      crossAxisAlignment: .start,
                      children: [
                        Divider(
                          height: 2.h,
                          color: AppColors.green,
                          thickness: 1.sp,
                        ),
                        Text(
                          'Nguyên liệu:',
                          style: AppStyles.text.medium(
                            fSize: 14.sp,
                            color: AppColors.black3,
                          ),
                        ),
                        ...widget.packingSlip.itemMixes.map(
                          (item) => _buildItemMix(item),
                        ),
                        const SizedBox.shrink(),
                        Text(
                          'Bao bì:',
                          style: AppStyles.text.medium(
                            fSize: 14.sp,
                            color: AppColors.black3,
                          ),
                        ),
                        ...widget.packingSlip.itemPackaging.map(
                          (item) => _buildItemPackaging(item),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ),
          // Nút expand/collapse
          Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: .circular(8.r),
                child: Padding(
                  padding: .symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Row(
                    mainAxisSize: .min,
                    children: [
                      Text(
                        _isExpanded ? 'Thu gọn' : 'Xem nguyên liệu & bao bì',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                      width(width: 4),
                      AnimatedRotation(
                        turns: _isExpanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemMix(PackingSlipItemMix item) {
    return Container(
      width: .infinity,
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.green.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: .circular(8.r),
      ),
      child: RowWidget(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: ColumnWidget(
              crossAxisAlignment: .start,
              gap: 8.h,
              children: [
                Text(
                  item.productNameVi?.trim() ??
                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                if (item.options.isNotEmpty)
                  Text(
                    item.options.map((e) => e.value).join(' - '),
                    style: AppStyles.text.medium(
                      fSize: 10.sp,
                      color: AppColors.grey84,
                    ),
                  ),
              ],
            ),
          ),
          ColumnWidget(
            crossAxisAlignment: .end,
            gap: 8.h,
            children: [
              Text(
                item.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Khối lượng: ${item.totalWeight.toUSD} ${(item.measureUnit ?? "").isNotEmpty ? '(${item.measureUnit})' : ''}',
                style: AppStyles.text.medium(fSize: 12.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildItemPackaging(PackingSlipItemPackaging item) {
    return Container(
      width: .infinity,
      padding: .all(12.w),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        border: Border.all(
          color: AppColors.green.withValues(alpha: 0.3),
          width: 1,
        ),
        borderRadius: .circular(8.r),
      ),
      child: RowWidget(
        crossAxisAlignment: .start,
        children: [
          Expanded(
            child: ColumnWidget(
              crossAxisAlignment: .start,
              gap: 8.h,
              children: [
                Text(
                  item.productNameVi?.trim() ??
                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: AppColors.black5,
                  ),
                  maxLines: 1,
                  overflow: .ellipsis,
                ),
                if (item.options.isNotEmpty)
                  Text(
                    item.options.map((e) => e.value).join(' - '),
                    style: AppStyles.text.medium(
                      fSize: 10.sp,
                      color: AppColors.grey84,
                    ),
                  ),
              ],
            ),
          ),
          ColumnWidget(
            crossAxisAlignment: .end,
            gap: 8.h,
            children: [
              Text(
                item.sku ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.primary,
                ),
              ),
              Text(
                'Số lượng: ${item.totalQuantity.removeTrailingZero.toString()} ${(item.measureUnit ?? "").isNotEmpty ? '(${item.measureUnit})' : ''}',
                style: AppStyles.text.medium(fSize: 12.sp),
              ),
            ],
          ),
        ],
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
