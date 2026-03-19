part of '../create_screen.dart';

class _InformationSection extends StatelessWidget {
  final TextEditingController nameController;
  final GlobalKey<FormFieldState> nameFieldKey;
  final TextEditingController codeController;
  final GlobalKey<FormFieldState> codeFieldKey;
  final TextEditingController descriptionController;
  final GlobalKey<FormFieldState> descriptionFieldKey;
  const _InformationSection({
    required this.nameController,
    required this.nameFieldKey,
    required this.codeController,
    required this.codeFieldKey,
    required this.descriptionController,
    required this.descriptionFieldKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(vertical: 16.h, horizontal: 20.w),
      color: Colors.white,
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 20.h,
        children: [
          Text(
            'Thông tin chung',
            style: AppStyles.text.semiBold(fSize: 16.sp, color: AppColors.black3),
          ),
          InputFormField(
            controller: nameController,
            formFieldKey: nameFieldKey,
            label: 'Tên nhóm khách hàng (*)',
            hint: 'Nhập tên nhóm khách hàng (*)',
            type: TextInputType.name,
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập tên nhóm khách hàng';
              }
              return null;
            },
          ),
          InputFormField(
            controller: codeController,
            formFieldKey: codeFieldKey,
            label: 'Mã nhóm khách hàng',
            hint: 'Nhập mã nhóm khách hàng',
            type: TextInputType.text,
            textInputAction: TextInputAction.next,
          ),
          InputFormField(
            controller: descriptionController,
            formFieldKey: descriptionFieldKey,
            label: 'Mô tả',
            hint: 'Nhập mô tả',
            type: TextInputType.multiline,
            textInputAction: TextInputAction.newline,
            maxLines: 5,
          ),
        ],
      ),
    );
  }
}
