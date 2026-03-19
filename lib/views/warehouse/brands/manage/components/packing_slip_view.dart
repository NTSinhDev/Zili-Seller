part of '../brands_screen.dart';

class _PackingSlipView extends StatelessWidget {
  final int statusIndex;
  final void Function(int) onStatusChanged;
  // final PageController pageController;
  final Future<void> Function() onRefresh;
  final bool Function() onLoadMore;

  const _PackingSlipView({
    required this.statusIndex,
    required this.onStatusChanged,
    // required this.pageController,
    required this.onRefresh,
    required this.onLoadMore,
  });

  // int get totalPackingSlips {
  //   final WarehouseRepository warehouseRepository = warehouseRepository;
  //   if (statusIndex == PackingSlipStatus.newRequest.index) {
  //     return warehouseRepository.totalNewPackings;
  //   } else if (statusIndex == PackingSlipStatus.processing.index) {
  //     return warehouseRepository.totalProcessingPackings;
  //   } else if (statusIndex == PackingSlipStatus.completed.index) {
  //     return warehouseRepository.totalCompletedPackings;
  //   } else {
  //     return 0;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: ColumnWidget(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: .symmetric(horizontal: 16.w, vertical: 12.h),
            color: AppColors.white,
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(
                  'Danh sách phiếu',
                  style: AppStyles.text.bold(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                ),
                SizedBox(height: 10.h),
                _RoastingStatusTabs(
                  selected: statusIndex,
                  onChanged: onStatusChanged,
                ),
              ],
            ),
          ),
          Expanded(
            child: Stack(fit: StackFit.expand,
              children: [
                if (statusIndex == _NewPackingSlipView.status.index)
                _NewPackingSlipView(statusIndex),
                if (statusIndex == _ProcessingPackingSlipView.status.index)
                _ProcessingPackingSlipView(statusIndex),
                if (statusIndex == _CompletedPackingSlipView.status.index)
                _CompletedPackingSlipView(statusIndex),
                // KeepAlivePageWidget(
                //   page: StreamBuilder<List<PackingSlip>>(
                //     stream: warehouseRepository.processingPackingsStream,
                //     initialData: warehouseRepository.processingPackings,
                //     builder: (context, asyncSnapshot) {
                //       // Loading view
                //       if (asyncSnapshot.connectionState == .waiting) {
                //         return const ShimmerView(
                //           type: ShimmerType.loadingIndicatorAtHead,
                //         );
                //       }
                  
                //       // Empty view
                //       if (asyncSnapshot.hasData &&
                //           (asyncSnapshot.data ?? []).isEmpty) {
                //         return const EmptyViewState(
                //           message: 'Không tìm thấy sản phẩm thương hiệu',
                //         );
                //       }
                  
                //       final items = asyncSnapshot.data ?? [];
                //       return CommonLoadMoreRefreshWrapper(
                //         onRefresh: onRefresh,
                //         onLoadMore: onLoadMore,
                //         minusMaxScrollValue: 100.h,
                //         child: ListView.separated(
                //           padding: .only(top: 8.h),
                //           itemCount: items.length + 1,
                //           separatorBuilder: (_, __) => SizedBox(height: 12.h),
                //           itemBuilder: (context, index) {
                //             if (index == items.length) {
                //               if (items.length < warehouseRepository.totalProcessingPackings) {
                //                 return Padding(
                //                   padding: .all(20.w),
                //                   child: Center(
                //                     child: LoadingAnimationWidget.flickr(
                //                       leftDotColor: const Color(0xFF005C9D),
                //                       rightDotColor: const Color(0xFFE54925),
                //                       size: 36.w,
                //                     ),
                //                   ),
                //                 );
                //               }
                //               return Padding(
                //                 padding: .all(20.w),
                //                 child: Center(
                //                   child: Text(
                //                     'Đã hiển thị tất cả phiếu rang',
                //                     style: AppStyles.text.medium(
                //                       fSize: 14.sp,
                //                       color: AppColors.grey84,
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             }
                  
                //             final slip = items[index];
                //             return SlipCard(
                //               slip: slip
                //                 ..statusLabel = packingSlipStatusLabel(
                //                   slip.statusEnum,
                //                 )
                //                 ..statusLabelColor = packingSlipStatusColor(
                //                   slip.statusEnum,
                //                 )
                //                 ..cardColor = packingSlipStatusColor(
                //                   slip.statusEnum,
                //                 )
                //                 ..infoRows = slip.infoRows,
                //               onTap: () => context.navigator.pushNamed(
                //                 PackingSlipDetailsScreen.routeName,
                //                 arguments: slip.code,
                //               ),
                //             );
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),
                // KeepAlivePageWidget(
                //   page: StreamBuilder<List<PackingSlip>>(
                //     stream: warehouseRepository.completedPackingsStream,
                //     initialData: warehouseRepository.completedPackings,
                //     builder: (context, asyncSnapshot) {
                //       // Loading view
                //       if (asyncSnapshot.connectionState == .waiting) {
                //         return const ShimmerView(
                //           type: ShimmerType.loadingIndicatorAtHead,
                //         );
                //       }
                  
                //       // Empty view
                //       if (asyncSnapshot.hasData &&
                //           (asyncSnapshot.data ?? []).isEmpty) {
                //         return const EmptyViewState(
                //           message: 'Không tìm thấy sản phẩm thương hiệu',
                //         );
                //       }
                  
                //       final items = asyncSnapshot.data ?? [];
                //       return CommonLoadMoreRefreshWrapper(
                //         onRefresh: onRefresh,
                //         onLoadMore: onLoadMore,
                //         minusMaxScrollValue: 100.h,
                //         child: ListView.separated(
                //           padding: .only(top: 8.h),
                //           itemCount: items.length + 1,
                //           separatorBuilder: (_, __) => SizedBox(height: 12.h),
                //           itemBuilder: (context, index) {
                //             if (index == items.length) {
                //               if (items.length < warehouseRepository.totalCompletedPackings) {
                //                 return Padding(
                //                   padding: .all(20.w),
                //                   child: Center(
                //                     child: LoadingAnimationWidget.flickr(
                //                       leftDotColor: const Color(0xFF005C9D),
                //                       rightDotColor: const Color(0xFFE54925),
                //                       size: 36.w,
                //                     ),
                //                   ),
                //                 );
                //               }
                //               return Padding(
                //                 padding: .all(20.w),
                //                 child: Center(
                //                   child: Text(
                //                     'Đã hiển thị tất cả phiếu rang',
                //                     style: AppStyles.text.medium(
                //                       fSize: 14.sp,
                //                       color: AppColors.grey84,
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             }
                  
                //             final slip = items[index];
                //             return SlipCard(
                //               slip: slip
                //                 ..statusLabel = packingSlipStatusLabel(
                //                   slip.statusEnum,
                //                 )
                //                 ..statusLabelColor = packingSlipStatusColor(
                //                   slip.statusEnum,
                //                 )
                //                 ..cardColor = packingSlipStatusColor(
                //                   slip.statusEnum,
                //                 )
                //                 ..infoRows = slip.infoRows,
                //               onTap: () => context.navigator.pushNamed(
                //                 PackingSlipDetailsScreen.routeName,
                //                 arguments: slip.code,
                //               ),
                //             );
                //           },
                //         ),
                //       );
                //     },
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
