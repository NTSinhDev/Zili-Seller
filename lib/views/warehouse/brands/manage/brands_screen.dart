import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../../bloc/warehouse/warehouse_cubit.dart';
import '../../../../bloc/base_cubit.dart';
import '../../../../bloc/warehouse/warehouse_state.dart';
import '../../../../data/models/product/product_variant.dart';
import '../../../../data/models/warehouse/packing_slip.dart';
import '../../../../data/repositories/warehouse_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../services/firebase_cloud_messaging/firebase_enum.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/enums/warehouse_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/base_functions.dart';
import '../../../../utils/functions/warehouse_functions.dart';
import '../../../../utils/helpers/permission_helper.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/common_search_bar.dart';
import '../../../common/date_selector_field.dart';
import '../../../common/empty_view_state.dart';
import '../../../common/shimmer_view.dart';
import '../../../common/slip_card.dart';
import '../../../common/warehouse_product_card.dart';
import '../../packing_slip/packing_slip_details/packing_slip_details_screen.dart';
import '../export.dart';

part 'components/filter_tabs.dart';
part 'components/packing_slip_view.dart';
part 'components/packing_tabs.dart';
part 'components/new_packing_slip.dart';
part 'components/processing_packing_slip.dart';
part 'components/completed_packing_slip.dart';
part 'special_variants_view.dart';
part 'packing_slips_view.dart';

class BrandsScreen extends StatefulWidget {
  const BrandsScreen({super.key});

