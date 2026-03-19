part of '../create_order_screen.dart';

class _DeliveryMethods extends StatelessWidget {
  final String? selectedMethod;
  final List<String> methods;
  final Function(String) onMethodSelected;

  const _DeliveryMethods({
    required this.selectedMethod,
    required this.methods,
    required this.onMethodSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: AppColors.white,
      child: InkWell(
        onTap: () => _deliveryMethodSelection(context),
        child: RowWidget(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RowWidget(
              gap: 12.w,
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(
                    Icons.store_outlined,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
                ColumnWidget(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  gap: 4.h,
                  children: [
                    Text(
                      'Phương thức giao hàng',
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                    Text(
                      selectedMethod ?? 'Chưa chọn phương thức giao hàng',
                      style: AppStyles.text.semiBold(
                        fSize: 16.sp,
                        color: AppColors.black3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.grey84,
              size: 24.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _deliveryMethodSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      builder: (context) => DeliveryMethodSelector(
        methods: methods,
        selectedMethod: selectedMethod,
        onMethodSelected: onMethodSelected,
      ),
    );
  }
}

class DeliveryMethodSelector extends StatefulWidget {
  const DeliveryMethodSelector({
    super.key,
    required this.methods,
    this.selectedMethod,
    required this.onMethodSelected,
  });
  final List<String> methods;
  final String? selectedMethod;
  final Function(String) onMethodSelected;

  @override
  State<DeliveryMethodSelector> createState() => _DeliveryMethodSelectorState();
}

class _DeliveryMethodSelectorState extends State<DeliveryMethodSelector> {
  List<String> filteredMethods = [];
  String? selectedMethod;

  @override
  void initState() {
    super.initState();
    // filteredWarehouses = List.from(widget.warehouses);
    // selectedWarehouse = widget.selectedWarehouse;
  }

  // @override
  // void didUpdateWidget(BranchSelector oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.selectedWarehouse != widget.selectedWarehouse) {
  //     selectedWarehouse = widget.selectedWarehouse;
  //   }
  //   if (oldWidget.warehouses != widget.warehouses) {
  //     filteredWarehouses = List.from(widget.warehouses);
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
  }

  // void _filterWarehouses(String query) {
  //   EasyDebounce.cancel('filterWarehousesEvent');
  //   EasyDebounce.debounce(
  //     'filterWarehousesEvent',
  //     const Duration(milliseconds: 400),
  //     () {
  //       setState(() {
  //         if (query.isEmpty) {
  //           filteredWarehouses = List.from(widget.warehouses);
  //         } else {
  //           filteredWarehouses = widget.warehouses
  //               .where((warehouse) =>
  //                   warehouse.name
  //                       .toLowerCase()
  //                       .contains(query.toLowerCase()) ||
  //                   (warehouse.code
  //                           ?.toLowerCase()
  //                           .contains(query.toLowerCase()) ??
  //                       false))
  //               .toList();
  //         }
  //       });
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding + keyboardHeight,
      ),
      child: ColumnWidget(
        mainAxisSize: MainAxisSize.min,
        gap: 16.h,
        children: [
          buildHeader(),
          buildSearchBar(),
          // if (filteredWarehouses.isEmpty)
          //   Expanded(
          //     child: Padding(
          //       padding: EdgeInsets.all(20.w),
          //       child: Text(
          //         'Không tìm thấy chi nhánh nào',
          //         style: AppStyles.text.medium(
          //           fSize: 14.sp,
          //           color: AppColors.grey84,
          //         ),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   )
          // else
          //   Expanded(
          //     child: ListView.builder(
          //       shrinkWrap: true,
          //       itemCount: filteredWarehouses.length,
          //       clipBehavior: Clip.hardEdge,
          //       itemBuilder: (context, index) {
          //         final warehouse = filteredWarehouses[index];
          //         final isSelected = selectedWarehouse?.id == warehouse.id;
          //         return Container(
          //           color: isSelected ? AppColors.background : null,
          //           child: ListTile(
          //             title: Text(
          //               warehouse.name,
          //               style: AppStyles.text.medium(
          //                 fSize: 16.sp,
          //                 color:
          //                     isSelected ? AppColors.primary : AppColors.black3,
          //               ),
          //             ),
          //             subtitle: Text(
          //               renderBaseAddress(warehouse.baseAddress),
          //               style: AppStyles.text.medium(
          //                 fSize: 12.sp,
          //                 color: AppColors.grey84,
          //               ),
          //             ),
          //             trailing: isSelected
          //                 ? const Icon(Icons.check, color: AppColors.primary)
          //                 : null,
          //             onTap: () {
          //               widget.onWarehouseSelected(warehouse);
          //               if (mounted) {
          //                 Navigator.pop(context);
          //               }
          //             },
          //           ),
          //         );
          //       },
          //     ),
          //   ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return RowWidget(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 12.w, 5.h),
      border: const Border(bottom: BorderSide(color: AppColors.greyC0)),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Chọn chi nhánh', style: AppStyles.text.semiBold(fSize: 16.sp)),
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: const Icon(Icons.close, color: AppColors.grey84),
          ),
        ),
      ],
    );
  }

  Widget buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8.r),
      ),
      height: 40.h,
      // child: RowWidget(
      //   gap: 12.w,
      //   padding: EdgeInsets.symmetric(horizontal: 12.w),
      //   children: [
      //     const Icon(Icons.search, color: AppColors.grey84),
      //     Expanded(
      //       child: TextField(
      //         onChanged: _filterWarehouses,
      //         decoration: InputDecoration(
      //           hintText: 'Tìm kiếm chi nhánh',
      //           border: InputBorder.none,
      //           hintStyle: AppStyles.text
      //               .medium(fSize: 14.sp, height: 1.5, color: AppColors.grey84),
      //         ),
      //         style: AppStyles.text.medium(fSize: 14.sp, height: 1.5),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
