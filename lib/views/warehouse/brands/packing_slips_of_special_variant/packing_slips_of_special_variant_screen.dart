import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../bloc/warehouse/warehouse_cubit.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../data/models/warehouse/packing_slip_item.dart';
import '../../../../data/repositories/warehouse_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/empty_view_state.dart';
import '../../../common/packing_slip_info_card.dart';
import '../../../common/shimmer_view.dart';

part 'components/special_variant_card.dart';

class PackingSlipsOfSpecialVariantScreen extends StatefulWidget {
  static const routeName = '/packing-slips-of-special-variant';
  final ProductVariant specialVariant;
  const PackingSlipsOfSpecialVariantScreen({
    super.key,
    required this.specialVariant,
  });

  @override
  State<PackingSlipsOfSpecialVariantScreen> createState() =>
      _PackingSlipsOfSpecialVariantScreenState();
}

class _PackingSlipsOfSpecialVariantScreenState
    extends State<PackingSlipsOfSpecialVariantScreen> {
  final WarehouseCubit _cubit = di<WarehouseCubit>();
  final WarehouseRepository _repo = di<WarehouseRepository>();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    await _cubit.getPackingSlipsByCode(itemCode: widget.specialVariant.id);
  }

  @override
  void dispose() {
    _repo.packingSlipsOfSpecialVariant =
        BehaviorSubject<List<PackingSlipDetailItem>>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Danh sách phiếu đóng gói',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      body: CommonLoadMoreRefreshWrapper.refresh(
        context,
        onRefresh: _fetchData,
        child: SingleChildScrollView(
          padding: .symmetric(vertical: 16.h),
          child: ColumnWidget(
            gap: 16.h,
            children: [
              _SpecialVariantCard(specialVariant: widget.specialVariant),
              ColumnWidget(
                crossAxisAlignment: .start,
                backgroundColor: Colors.white,
                gap: 12.h,
                padding: .symmetric(horizontal: 16.w, vertical: 12.h),
                children: [
                  Text(
                    'Danh sách phiếu đóng gói',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                  StreamBuilder<List<PackingSlipDetailItem>>(
                    stream: _repo.packingSlipsOfSpecialVariant.stream,
                    builder: (context, snapshot) {
                      final slips = snapshot.data ?? [];

                      if (snapshot.connectionState == .waiting) {
                        return const ShimmerView(type: .normal);
                      }

                      if (slips.isEmpty) {
                        return const EmptyViewState(
                          message: 'Không tìm thấy phiếu đóng gói',
                        );
                      }

                      return Column(
                        mainAxisSize: .min,
                        children: slips
                            .map(
                              (slip) => Padding(
                                padding: .only(bottom: 12.h),
                                child: PackingSlipInfoCard(packingSlip: slip),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
