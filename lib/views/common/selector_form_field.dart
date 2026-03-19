import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../res/res.dart';
import '../../utils/extension/extension.dart';
import '../../utils/functions/base_functions.dart';
import '../../utils/widgets/widgets.dart';

/// Selector form field (pick from list via bottom sheet)
///
/// Dùng để chọn 1 giá trị từ danh sách options (hoặc stream options),
/// hiển thị field dạng selector và mở bottom sheet list khi tap.
///
/// ## Features
/// - Hiển thị label/hint hoặc value đã chọn
/// - Mở bottom sheet để chọn item (custom renderValue)
/// - Hỗ trợ trạng thái disabled
/// - Hỗ trợ options tĩnh (SelectorFormField) hoặc stream (StreamSelectorFormField)
/// - Nếu options chứa null: hiển thị item placeholder “Thêm địa chỉ mới”
/// - Responsive với ScreenUtil
///
/// ## SelectorFormField example
/// ```dart
/// SelectorFormField<String>(
///   label: 'Chi nhánh',
///   hintOrValue: selectedBranch ?? 'Chọn chi nhánh',
///   selected: selectedBranch,
///   options: const ['Chi nhánh Local', 'Kho Gò Vấp'],
///   renderValue: (value, onTap) => ListTile(
///     title: Text(value),
///     onTap: onTap, // nhớ gọi onTap để apply chọn & đóng sheet
///   ),
///   onSelected: (v) => setState(() => selectedBranch = v),
/// )
/// ```
///
/// ## StreamSelectorFormField example
/// ```dart
/// StreamSelectorFormField<String>(
///   label: 'Chi nhánh',
///   hintOrValue: selectedBranch ?? 'Chọn chi nhánh',
///   selected: selectedBranch,
///   selectorStream: branchStream,               // Stream<List<String>>
///   selectorInitialValues: const ['Default'],   // optional
///   renderValue: (v, onTap) => ListTile(title: Text(v), onTap: onTap),
///   onSelected: (v) => setState(() => selectedBranch = v),
/// )
/// ```
///
/// ## Notes & tips
/// - renderValue: tùy biến widget, bắt buộc gọi onTap() để set value & đóng sheet.
/// - Có thể mở rộng tìm kiếm/filter trong bottom sheet trước ListView (tự thêm).
/// - Muốn custom empty-state: thêm logic vào renderValue hoặc bọc ListView.
/// - Muốn đổi maxHeight: chỉnh constraints trong _showSelector.
/// - Muốn required highlight: có thể truyền màu border (chỉnh code nếu cần).
class SelectorFormField<T> extends StatelessWidget {
  final String label;
  final String hintOrValue;
  final T? selected;
  final List<T?> options;
  final Widget Function(T value, void Function() onTap) renderValue;
  final Function(T? value) onSelected;
  final bool disabled;
  final double? maxHeight;

  const SelectorFormField({
    super.key,
    required this.label,
    required this.hintOrValue,
    this.selected,
    required this.options,
    required this.renderValue,
    required this.onSelected,
    this.disabled = false,
    this.maxHeight,
  });

