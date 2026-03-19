part of '../branch_section.dart';

class BranchSelector extends StatefulWidget {
  const BranchSelector({
    super.key,
    required this.warehouses,
    this.selectedWarehouse,
    required this.onWarehouseSelected,
  });
  final List<Warehouse> warehouses;
  final Warehouse? selectedWarehouse;
  final Function(Warehouse) onWarehouseSelected;

  @override
  State<BranchSelector> createState() => _BranchSelectorState();

  /// Open the branches selection modal bottom sheet
  ///
  /// @param context - The context of the build context
  /// @param crSelected - The selected warehouse
  /// @param onChange - The function to call when a warehouse is selected
  /// @return void
  ///
  /// Please load warehouses data before calling this method
  ///
  /// ```dart
  /// CommonService().loadWarehousesData().then((warehouses) {
  ///   // Do logic here...
  /// });
  /// ```
  static void openBranchesSelection(
    BuildContext context, {
    Warehouse? crSelected,
    required Function(Warehouse) onChange,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (bottomContext) {
        final WarehouseRepository whRepository = di<WarehouseRepository>();
        return StreamBuilder<List<Warehouse>>(
          stream: whRepository.warehouseSubject.stream,
          builder: (warehouseSelectorContext, snapshot) {
            final warehouses = snapshot.data ?? [];
            return BranchSelector(
              warehouses: warehouses,
              selectedWarehouse: crSelected,
              onWarehouseSelected: onChange,
            );
          },
        );
      },
    );
  }
}

class _BranchSelectorState extends State<BranchSelector> {
  List<Warehouse> filteredWarehouses = [];
  Warehouse? selectedWarehouse;

  @override
  void initState() {
    super.initState();
    filteredWarehouses = List.from(widget.warehouses);
    selectedWarehouse = widget.selectedWarehouse;
  }

  @override
  void didUpdateWidget(BranchSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedWarehouse != widget.selectedWarehouse) {
      selectedWarehouse = widget.selectedWarehouse;
    }
    if (oldWidget.warehouses != widget.warehouses) {
      filteredWarehouses = List.from(widget.warehouses);
    }
  }

  void _filterWarehouses(String query) {
    EasyDebounce.cancel('filterWarehousesEvent');
    EasyDebounce.debounce(
      'filterWarehousesEvent',
      const Duration(milliseconds: 400),
      () {
        setState(() {
          if (query.isEmpty) {
            filteredWarehouses = List.from(widget.warehouses);
          } else {
            filteredWarehouses = widget.warehouses
                .where(
                  (warehouse) =>
                      warehouse.name.toLowerCase().contains(
                        query.toLowerCase(),
                      ) ||
                      (warehouse.code?.toLowerCase().contains(
                            query.toLowerCase(),
                          ) ??
                          false),
                )
                .toList();
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: .only(bottom: bottomPadding + keyboardHeight),
      child: ColumnWidget(
        mainAxisSize: .min,
        gap: 16.h,
        children: [
          BottomSheetHeader(
            title: 'Chọn chi nhánh',
            onClose: context.navigator.maybePop,
          ),
          _buildSearchBar(),
          if (filteredWarehouses.isEmpty)
            Expanded(
              child: Padding(
                padding: .all(20.w),
                child: Text(
                  'Không tìm thấy chi nhánh nào',
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.grey84,
                  ),
                  textAlign: .center,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredWarehouses.length,
                clipBehavior: .hardEdge,
                itemBuilder: (context, index) {
                  final warehouse = filteredWarehouses[index];
                  final isSelected = selectedWarehouse?.id == warehouse.id;
                  return Container(
                    color: isSelected ? AppColors.background : null,
                    child: ListTile(
                      title: Text(
                        warehouse.name,
                        style: AppStyles.text.medium(
                          fSize: 16.sp,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.black3,
                        ),
                      ),
                      subtitle: Text(
                        renderBaseAddress(warehouse.baseAddress),
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          height: 14 / 12,
                          color: AppColors.grey84,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: AppColors.primary)
                          : null,
                      onTap: () {
                        widget.onWarehouseSelected(warehouse);
                        if (mounted) {
                          Navigator.pop(context);
                        }
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: .symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: .circular(8.r),
      ),
      height: 40.h,
      child: RowWidget(
        gap: 12.w,
        padding: .symmetric(horizontal: 12.w),
        children: [
          const Icon(Icons.search, color: AppColors.grey84),
          Expanded(
            child: TextField(
              onChanged: _filterWarehouses,
              decoration: InputDecoration(
                contentPadding: .symmetric(vertical: 14),
                hintText: 'Tìm kiếm chi nhánh',
                border: InputBorder.none,
                hintStyle: AppStyles.text.medium(
                  fSize: 14,
                  height: 16 / 14,
                  color: AppColors.grey84,
                ),
              ),
              style: AppStyles.text.medium(fSize: 14, height: 16 / 14),
            ),
          ),
        ],
      ),
    );
  }
}
