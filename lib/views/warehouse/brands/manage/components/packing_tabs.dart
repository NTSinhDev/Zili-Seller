part of '../brands_screen.dart';

class _RoastingStatusTabs extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  const _RoastingStatusTabs({required this.selected, required this.onChanged});

  Stream<List<PackingSlip>> stream(PackingSlipStatus status) {
    final WarehouseRepository warehouseRepository = di<WarehouseRepository>();
    switch (status) {
      case PackingSlipStatus.newRequest:
        return warehouseRepository.newPackingsStream;
      case PackingSlipStatus.processing:
        return warehouseRepository.processingPackingsStream;
      case PackingSlipStatus.completed:
        return warehouseRepository.completedPackingsStream;
      default:
        return const Stream.empty();
    }
  }

  int totalRecords(PackingSlipStatus status) {
    final WarehouseRepository warehouseRepository = di<WarehouseRepository>();
    switch (status) {
      case PackingSlipStatus.newRequest:
        return warehouseRepository.totalNewPackings;
      case PackingSlipStatus.processing:
        return warehouseRepository.totalProcessingPackings;
      case PackingSlipStatus.completed:
        return warehouseRepository.totalCompletedPackings;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tabs = [
      PackingSlipStatus.newRequest,
      PackingSlipStatus.processing,
      PackingSlipStatus.completed,
    ];
    return RowWidget(
      mainAxisAlignment: .start,
      gap: 16.w,
      children: List.generate(tabs.length, (i) {
        final isSelected = selected == tabs[i].index;
        final Color color = isSelected ? AppColors.primary : AppColors.black3;
        return InkWell(
          onTap: () => onChanged(tabs[i].index),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  width: 2.w,
                ),
              ),
            ),
            child: StreamBuilder<List<PackingSlip>>(
              stream: stream(tabs[i]),
              builder: (context, asyncSnapshot) {
                return Text(
                  packingSlipStatusLabel(tabs[i]),
                  style: AppStyles.text
                      .medium(fSize: 12.sp, color: color)
                      .copyWith(
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                );
                // ignore: dead_code
                final total = totalRecords(tabs[i]);
                return Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: packingSlipStatusLabel(tabs[i]),
                        style: AppStyles.text
                            .medium(fSize: 12.sp, color: color)
                            .copyWith(
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                      ),
                      if (total > 0)
                        TextSpan(
                          text: ' ($total)',
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.scarlet,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
