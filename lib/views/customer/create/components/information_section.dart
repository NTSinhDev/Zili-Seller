part of '../customer_create_screen.dart';

class _InformationSection extends StatelessWidget {
  final TextEditingController nameController;
  final GlobalKey<FormFieldState> nameFieldKey;
  final TextEditingController codeController;
  final GlobalKey<FormFieldState> codeFieldKey;
  final TextEditingController phoneController;
  final GlobalKey<FormFieldState> phoneFieldKey;
  final TextEditingController emailController;
  final GlobalKey<FormFieldState> emailFieldKey;
  final TextEditingController addressController;
  final GlobalKey<FormFieldState> addressFieldKey;

  // Selector
  final CustomerGroup? selectedCustomerGroup;
  final Function(CustomerGroup?) onCustomerGroupSelected;
  final Region? selectedProvince;
  final Function(Region?) onProvinceSelected;
  final Region? selectedWard;
  final Function(Region?) onWardSelected;

  const _InformationSection({
    required this.nameController,
    required this.nameFieldKey,
    required this.codeController,
    required this.codeFieldKey,
    required this.phoneController,
    required this.phoneFieldKey,
    required this.emailController,
    required this.emailFieldKey,
    required this.addressController,
    required this.addressFieldKey,
    required this.selectedCustomerGroup,
    required this.onCustomerGroupSelected,
    required this.selectedProvince,
    required this.onProvinceSelected,
    required this.selectedWard,
    required this.onWardSelected,
  });

  @override
  Widget build(BuildContext context) {
    final CustomerRepository customerRepo = di<CustomerRepository>();
    final AddressRepository addressRepo = di<AddressRepository>();

    return Container(
      padding: .symmetric(vertical: 16.h, horizontal: 20.w),
      color: Colors.white,
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 20.h,
        children: [
          Text(
            'Thông tin cơ bản',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
          // Tên khách hàng *
          InputFormField(
            controller: nameController,
            formFieldKey: nameFieldKey,
            label: 'Tên khách hàng (*)',
            hint: 'Nhập tên khách hàng (*)',
            type: .name,
            textInputAction: .next,
            validator: _validateCustomerName,
          ),
          InputFormField(
            controller: codeController,
            formFieldKey: codeFieldKey,
            label: 'Mã khách hàng',
            hint: 'Nhập mã khách hàng',
            type: .text,
            textInputAction: .next,
          ),
          // Nhóm khách hàng
          StreamSelectorFormField<CustomerGroup>(
            label: 'Nhóm khách hàng',
            hintOrValue: selectedCustomerGroup?.name ?? 'Chọn nhóm khách hàng',
            selected: selectedCustomerGroup,
            selectorStream: customerRepo.customerGroups.stream,
            renderValue: (value, onTap) => BottomSheetListItem(
              isDense: true,
              title:
                  value?.nameVi ??
                  value?.name ??
                  AppConstant.strings.DEFAULT_EMPTY_VALUE,
              isSelected: selectedCustomerGroup?.id == value?.id,
              onTap: onTap,
            ),
            onSelected: onCustomerGroupSelected,
          ),
          // Số điện thoại
          InputFormField(
            controller: phoneController,
            formFieldKey: phoneFieldKey,
            label: 'Số điện thoại',
            hint: 'Nhập số điện thoại',
            type: .phone,
            textInputAction: .next,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: _validatePhone,
          ),
          // Email
          InputFormField(
            controller: emailController,
            formFieldKey: emailFieldKey,
            label: 'Email',
            hint: 'Nhập email',
            type: .emailAddress,
            textInputAction: .next,
            validator: _validateEmail,
          ),
          // Khu vực (Tỉnh/thành sau sáp nhập)
          StreamSelectorFormField<Region>(
            label: 'Tỉnh/Thành phố',
            hintOrValue: selectedProvince?.name ?? 'Chọn Tỉnh/Thành phố',
            selected: selectedProvince,
            selectorStream: addressRepo.postMergerProvinceDistrictList.stream,
            renderValue: (value, onTap) => BottomSheetListItem(
              isDense: true,
              title: value?.name ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
              isSelected: selectedProvince?.code == value?.code,
              onTap: onTap,
            ),
            onSelected: onProvinceSelected,
            validator: _validateProvince,
          ),
          // Nhóm khách hàng
          StreamSelectorFormField<Region>(
            label: 'Phường/Xã',
            hintOrValue: selectedWard?.name ?? 'Chọn Phường/Xã',
            selected: selectedWard,
            disabled: selectedProvince == null,
            selectorStream: addressRepo.wardsList.stream,
            renderValue: (value, onTap) => BottomSheetListItem(
              isDense: true,
              title: value?.name ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
              isSelected: selectedWard?.code == value?.code,
              onTap: onTap,
            ),
            onSelected: onWardSelected,
            validator: _validateWard,
          ),
          // Địa chỉ *
          InputFormField(
            controller: addressController,
            formFieldKey: addressFieldKey,
            label: 'Địa chỉ',
            hint: 'Nhập địa chỉ',
            type: .streetAddress,
            textInputAction: .done,
            maxLines: 5,
          ),
        ],
      ),
    );
  }

  String? _validateWard(dynamic value) {
    if (addressController.text.trim().isNotEmpty &&
        selectedProvince != null &&
        value == null) {
      return 'Vui lòng chọn Phường/Xã';
    }
    return null;
  }

  String? _validateProvince(dynamic value) {
    if (addressController.text.trim().isNotEmpty && value == null) {
      return 'Vui lòng chọn Tỉnh/Thành phố';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value != null && value.trim().isNotEmpty) {
      final emailRegex = RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      );
      if (!emailRegex.hasMatch(value)) {
        return 'Email không hợp lệ';
      }
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value != null && value.isNotEmpty) {
      if (value.length < 10 || value.length > 12) {
        return 'Số điện thoại không hợp lệ';
      }
      return null;
    }
    return null;
  }

  String? _validateCustomerName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Vui lòng nhập tên khách hàng';
    }
    return null;
  }
}
