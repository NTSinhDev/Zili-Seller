import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/warehouse/warehouse.dart';
import '../../../../data/repositories/warehouse_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../services/common_service.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/order_function.dart';
import '../../../../utils/widgets/widgets.dart';

part 'components/branches_selection.dart';

class BranchSection extends StatefulWidget {
  final Warehouse? branch;
  final Function(Warehouse) onChange;
  const BranchSection({
    super.key,
    required this.branch,
    required this.onChange,
  });

  @override
  State<BranchSection> createState() => _BranchSectionState();
}

class _BranchSectionState extends State<BranchSection> {
  final CommonService _commonService = di<CommonService>();
  late bool _alreadyInit;

  @override
  void initState() {
    super.initState();
    if (widget.branch.isNull) {
      _alreadyInit = false;
      _initByDefaultBranch();
    } else {
      _alreadyInit = true;
    }
  }

  void _initByDefaultBranch() {
    _commonService.loadWarehousesDataV2().then((warehouses) {
      final defaultWarehouse = warehouses.valueBy(
        (warehouse) => warehouse.isDefault == true,
      );
      if (defaultWarehouse != null) {
        widget.onChange(defaultWarehouse);
      } else {
        if (warehouses.firstOrNull.isNotNull) {
          widget.onChange(warehouses.firstOrNull!);
        }
      }

      if (mounted) {
        setState(() {
          _alreadyInit = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16.w),
      color: AppColors.white,
      child: InkWell(
        onTap: () {
          BranchSelector.openBranchesSelection(
            context,
            crSelected: widget.branch,
            onChange: widget.onChange,
          );
        },
        child: RowWidget(
          mainAxisAlignment: .spaceBetween,
          children: [
            RowWidget(
              gap: 12.w,
              children: [
                Container(
                  padding: .all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: .circular(8.r),
                  ),
                  child: Icon(
                    Icons.store_outlined,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
                ColumnWidget(
                  crossAxisAlignment: .start,
                  gap: 4.h,
                  children: [
                    Text(
                      'Chi nhánh bán',
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                    PlaceholderOptionsWidget(
                      width: 0.5.sw,
                      options: PlaceholderOptions.text16,
                      condition: widget.branch?.name != null || _alreadyInit,
                      child: Text(
                        widget.branch?.name ?? 'Chưa chọn chi nhánh',
                        style: AppStyles.text.semiBold(
                          fSize: 16.sp,
                          color: AppColors.black3,
                          height: 18 / 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: AppColors.grey84, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
