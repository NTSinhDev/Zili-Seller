part of '../customer_create_screen.dart';

class _ManagerInformationSection extends StatelessWidget {
  final bool show;
  final Function() onAdd;
  final Staff? selectedStaff;
  final Function(Staff?) onStaffSelected;
  final Collaborator? selectedCollaborator;
  final Function(Collaborator?) onCollaboratorSelected;
  final TextEditingController descriptionController;
  final GlobalKey<FormFieldState> descriptionFieldKey;

  const _ManagerInformationSection({
    required this.show,
    required this.onAdd,
    required this.selectedStaff,
    required this.onStaffSelected,
    required this.selectedCollaborator,
    required this.onCollaboratorSelected,
    required this.descriptionController,
    required this.descriptionFieldKey,
  });

  @override
  Widget build(BuildContext context) {
    final customerRepo = di<CustomerRepository>();
    final collaboratorRepo = di<CollaboratorRepository>();
    return InkWell(
      onTap: !show ? onAdd : null,
      child: Container(
        padding: .symmetric(vertical: 16.h, horizontal: 20.w),
        color: Colors.white,
        child: Column(
          children: [
            Offstage(
              offstage: show,
              child: RowWidget(
                gap: 12.w,
                children: [
                  const Icon(Icons.add, color: AppColors.primary),
                  Text(
                    'Thêm thông tin khác',
                    style: AppStyles.text.semiBold(fSize: 16.sp),
                  ),
                ],
              ),
            ),
            Offstage(
              offstage: !show,
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 20.h,
                children: [
                  RowWidget(
                    mainAxisAlignment: .spaceBetween,
                    children: [
                      Text(
                        'Thông tin khác',
                        style: AppStyles.text.semiBold(fSize: 16.sp),
                      ),
                      InkWell(
                        onTap: show ? onAdd : null,
                        child: Icon(
                          Icons.close,
                          color: AppColors.grey84,
                          size: 20.sp,
                        ),
                      ),
                    ],
                  ),
                  StreamSelectorFormField<Staff>(
                    label: 'Nhân viên phụ trách',
                    hintOrValue:
                        selectedStaff?.name ?? 'Chọn Nhận viên phụ trách',
                    selected: selectedStaff,
                    selectorStream: customerRepo.activeStaffs.stream,
                    renderValue: (value, onTap) => BottomSheetListItem(
                      isDense: true,
                      leading: Icon(
                        CupertinoIcons.person_alt_circle_fill,
                        color: selectedStaff?.id == value?.id
                            ? AppColors.primary
                            : AppColors.grey84,
                      ),
                      title:
                          value?.name ??
                          AppConstant.strings.DEFAULT_EMPTY_VALUE,
                      isSelected: selectedStaff?.id == value?.id,
                      onTap: onTap,
                    ),
                    onSelected: onStaffSelected,
                  ),
                  StreamSelectorFormField<Collaborator>(
                    label: 'Cộng tác viên phụ trách',
                    hintOrValue:
                        selectedCollaborator?.name ??
                        'Chọn Cộng tác viên phụ trách',
                    selected: selectedCollaborator,
                    selectorStream: collaboratorRepo.collaborators.stream,
                    renderValue: (value, onTap) {
                      return BottomSheetListItem(
                        isDense: true,
                        leading: Icon(
                          CupertinoIcons.person_alt_circle_fill,
                          color: selectedCollaborator?.id == value?.id
                              ? AppColors.primary
                              : AppColors.grey84,
                        ),
                        title:
                            value?.name ??
                            AppConstant.strings.DEFAULT_EMPTY_VALUE,
                        content: value?.code ?? '',
                        isSelected: selectedCollaborator?.id == value?.id,
                        onTap: onTap,
                      );
                    },
                    onSelected: onCollaboratorSelected,
                  ),
                  InputFormField(
                    controller: descriptionController,
                    formFieldKey: descriptionFieldKey,
                    label: 'Mô tả',
                    hint: 'Nhập mô tả',
                    type: .multiline,
                    maxLines: 5,
                    textInputAction: .newline,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
