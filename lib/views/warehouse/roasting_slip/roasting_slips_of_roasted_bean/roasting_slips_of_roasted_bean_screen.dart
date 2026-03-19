import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/warehouse/warehouse_cubit.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../data/models/warehouse/roasting_slip.dart';
import '../../../../data/repositories/warehouse_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/empty_view_state.dart';
import '../roasting_slip_detail/roasting_slip_detail_screen.dart';

part 'components/roasted_bean_card.dart';
part 'components/slip_view.dart';

class RoastingSlipsOfRoastedBeanScreen extends StatefulWidget {
  static const routeName = '/roasting-slips-of-roasted-bean';

  final ProductVariant roastedBean;
  const RoastingSlipsOfRoastedBeanScreen({
    super.key,
    required this.roastedBean,
  });

  @override
  State<RoastingSlipsOfRoastedBeanScreen> createState() =>
      _RoastingSlipsOfRoastedBeanScreenState();
}

class _RoastingSlipsOfRoastedBeanScreenState
    extends State<RoastingSlipsOfRoastedBeanScreen> {
  final WarehouseCubit _cubit = di<WarehouseCubit>();
  final WarehouseRepository _repo = di<WarehouseRepository>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _cubit.getRoastingSlipsOfRoastedBean(widget.roastedBean.id);
  }

  @override
  void dispose() {
    _repo.clearRoastingSlipsOfRoastedBean();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Danh sách phiếu rang',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      body: StreamBuilder<List<RoastingSlip>>(
        stream: _repo.roastingSlipsOfRoastedBeanStream,
        builder: (context, snapshot) {
          final slips = snapshot.data ?? [];
          final total = _repo.totalRoastingSlipsOfRoastedBean;
          return CommonLoadMoreRefreshWrapper.refresh(
            context,
            onRefresh: _fetchData,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: .symmetric(vertical: 16.h),
              child: ColumnWidget(
                gap: 16.h,
                children: [
                  _RoastedBeanCard(roastedBean: widget.roastedBean),
                  ColumnWidget(
                    backgroundColor: Colors.white,
                    children: [
                      if (slips.isNotEmpty)
                        Container(
                          padding: .symmetric(horizontal: 16.w, vertical: 12.h),
                          color: AppColors.background,
                          child: Align(
                            alignment: .centerLeft,
                            child: Text(
                              '$total phiên bản hạt rang',
                              style: AppStyles.text.medium(
                                fSize: 14.sp,
                                color: AppColors.grey84,
                              ),
                            ),
                          ),
                        ),
                      ColumnWidget(
                        crossAxisAlignment: .start,
                        gap: 12.h,
                        padding: .symmetric(horizontal: 16.w, vertical: 12.h),
                        children: [
                          Text(
                            'Danh sách phiếu',
                            style: AppStyles.text.semiBold(
                              fSize: 14.sp,
                              color: AppColors.black3,
                            ),
                          ),
                          if (slips.isEmpty)
                            const EmptyViewState(message: 'Chưa có phiếu rang')
                          else
                            ...slips.map((slip) => _SlipView(slip)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
