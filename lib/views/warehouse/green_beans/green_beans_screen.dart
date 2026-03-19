import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zili_coffee/bloc/warehouse/warehouse_state.dart';

import '../../../bloc/base_cubit.dart';
import '../../../bloc/warehouse/warehouse_cubit.dart';
import '../../../services/firebase_cloud_messaging/firebase_enum.dart';
import '../../../data/models/product/product_variant.dart';
import '../../../data/models/warehouse/roasting_slip.dart';
import '../../../data/repositories/warehouse_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../services/common_service.dart';
import '../../../utils/enums/warehouse_enum.dart';
import '../../../utils/enums.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/functions/base_functions.dart';
import '../../../utils/functions/warehouse_functions.dart';
import '../../../utils/helpers/permission_helper.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/action_app_bar.dart';
import '../../common/common_search_bar.dart';
import '../../common/date_selector_field.dart';
import '../../common/empty_view_state.dart';
import '../../common/shimmer_view.dart';
import '../../common/slip_card.dart';
import '../../common/warehouse_product_card.dart';
import '../roasting_slip/roasting_slip_create/roasting_slip_create_screen.dart';
import '../roasting_slip/roasting_slip_detail/roasting_slip_detail_screen.dart';

part 'green_bean_list.dart';
part 'roasting_slip_list.dart';
part 'components/filter_tabs.dart';
part 'components/roasting_slip_creation_button.dart';
part 'components/bottom_sheet_filter.dart';

class GreenBeansScreen extends StatefulWidget {
  const GreenBeansScreen({super.key});

  static const String routeName = '/green-beans';

  @override
  State<GreenBeansScreen> createState() => _GreenBeansScreenState();
}

class _GreenBeansScreenState extends State<GreenBeansScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode(canRequestFocus: false);
  int _tabIndex = 0;
  String? _greenBeanKeyword;
  String? _roastingSlipKeyword;

  DateTime? _greenBeanStartDate;
  DateTime? _greenBeanEndDate;
  DateTime? _roastingSlipStartDate;
  DateTime? _roastingSlipEndDate;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    EasyDebounce.debounce(
      'greenBeanSearch',
      const Duration(milliseconds: 400),
      () {
        final text = _searchController.text.trim();
        if (_tabIndex == 0) {
          final current = _greenBeanKeyword ?? '';
          if (current == text) return;
          _greenBeanKeyword = text.isEmpty ? null : text;
        } else {
          final current = _roastingSlipKeyword ?? '';
          if (current == text) return;
          _roastingSlipKeyword = text.isEmpty ? null : text;
        }
        setState(() {});
      },
    );
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
        label: 'Nhân xanh',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        actions: PermissionHelper.edit(AbilitySubject.roastingSlipManagement)
            ? [const _RoastingSlipCreationAction()]
            : [],
      ),
      resizeToAvoidBottomInset: true,
      body: Column(
        children: [
          CommonSearchBar(
            padding: .fromLTRB(20.w, 16.h, 20.w, 0),
            controller: _searchController,
            focusNode: _searchFocusNode,
            hintSearch: 'Tìm kiếm theo tên phiên bản, barcode,...',
          ),
          _FilterTabs(
            selectedTab: _tabIndex,
            onTabChanged: (index) {
              context.focus.unfocus();
              _searchController.text =
                  (index == 0 ? _greenBeanKeyword : _roastingSlipKeyword) ?? "";
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
                              ? _greenBeanStartDate
                              : _roastingSlipStartDate,
                          endDate: _tabIndex == 0
                              ? _greenBeanEndDate
                              : _roastingSlipEndDate,
                          onFilterApplied: (startDate, endDate) {
                            setState(() {
                              if (_tabIndex == 0) {
                                _greenBeanStartDate = startDate;
                                _greenBeanEndDate = endDate;
                              } else {
                                _roastingSlipStartDate = startDate;
                                _roastingSlipEndDate = endDate;
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
          if ((_tabIndex == 0 &&
                  (_greenBeanKeyword?.trim() ?? "").isNotEmpty) ||
              (_tabIndex == 1 &&
                  (_roastingSlipKeyword?.trim() ?? "").isNotEmpty))
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
                _GreenBeanList(
                  _tabIndex,
                  _greenBeanKeyword,
                  _greenBeanStartDate,
                  _greenBeanEndDate,
                ),
                _RoastingSlipList(
                  _tabIndex,
                  _roastingSlipKeyword,
                  _roastingSlipStartDate,
                  _roastingSlipEndDate,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RoastingSlipTabs extends StatelessWidget {
  final RoastingSlipStatus current;
  final ValueChanged<RoastingSlipStatus> onChanged;
  const _RoastingSlipTabs({required this.current, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final labels = <RoastingSlipStatus>[.newRequest, .roasting, .completed];
    return StreamBuilder<int>(
      stream: di<WarehouseRepository>().newRoastingSlipsCounter.stream,
      builder: (context, asyncSnapshot) {
        final count = asyncSnapshot.data ?? 0;
        return RowWidget(
          mainAxisAlignment: .start,
          gap: 16.w,
          children: List.generate(labels.length, (index) {
            final isSelected = current == labels[index];
            final Color color = isSelected
                ? AppColors.primary
                : AppColors.black3;
            return InkWell(
              onTap: () => onChanged(labels[index]),
              child: Container(
                padding: .symmetric(vertical: 8.h),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2.w,
                    ),
                  ),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: roastingSlipStatusLabel(labels[index]),
                        style: AppStyles.text
                            .medium(fSize: 12.sp, color: color)
                            .copyWith(fontWeight: isSelected ? .w600 : .w500),
                      ),
                      if (labels[index] == .newRequest && count > 0)
                        TextSpan(
                          text: ' (${count < 100 ? count : '99+'})',
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.scarlet,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