  static const String routeName = '/brands';

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(canRequestFocus: false);
  int _tabIndex = 0;
  String? _brandKeyword;
  String? _packingKeyword;
  DateTime? _brandStartDate;
  DateTime? _brandEndDate;
  DateTime? _packingStartDate;
  DateTime? _packingEndDate;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    EasyDebounce.debounce('brandSearch', const Duration(milliseconds: 400), () {
      final text = _searchController.text.trim();
      if (_tabIndex == 0) {
        final current = _brandKeyword ?? '';
        if (current == text) return;
        _brandKeyword = text.isEmpty ? null : text;
      } else {
        final current = _packingKeyword ?? '';
        if (current == text) return;
        _packingKeyword = text.isEmpty ? null : text;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Thương hiệu',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: Column(
        children: [
          CommonSearchBar(
            padding: .fromLTRB(20.w, 16.h, 20.w, 0),
            controller: _searchController,
            hintSearch: 'Tìm kiếm theo tên, mã SKU,...',
            focusNode: _searchFocusNode,
          ),
          _FilterTabs(
            selectedTab: _tabIndex,
            onTabChanged: (index) {
              context.focus.unfocus();
              _searchController.text =
                  (index == 0 ? _brandKeyword : _packingKeyword) ?? "";
              setState(() => _tabIndex = index);
            },
            onFilterPressed: () {
              showModalBottomSheet(
                context: context,
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: .vertical(top: .circular(20.r)),
                ),
                isScrollControlled: true,
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                builder: (context) {
                  final bottomPadding = MediaQuery.of(
                    context,
                  ).viewPadding.bottom;
                  final keyboardHeight = MediaQuery.of(
                    context,
                  ).viewInsets.bottom;
                  return Padding(
                    padding: .only(bottom: bottomPadding + keyboardHeight),
                    child: ColumnWidget(
                      mainAxisSize: .min,
                      children: [
                        BottomSheetHeader(
                          title: "Bộ lọc tìm kiếm",
                          onClose: context.navigator.pop,
                        ),
                        _FilterView(
                          startDate: _tabIndex == 0
                              ? _brandStartDate
                              : _packingStartDate,
                          endDate: _tabIndex == 0
                              ? _brandEndDate
                              : _packingEndDate,
                          onFilterApplied: (startDate, endDate) {
                            setState(() {
                              if (_tabIndex == 0) {
                                _brandStartDate = startDate;
                                _brandEndDate = endDate;
                              } else {
                                _packingStartDate = startDate;
                                _packingEndDate = endDate;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
          if ((_tabIndex == 0 && (_brandKeyword?.trim() ?? "").isNotEmpty) ||
              (_tabIndex == 1 && (_packingKeyword?.trim() ?? "").isNotEmpty))
            Container(
              width: .infinity,
              padding: .symmetric(horizontal: 16.w, vertical: 12.h),
              child: Text(
                "Kết quả tìm kiếm:",
                textAlign: .start,
                style: AppStyles.text.bold(
                  fSize: 14.sp,
                  color: AppColors.black,
                ),
              ),
            ),
          Expanded(
            child: Stack(
              fit: .expand,
              children: [
                _SpecialVariantsView(_tabIndex, _brandKeyword, _brandStartDate, _brandEndDate),
                _PackingSlipList(_tabIndex, _packingKeyword, _packingStartDate, _packingEndDate),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterView extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime? startDate, DateTime? endDate) onFilterApplied;
  const _FilterView({
    this.startDate,
    this.endDate,
    required this.onFilterApplied,
  });

  @override
  State<_FilterView> createState() => _FilterViewState();
}

class _FilterViewState extends State<_FilterView> {
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;
  TimeOption? selectedTimeOption;

  @override
  void initState() {
    super.initState();
    selectedStartDate = widget.startDate;
    selectedEndDate = widget.endDate;
  }

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .symmetric(horizontal: 20.w, vertical: 16.h),
      gap: 20.w,
      children: [
        ColumnWidget(
          gap: 10.w,
          crossAxisAlignment: .start,
          children: [
            Text(
              "Tùy chọn khoảng thời gian",
              style: AppStyles.text.semiBold(
                fSize: 14.sp,
                color: AppColors.black3,
              ),
            ),
            DateRangeSelectorField(
              dateRange:
                  selectedStartDate.isNotNull && selectedEndDate.isNotNull
                  ? DateTimeRange<DateTime>(
                      start: selectedStartDate!,
                      end: selectedEndDate!,
                    )
                  : null,
              hint: 'Tùy chọn khoảng thời gian',
              label: 'khoảng thời gian',
              onChanged: (value) {
                selectedStartDate = value?.start;
                selectedEndDate = value?.end;
              },
            ),
          ],
        ),
        ColumnWidget(
          crossAxisAlignment: .start,
          gap: 10.w,
          children: [
            Text(
              "Thời gian",
              style: AppStyles.text.semiBold(
                fSize: 14.sp,
                color: AppColors.black3,
              ),
            ),
            RowWidget(
              gap: 10.w,
              children: TimeOption.values
                  .take(4)
                  .map(
                    (option) => _optionButtonLayout(
                      onPressed: () {
                        selectedTimeOption = option;
                        final timeRange = getRangeOfTimeOption(option);
                        selectedStartDate = timeRange.start;
                        selectedEndDate = timeRange.end;
                        setState(() {});
                      },
                      label: option.label,
                      isSelected: selectedTimeOption == option,
                    ),
                  )
                  .toList(),
            ),
            RowWidget(
              gap: 10.w,
              children: TimeOption.values
                  .skip(4)
                  .take(4)
                  .map(
                    (option) => _optionButtonLayout(
                      onPressed: () {
                        selectedTimeOption = option;
                        final timeRange = getRangeOfTimeOption(option);
                        selectedStartDate = timeRange.start;
                        selectedEndDate = timeRange.end;
                        setState(() {});
                      },
                      label: option.label,
                      isSelected: selectedTimeOption == option,
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: .symmetric(vertical: 14.h),
            shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
            elevation: 0,
          ),
          onPressed: () {
            context.navigator.pop();
            widget.onFilterApplied(selectedStartDate, selectedEndDate);
          },
          child: Container(
            width: .infinity,
            alignment: .center,
            child: Text(
              'Tìm kiếm',
              textAlign: .center,
              style: AppStyles.text.semiBold(
                fSize: 14.sp,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _optionButtonLayout({
    required String label,
    required Function() onPressed,
    required bool isSelected,
  }) {
    return Expanded(
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: isSelected ? AppColors.primary : AppColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
            side: BorderSide(
              color: isSelected ? AppColors.primary : AppColors.greyC0,
            ),
          ),
          padding: .zero,
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: AppStyles.text.medium(
            fSize: 12.sp,
            color: isSelected ? AppColors.white : AppColors.black3,
          ),
        ),
      ),
    );
  }
}