  void _showSelector(BuildContext context) async {
    context.focus.unfocus();
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: maxHeight ?? MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (context) => ColumnWidget(
        mainAxisSize: .min,
        children: [
          BottomSheetHeader(title: label, onClose: context.navigator.pop),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              padding: .symmetric(vertical: 16.h),
              itemCount: options.length,
              clipBehavior: .hardEdge,
              itemBuilder: (context, index) {
                final selectorValue = options[index];
                if (selectorValue == null) {
                  return Container(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    margin: .only(bottom: 16.h),
                    child: ListTile(
                      leading: const Icon(Icons.add, color: AppColors.primary),
                      minLeadingWidth: 20,
                      title: Text(
                        "Thêm địa chỉ mới",
                        style: context.theme.textTheme.titleSmall,
                      ),
                      onTap: () {},
                    ),
                  );
                }

                return renderValue(selectorValue, () {
                  onSelected(selectorValue);
                  context.navigator.pop();
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showSelector(context),
      child: Container(
        padding: .symmetric(horizontal: 16.w),
        height: 44.h,
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.greyC0.withValues(alpha: 0.3)
              : AppColors.white,
          borderRadius: .circular(8.r),
          border: .all(color: AppColors.greyC0),
        ),
        child: RowWidget(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: ColumnWidget(
                mainAxisAlignment: .center,
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  if (selected != null)
                    Text(
                      label,
                      style: AppStyles.text.medium(
                        fSize: 10.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                  Text(
                    hintOrValue,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: selected != null
                          ? AppColors.black3
                          : AppColors.grey84,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.grey84, size: 24.sp),
          ],
        ),
      ),
    );
  }
}

class StreamSelectorFormField<T> extends StatefulWidget {
  final String label;
  final String hintOrValue;
  final T? selected;
  final Stream<List<T>> selectorStream;
  final List<T>? selectorInitialValues;
  final Widget Function(T? value, void Function() onTap) renderValue;
  final Function(T? value) onSelected;
  final bool disabled;
  final String? Function(T?)? validator;
  final bool autoSize;
  final List<T?>? joinValues;

  const StreamSelectorFormField({
    super.key,
    required this.label,
    required this.hintOrValue,
    this.selected,
    required this.selectorStream,
    this.selectorInitialValues,
    required this.renderValue,
    required this.onSelected,
    this.disabled = false,
    this.validator,
    this.autoSize = false,
    this.joinValues,
  });

  @override
  State<StreamSelectorFormField<T>> createState() =>
      _StreamSelectorFormFieldState<T>();

  /// Override trong subclass (vd. SearchSelectorFormField) để hiển thị modal khác (có search).
  void showSelector(BuildContext context, FormFieldState<T?>? fieldState) {
    context.focus.unfocus();
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
      builder: (context) => ColumnWidget(
        mainAxisSize: .min,
        children: [
          BottomSheetHeader(title: label, onClose: context.navigator.pop),
          Expanded(
            child: StreamBuilder<List<T>>(
              initialData: selectorInitialValues,
              stream: selectorStream,
              builder: (context, snapshot) {
                final List<T?> selectorValues = [
                  ...(joinValues ?? []),
                  ...(snapshot.data ?? []),
                ];
                return ListView.builder(
                  shrinkWrap: true,
                  padding: .symmetric(vertical: 16.h),
                  itemCount: selectorValues.length,
                  clipBehavior: .hardEdge,
                  itemBuilder: (context, index) {
                    final selectorValue = selectorValues[index];
                    return renderValue(selectorValue, () {
                      onSelected(selectorValue);
                      fieldState?.didChange(selectorValue);
                      context.navigator.pop();
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StreamSelectorFormFieldState<T>
    extends State<StreamSelectorFormField<T>> {
  FormFieldState<T?>? _formFieldState;

  @override
  void didUpdateWidget(covariant StreamSelectorFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Đồng bộ giá trị FormField với selected từ parent (sau build, tránh setState trong build)
    if (oldWidget.selected != widget.selected && _formFieldState != null) {
      final newSelected = widget.selected;
      final fieldState = _formFieldState!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        fieldState.didChange(newSelected);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<T?>(
      initialValue: widget.selected,
      validator: widget.validator,
      // disabled: chỉ validate khi form.validate() (bấm Lưu), tránh validate khi sync từ parent
      // (vd. đổi Tỉnh → xóa Phường/Xã → không đánh dấu Phường/Xã lỗi ngay)
      autovalidateMode: AutovalidateMode.disabled,
      builder: (field) {
        _formFieldState = field;
        final errorText = field.errorText;
        final current = field.value;
        return InkWell(
          onTap: () => widget.showSelector(context, field),
          child: Container(
            padding: .symmetric(
              horizontal: 16.w,
              vertical: widget.autoSize ? 8.h : 0,
            ),
            height: widget.autoSize ? null : 44.h,
            decoration: BoxDecoration(
              color: widget.disabled
                  ? AppColors.greyC0.withValues(alpha: 0.3)
                  : AppColors.white,
              borderRadius: .circular(8.r),
              border: .all(
                color: errorText == null ? AppColors.greyC0 : AppColors.scarlet,
              ),
            ),
            child: RowWidget(
              mainAxisAlignment: .spaceBetween,
              crossAxisAlignment: .center,
              children: [
                Expanded(
                  child: ColumnWidget(
                    mainAxisAlignment: .center,
                    crossAxisAlignment: .start,
                    gap: widget.autoSize ? 4.h : 2.h,
                    children: [
                      if (current != null)
                        Text(
                          widget.label,
                          style: AppStyles.text.medium(
                            fSize: 10.sp,
                            color: AppColors.grey84,
                          ),
                        ),
                      Text(
                        widget.hintOrValue,
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          height: widget.autoSize ? 16 / 14 : null,
                          color: current != null
                              ? AppColors.black3
                              : AppColors.grey84,
                        ),
                      ),
                      if (errorText != null)
                        Text(
                          errorText,
                          style: AppStyles.text.medium(
                            fSize: 11.sp,
                            color: AppColors.scarlet,
                          ),
                        ),
                    ],
                  ),
                ),
                widget.disabled
                    ? Container()
                    : Icon(
                        Icons.chevron_right,
                        color: AppColors.grey84,
                        size: 24.sp,
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchSelectorFormField<T> extends StreamSelectorFormField<T> {
  final Function(String searchQuery)? onSearch;
  const SearchSelectorFormField({
    super.key,
    required super.label,
    required super.hintOrValue,
    super.selected,
    required super.selectorStream,
    super.selectorInitialValues,
    required super.renderValue,
    required super.onSelected,
    super.disabled = false,
    super.validator,
    super.autoSize = false,
    this.onSearch,
  });

  @override
  void showSelector(BuildContext context, FormFieldState<T?>? fieldState) {
    context.focus.unfocus();
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
      builder: (context) => BottomModalWithSearchField<T>(
        selectorInitialValues: selectorInitialValues,
        selectorStream: selectorStream,
        label: label,
        renderValue: renderValue,
        onSelected: onSelected,
        disabled: disabled,
        fieldState: fieldState,
        onSearch: onSearch,
      ),
    );
  }
}

class BottomModalWithSearchField<T> extends StatefulWidget {
  final List<T>? selectorInitialValues;
  final Stream<List<T>> selectorStream;
  final String label;
  final Widget Function(T? value, void Function() onTap) renderValue;
  final Function(T? value) onSelected;
  final bool disabled;
  final FormFieldState<T?>? fieldState;
  final Function(String searchQuery)? onSearch;
  const BottomModalWithSearchField({
    super.key,
    required this.selectorStream,
    this.selectorInitialValues,
    required this.label,
    required this.renderValue,
    required this.onSelected,
    required this.disabled,
    this.fieldState,
    this.onSearch,
  });

  @override
  State<BottomModalWithSearchField<T>> createState() =>
      _BottomModalWithSearchFieldState<T>();
}

class _BottomModalWithSearchFieldState<T>
    extends State<BottomModalWithSearchField<T>> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    EasyDebounce.cancel('regionSearch');
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    EasyDebounce.cancel('regionSearch');
    EasyDebounce.debounce(
      'regionSearch',
      const Duration(milliseconds: 300),
      () {
        if (widget.onSearch != null) {
          widget.onSearch!(_searchController.text.toLowerCase().trim());
        } else {
          if (mounted) {
            setState(() {
              _searchQuery = _searchController.text.toLowerCase().trim();
            });
          }
        }
      },
    );
  }

  List<T?> _filteredList(List<T?> all) {
    if (_searchQuery.isEmpty) return all;
    return all.where((v) {
      debugPrint((v?.toString() ?? ""));
      return normalizeVietnamese(
        (v?.toString() ?? "").toLowerCase(),
      ).contains(normalizeVietnamese(_searchQuery));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding + keyboardHeight),
      child: ColumnWidget(
        mainAxisSize: .min,
        children: [
          BottomSheetHeader(
            title: widget.label,
            onClose: context.navigator.pop,
          ),
          // Search bar
          _buildSearchBar(),
          Expanded(
            child: StreamBuilder<List<T>>(
              initialData: widget.selectorInitialValues,
              stream: widget.selectorStream,
              builder: (context, snapshot) {
                final List<T?> selectorValues = snapshot.data ?? [];
                final list = _filteredList(selectorValues);
                return ListView.builder(
                  shrinkWrap: true,
                  padding: .symmetric(vertical: 16.h),
                  itemCount: list.length,
                  clipBehavior: .hardEdge,
                  itemBuilder: (context, index) {
                    final selectorValue = list[index];
                    return widget.renderValue(selectorValue, () {
                      widget.onSelected(selectorValue);
                      widget.fieldState?.didChange(selectorValue);
                      context.navigator.pop();
                    });
                  },
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
      margin: .symmetric(horizontal: 20.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: .circular(8.r),
      ),
      height: 40.h,
      child: RowWidget(
        gap: 12.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        children: [
          const Icon(Icons.search, color: AppColors.grey84),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm...',
                border: InputBorder.none,
                hintStyle: AppStyles.text.medium(
                  fSize: 14.sp,
                  height: 1.5,
                  color: AppColors.grey84,
                ),
              ),
              style: AppStyles.text.medium(fSize: 14.sp, height: 1.5),
            ),
          ),
          if (_searchQuery.isNotEmpty)
            InkWell(
              onTap: () {
                _searchController.clear();
              },
              child: const Icon(Icons.clear, color: AppColors.grey84, size: 20),
            ),
        ],
      ),
    );
  }
}
