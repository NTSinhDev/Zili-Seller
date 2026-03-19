part of '../create_order_screen.dart';

class _AdditionalInfoSection extends StatelessWidget {
  final TextEditingController noteController;
  final FocusNode noteFocusNode;
  final Staff? selectedStaff;
  final Collaborator? selectedCollaborator;
  final String? selectedSource;
  final DateTime? deliveryDate;
  final DateTime? soldDate;
  final GlobalKey<FormFieldState> noteFieldKey;
  final Function(Staff) onStaffChanged;
  final Function(Collaborator) onCollaboratorChanged;
  final Function(String) onSourceChanged;
  final Function(DateTime?) onDeliveryDateChanged;
  final Function(DateTime?) onSoldDateChanged;

  const _AdditionalInfoSection({
    required this.noteController,
    required this.noteFocusNode,
    required this.selectedStaff,
    required this.selectedCollaborator,
    required this.selectedSource,
    required this.deliveryDate,
    required this.soldDate,
    required this.noteFieldKey,
    required this.onStaffChanged,
    required this.onCollaboratorChanged,
    required this.onSourceChanged,
    required this.onDeliveryDateChanged,
    required this.onSoldDateChanged,
  });

  void _showStaffSelection(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (context) => ColumnWidget(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(
            title: 'Chọn nhân viên phụ trách',
            onClose: () => Navigator.pop(context),
          ),
          StreamBuilder<List<Staff>>(
            stream: di<CustomerRepository>().activeStaffs.stream,
            builder: (context, snapshot) {
              final List<Staff?> staffs = snapshot.data ?? [];
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: .symmetric(vertical: 16.h),
                  itemCount: staffs.length,
                  clipBehavior: .hardEdge,
                  itemBuilder: (context, index) {
                    final isSelected = selectedStaff?.id == staffs[index]?.id;
                    return BottomSheetListItem(
                      leading: Icon(
                        CupertinoIcons.person_alt_circle_fill,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey84,
                      ),
                      title: staffs[index]?.name ?? '',
                      subTitle: staffs[index]?.phone ?? '',
                      isSelected: isSelected,
                      onTap: () {
                        if (staffs[index] != null) {
                          onStaffChanged(staffs[index]!);
                        }
                        context.navigator.maybePop();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
    // Unfocus sau khi bottom sheet đóng để tránh tự động focus vào input field
    if (context.mounted) {
      FocusScope.of(context).unfocus();
      noteFocusNode.unfocus();
    }
  }

  void _showCollaboratorSelection(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (context) => ColumnWidget(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(
            title: 'Chọn cộng tác viên',
            onClose: () => Navigator.pop(context),
          ),
          StreamBuilder<List<Collaborator>>(
            stream: di<CollaboratorRepository>().collaborators.stream,
            builder: (context, snapshot) {
              final List<Collaborator?> collaborators = snapshot.data ?? [];
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  itemCount: collaborators.length,
                  clipBehavior: Clip.hardEdge,
                  itemBuilder: (context, index) {
                    final isSelected =
                        selectedCollaborator?.id == collaborators[index]?.id;
                    return BottomSheetListItem(
                      leading: Icon(
                        CupertinoIcons.person_alt_circle_fill,
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey84,
                      ),
                      title: collaborators[index]?.name ?? '',
                      subTitle: collaborators[index]?.phone ?? '',
                      isSelected: isSelected,
                      onTap: () {
                        if (collaborators[index] != null) {
                          onCollaboratorChanged(collaborators[index]!);
                        }
                        context.navigator.maybePop();
                      },
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
    // Unfocus sau khi bottom sheet đóng để tránh tự động focus vào input field
    if (context.mounted) {
      FocusScope.of(context).unfocus();
      noteFocusNode.unfocus();
    }
  }

  void _showSalesChannelSelection(BuildContext context) async {
    FocusScope.of(context).unfocus();
    await showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (context) => _SourceSelector(
        selectedSource: selectedSource,
        onChanged: (val) {
          onSourceChanged(val);
          Navigator.pop(context);
        },
      ),
    );
    // Unfocus sau khi bottom sheet đóng để tránh tự động focus vào input field
    if (context.mounted) {
      FocusScope.of(context).unfocus();
      noteFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: AppColors.white,
      child: ColumnWidget(
        crossAxisAlignment: CrossAxisAlignment.start,
        gap: 20.h,
        children: [
          Text(
            'Thông tin bổ sung',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
          InputFormField(
            controller: noteController,
            focusNode: noteFocusNode,
            formFieldKey: noteFieldKey,
            label: 'Ghi chú đơn',
            hint: 'Nhập ghi chú đơn',
            type: .multiline,
            textInputAction: .newline,
            maxLines: 5,
          ),
          // _NoteInput(noteController: noteController),
          OpenBottomSheetListButton(
            label: 'Nhân viên phụ trách',
            value: selectedStaff?.name,
            placeholder: 'Chọn nhân viên',
            onTap: () => _showStaffSelection(context),
          ),
          OpenBottomSheetListButton(
            label: 'Cộng tác viên',
            value: selectedCollaborator?.name,
            placeholder: 'Chọn cộng tác viên',
            onTap: () => _showCollaboratorSelection(context),
          ),
          OpenBottomSheetListButton(
            label: 'Nguồn đơn',
            value: selectedSource,
            placeholder: 'Chọn kênh bán hàng',
            onTap: () => _showSalesChannelSelection(context),
          ),
          _DeliveryDatePicker(
            deliveryDate: deliveryDate,
            onChanged: onDeliveryDateChanged,
          ),
          _SoldDatePicker(soldDate: soldDate, onChanged: onSoldDateChanged),
        ],
      ),
    );
  }
}

class _SoldDatePicker extends StatelessWidget {
  final DateTime? soldDate;
  final Function(DateTime?) onChanged;

  const _SoldDatePicker({required this.soldDate, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'vi_VN');
    final displayDate = soldDate != null ? dateFormat.format(soldDate!) : null;

    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: .symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: .circular(8.r),
          border: .all(color: AppColors.greyC0),
        ),
        child: RowWidget(
          mainAxisAlignment: .spaceBetween,
          children: [
            Expanded(
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  Text(
                    'Ngày bán',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                  Text(
                    displayDate ?? 'Chọn ngày bán',
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: displayDate == null
                          ? AppColors.grey84
                          : AppColors.black3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.calendar_month_rounded, color: AppColors.grey84),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: soldDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('vi', 'VN'),
      fieldHintText: 'Ngày / Tháng / Năm',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}

class _DeliveryDatePicker extends StatelessWidget {
  final DateTime? deliveryDate;
  final Function(DateTime?) onChanged;

  const _DeliveryDatePicker({
    required this.deliveryDate,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy', 'vi_VN');
    final displayDate = deliveryDate != null
        ? dateFormat.format(deliveryDate!)
        : null;

    return InkWell(
      onTap: () => _selectDate(context),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.greyC0),
        ),
        child: RowWidget(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ColumnWidget(
                crossAxisAlignment: CrossAxisAlignment.start,
                gap: 4.h,
                children: [
                  Text(
                    'Ngày hẹn giao',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                  Text(
                    displayDate ?? 'Chọn ngày hẹn giao',
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: displayDate == null
                          ? AppColors.grey84
                          : AppColors.black3,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.calendar_month_rounded, color: AppColors.grey84),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: deliveryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: const Locale('vi', 'VN'),
      fieldHintText: 'Ngày / Tháng / Năm',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: AppColors.white,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: AppColors.primary),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(picked);
    }
  }
}

class _SourceSelector extends StatefulWidget {
  final String? selectedSource;
  final Function(String) onChanged;
  const _SourceSelector({
    required this.selectedSource,
    required this.onChanged,
  });

  @override
  State<_SourceSelector> createState() => _SourceSelectorState();
}

class _SourceSelectorState extends State<_SourceSelector> {
  final SettingCubit _settingCubit = di<SettingCubit>();
  final SettingRepository _settingRepo = di<SettingRepository>();

  @override
  void initState() {
    super.initState();
    final crSaleChannelsValue = _settingRepo.saleChannelsValue;
    if (crSaleChannelsValue.isEmpty) _settingCubit.getSaleChannels();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding + keyboardHeight),
      child: ColumnWidget(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(
            title: 'Chọn kênh bán hàng',
            onClose: context.navigator.pop,
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            child: StreamBuilder<List<String>>(
              stream: _settingRepo.saleChannels.stream,
              builder: (context, snapshot) {
                final List<String> sources = snapshot.data ?? [];
                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  itemCount: sources.length,
                  clipBehavior: Clip.hardEdge,
                  itemBuilder: (context, index) {
                    final isSelected = widget.selectedSource == sources[index];
                    return BottomSheetListItem(
                      title: sources[index],
                      isSelected: isSelected,
                      onTap: () => widget.onChanged(sources[index]),
                    );
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
