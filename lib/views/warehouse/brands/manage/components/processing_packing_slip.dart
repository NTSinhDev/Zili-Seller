part of '../brands_screen.dart';

class _ProcessingPackingSlipView extends StatelessWidget {
  final int index;
  const _ProcessingPackingSlipView(this.index);

  static const PackingSlipStatus status = PackingSlipStatus.processing;

  @override
  Widget build(BuildContext context) {
    final warehouseRepository = di<WarehouseRepository>();
    return Offstage(
      offstage: index != status.index,
      child: StreamBuilder<List<PackingSlip>>(
        stream: warehouseRepository.processingPackingsStream,
        initialData: warehouseRepository.processingPackings,
        builder: (context, asyncSnapshot) {
          // Loading view
          if (asyncSnapshot.connectionState == .waiting) {
            return const ShimmerView(type: ShimmerType.loadingIndicatorAtHead);
          }

          // Empty view
          if (asyncSnapshot.hasData && (asyncSnapshot.data ?? []).isEmpty) {
            return const EmptyViewState(
              message: 'Không tìm thấy phiếu đóng gói',
            );
          }

          final items = asyncSnapshot.data ?? [];
          return CommonLoadMoreRefreshWrapper(
            onRefresh: () async {},
            onLoadMore: () => true,
            minusMaxScrollValue: 100.h,
            child: ListView.separated(
              padding: .only(top: 8.h),
              itemCount: items.length + 1,
              separatorBuilder: (_, __) => SizedBox(height: 12.h),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  if (items.length <
                      warehouseRepository.totalProcessingPackings) {
                    return Padding(
                      padding: .all(20.w),
                      child: Center(
                        child: LoadingAnimationWidget.flickr(
                          leftDotColor: const Color(0xFF005C9D),
                          rightDotColor: const Color(0xFFE54925),
                          size: 36.w,
                        ),
                      ),
                    );
                  }
                  return Padding(
                    padding: .all(20.w),
                    child: Center(
                      child: Text(
                        'Đã hiển thị tất cả phiếu đóng gói',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                    ),
                  );
                }

                final slip = items[index];
                return SlipCard(
                  slip: slip
                    ..statusLabel = packingSlipStatusLabel(slip.statusEnum)
                    ..statusLabelColor = packingSlipStatusColor(slip.statusEnum)
                    ..cardColor = packingSlipStatusColor(slip.statusEnum)
                    ..infoRows = slip.infoRows,
                  onTap: () => context.navigator.pushNamed(
                    PackingSlipDetailsScreen.routeName,
                    arguments: slip.code,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
