part of '../roasting_slip_create_screen.dart';

class _ImportWarehouse extends StatelessWidget {
  final Warehouse? importWarehouse;
  final Function(Warehouse) onChanged;
  const _ImportWarehouse({
    required this.importWarehouse,
    required this.onChanged,
  });

  void _showBranchSelection(BuildContext context) async {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) {
        final WarehouseRepository warehouseRepository =
            di<WarehouseRepository>();
        final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
        final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding + keyboardHeight),
          child: ColumnWidget(
            mainAxisSize: .min,
            children: [
              BottomSheetHeader(
                title: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Chọn chi nhánh nhập",
                        style: AppStyles.text.medium(fSize: 16.sp),
                      ),
                      TextSpan(
                        text: ' *',
                        style: AppStyles.text.medium(
                          fSize: 16.sp,
                          color: AppColors.scarlet,
                        ),
                      ),
                    ],
                  ),
                ),
                onClose: context.navigator.pop,
              ),
              StreamBuilder<List<Warehouse>>(
                stream: warehouseRepository.warehouseSubject.stream,
                builder: (context, snapshot) {
                  final List<Warehouse?> warehouses = snapshot.data ?? [];
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: .symmetric(vertical: 16.h),
                    itemCount: warehouses.length,
                    clipBehavior: .hardEdge,
                    itemBuilder: (context, index) {
                      final isSelected =
                          importWarehouse?.id == warehouses[index]?.id;
                      return BottomSheetListItem(
                        title: warehouses[index]?.name ?? '',
                        content: renderBaseAddress(
                          warehouses[index]?.baseAddress,
                        ),
                        isSelected: isSelected,
                        onTap: warehouses[index] != null
                            ? () => {
                                context.navigator.pop(),
                                onChanged(warehouses[index]!),
                              }
                            : context.navigator.pop,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return OpenBottomSheetListButton(
      label: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: "Chi nhánh nhập",
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: AppColors.grey84,
              ),
            ),
            TextSpan(
              text: ' *',
              style: AppStyles.text.medium(
                fSize: 12.sp,
                color: AppColors.scarlet,
              ),
            ),
          ],
        ),
      ),
      value: importWarehouse?.name,
      placeholder: 'Chọn chi nhánh nhập',
      onTap: () => _showBranchSelection(context),
    );
  }
}
