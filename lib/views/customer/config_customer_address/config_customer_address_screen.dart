import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/address/address_cubit.dart';
import '../../../bloc/customer/customer_cubit.dart';
import '../../../data/dto/customer/create_customer_address_input.dart';
import '../../../data/models/address/address.dart';
import '../../../data/models/address/region.dart';
import '../../../data/models/user/customer.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/enums/address_enum.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/functions/address_functions.dart';
import '../../../utils/widgets/widgets.dart';
import '../../../views/common/input_form_field.dart';
import '../../common/bottom_scaffold_button.dart';
import '../../common/selector_form_field.dart';

class ConfigCustomerAddressScreen extends StatefulWidget {
  final Customer? customer;
  final Address? initialAddress;
  final String? title;
  final CRUDType mode;
  const ConfigCustomerAddressScreen({
    super.key,
    required this.mode,
    this.customer,
    this.initialAddress,
    this.title,
  });

  static String createRoute = '/customer/address/create';
  static String updateRoute = '/customer/address/update';

  @override
  State<ConfigCustomerAddressScreen> createState() =>
      _ConfigCustomerAddressScreenState();
}

class _ConfigCustomerAddressScreenState
    extends State<ConfigCustomerAddressScreen> {
  final CustomerCubit _customerCubit = di<CustomerCubit>();
  final AddressCubit _addressCubit = di<AddressCubit>();
  final CustomerRepository _customerRepository = di<CustomerRepository>();
  final AddressRepository _addressRepo = di<AddressRepository>();

  late CRUDType _mode;
  bool _isChanged = false; // Không cần setState để cập nhật biến này
  final _formKey = GlobalKey<FormState>();
  // ** Controllers for information section
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _faxCodeController = TextEditingController();
  final _addressController = TextEditingController();
  // ** Form field keys for information section
  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _phoneFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _faxCodeFieldKey = GlobalKey<FormFieldState>();
  final _addressFieldKey = GlobalKey<FormFieldState>();

  late CustomerAddressInputDTO _customerAddress;

  @override
  void initState() {
    super.initState();
    _initializeData(widget.initialAddress);
    _loadDataScreen();
    _subscribeEvents();
  }

  void _subscribeEvents() {
    bool listener() => _isChanged = true;
    _nameController.addListener(listener);
    _phoneController.addListener(listener);
    _emailController.addListener(listener);
    _faxCodeController.addListener(listener);
    _addressController.addListener(listener);
  }

  void _initializeData(Address? address) {
    if (address != null) {
      _mode = widget.mode;
      final useNewAddress =
          address.addressType == RegionType.postMerger.toConstant;
      final region = useNewAddress
          ? Region(
              code: address.provinceCode ?? "",
              name: address.province ?? "",
              type: RegionType.postMerger.toConstant,
            )
          : Region(
              code: address.districtCode ?? "",
              name: address.district ?? "",
              type: RegionType.preMerger.toConstant,
              province: RegionDistrict(
                code: address.provinceCode ?? "",
                name: address.province ?? "",
                type: RegionType.postMerger.toConstant,
              ),
            );
      final subRegion = Region(
        code: address.wardCode ?? "",
        name: address.ward ?? "",
        type: address.addressType ?? RegionType.preMerger.toConstant,
      );
      _customerAddress = CustomerAddressInputDTO(
        address: address,
        useNewAddress: useNewAddress,
        region: region,
        subRegion: subRegion,
        customer: CustomerAddressData(
          customerId: widget.customer?.id,
          name: address.name ?? '',
          phone: address.phone ?? '',
          email: address.email ?? '',
          faxCode: address.postalCode ?? '',
          specificAddress: address.address ?? '',
        ),
      );
      _nameController.text = address.name ?? '';
      _phoneController.text = address.phone ?? '';
      _emailController.text = address.email ?? '';
      _faxCodeController.text = address.postalCode ?? '';
      _addressController.text = address.address ?? '';
    } else {
      _customerAddress = CustomerAddressInputDTO(
        customer: CustomerAddressData(customerId: widget.customer?.id),
      );
    }

    _isChanged = false;
  }

  void _loadDataScreen() {
    _customerCubit.getCustomerAddresses(widget.customer!.id);
    _addressCubit.filterDistrictsByType(_customerAddress.regionType);
    if (_customerAddress.regionByType != null) {
      _addressCubit.getWardsByType(
        districtCode: _customerAddress.regionByType!.code,
        type: _customerAddress.regionType,
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _faxCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerCubit, CustomerState>(
      bloc: _customerCubit,
      listener: (context, state) {
        if (state is LoadingCustomerState) {
          context.showLoading();
        } else if (state is LoadedCustomerState) {
          context
            ..hideLoading()
            ..navigator.pop(state.data);
        } else if (state is FailedCustomerState) {
          context.hideLoading();
          CustomSnackBarWidget(
            context,
            type: .error,
            message:
                "${_mode == .update ? 'Cập nhật' : 'Tạo'} ${(widget.title ?? 'Địa chỉ khách hàng').toLowerCase()} thất bại!",
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBarWidget.lightAppBar(
          context,
          label: widget.title ?? 'Địa chỉ khách hàng',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
        ),
        body: Form(
          key: _formKey,
          child: GestureDetector(
            onTap: context.focus.unfocus,
            child: SingleChildScrollView(
              child: ColumnWidget(
                margin: .symmetric(vertical: 8.h),
                padding: .all(16.w),
                backgroundColor: Colors.white,
                crossAxisAlignment: .stretch,
                gap: 16.h,
                children: [
                  if (widget.mode == .update)
                    StreamSelectorFormField<Address>(
                      onSelected: (address) {
                        if (address.isNull) {
                          // Tạo địa chỉ mới
                          _mode = .create;
                          _customerAddress = CustomerAddressInputDTO(
                            customer: CustomerAddressData(
                              customerId: widget.customer?.id,
                            ),
                          );
                          _nameController.clear();
                          _phoneController.clear();
                          _emailController.clear();
                          _faxCodeController.clear();
                          _addressController.clear();
                          // setState(() {});
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Future.microtask(() {
                              if (!mounted) return;
                              _formKey.currentState?.reset();
                            });
                          });
                        } else {
                          _initializeData(address);
                          _customerAddress.address = address;
                          setState(() {});
                        }
                      },
                      label: 'Chọn địa chỉ',
                      hintOrValue:
                          renderAddressValueForSelector(
                            _customerAddress.address,
                          ) ??
                          "Tạo ${(widget.title ?? 'Địa chỉ khách hàng').toLowerCase()} mới",
                      selected: _customerAddress.address,
                      joinValues: [null],
                      selectorStream:
                          _customerRepository.addressesOfCustomer.stream,
                      autoSize: true,
                      renderValue: (value, onTap) {
                        if (value.isNull) {
                          return Container(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            margin: .only(bottom: 16.h),
                            child: ListTile(
                              leading: const Icon(
                                Icons.add,
                                color: AppColors.primary,
                              ),
                              minLeadingWidth: 20,
                              title: Text(
                                "Thêm địa chỉ mới",
                                style: AppStyles.text.semiBold(
                                  fSize: 14.sp,
                                  color: AppColors.black3,
                                ),
                              ),
                              onTap: onTap,
                            ),
                          );
                        }
                        final isSelected =
                            _customerAddress.address?.id == value!.id;
                        return BottomSheetListItem(
                          title: value.name ?? value.displayName,
                          subTitle: value.phone,
                          content: renderCustomerAddress(value),
                          isDefault: value.isDefault,
                          isSelected: isSelected,
                          onTap: onTap,
                        );
                      },
                    ),
                  InputFormField(
                    formFieldKey: _nameFieldKey,
                    controller: _nameController,
                    label: 'Tên khách hàng (*)',
                    hint: 'Nhập tên khách hàng (*)',
                    validator: _validateName,
                    textInputAction: .next,
                  ),
                  InputFormField(
                    formFieldKey: _phoneFieldKey,
                    controller: _phoneController,
                    label: 'Số điện thoại',
                    hint: 'Nhập số điện thoại',
                    validator: _validatePhone,
                    textInputAction: .next,
                    type: .phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  InputFormField(
                    formFieldKey: _emailFieldKey,
                    controller: _emailController,
                    label: 'Email',
                    hint: 'Email',
                    validator: _validateEmail,
                    textInputAction: .next,
                    type: .emailAddress,
                  ),
                  RowWidget(
                    gap: 12.w,
                    children: [
                      const Expanded(
                        flex: 2,
                        child: _CountrySelectorField(
                          selectedCountry: 'Vietnam',
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: SizedBox(
                          height: 40.h,
                          child: InputFormField(
                            formFieldKey: _faxCodeFieldKey,
                            controller: _faxCodeController,
                            label: 'Mã bưu điện',
                            hint: 'Nhập mã bưu điện',
                            textInputAction: .next,
                          ),
                        ),
                      ),
                    ],
                  ),
                  _locationForm(),
                  InputFormField(
                    formFieldKey: _addressFieldKey,
                    controller: _addressController,
                    label: 'Địa chỉ cụ thể (*)',
                    hint: 'Nhập địa chỉ cụ thể (*)',
                    textInputAction: .done,
                    validator: _validateSpecificAddress,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomScaffoldButton(
          onTap: () => _onSave(context),
          label: 'Xác nhận',
        ),
      ),
    );
  }

  Widget _locationForm() {
    debugPrint(
      "regionType: ${_customerAddress.regionType} - ${_customerAddress.useNewAddress}",
    );
    return Container(
      padding: .symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        border: .all(color: AppColors.greyC0.withValues(alpha: 0.5)),
        borderRadius: .circular(8.r),
      ),
      child: ColumnWidget(
        gap: 12.h,
        children: [
          // Switch địa chỉ mới
          RowWidget(
            mainAxisAlignment: .spaceBetween,
            border: Border(
              bottom: BorderSide(
                color: AppColors.greyC0.withValues(alpha: 0.5),
              ),
            ),
            children: [
              Text(
                'Địa chỉ mới',
                style: AppStyles.text.semiBold(
                  fSize: 14.sp,
                  color: AppColors.grey,
                ),
              ),
              SwitchButtonWidget(
                value: _customerAddress.useNewAddress,
                scale: 0.76,
                onSwitch: (value) {
                  _customerAddress.useNewAddress = value;
                  final isLoaded = value
                      ? _addressRepo.postMergerProvinceDistrictList.hasValue
                      : _addressRepo.preMergerProvinceDistrictList.hasValue;
                  if (!isLoaded) {
                    _addressCubit.filterDistrictsByType(
                      _customerAddress.regionType,
                    );
                  }
                  setState(() {});
                },
              ),
            ],
          ),
          SearchSelectorFormField<Region>(
            onSelected: (region) {
              if (region?.code == _customerAddress.regionByType?.code) return;
              setState(() {
                _customerAddress.region = region;
                _customerAddress.subRegion = null;
              });
              if (region.isNotNull) {
                _addressCubit.getWardsByType(
                  districtCode: region!.code,
                  type: _customerAddress.regionType,
                );
              }
            },
            label: _customerAddress.useNewAddress
                ? 'Tỉnh/Thành phố (*)'
                : 'Tỉnh/Thành phố - Quận/Huyện (*)',
            hintOrValue:
                _customerAddress.regionByType?.displayName ??
                (_customerAddress.useNewAddress
                    ? 'Chọn Tỉnh/Thành phố (*)'
                    : 'Chọn Tỉnh/Thành phố - Quận/Huyện (*)'),
            selected: _customerAddress.region,
            selectorStream: _customerAddress.regionType == .postMerger
                ? _addressRepo.postMergerProvinceDistrictList.stream
                : _addressRepo.preMergerProvinceDistrictList.stream,
            autoSize: true,
            validator: _validateProvince,
            renderValue: (value, onTap) {
              final isSelected = _customerAddress.region?.code == value?.code;
              return InkWell(
                onTap: onTap,
                child: Container(
                  color: isSelected ? AppColors.background : null,
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: RowWidget(
                    children: [
                      Expanded(
                        child: Text(
                          value?.displayName ??
                              AppConstant.strings.DEFAULT_EMPTY_VALUE,
                          style: AppStyles.text.medium(
                            fSize: 14.sp,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.black3,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check, color: AppColors.primary),
                    ],
                  ),
                ),
              );
            },
          ),
          SearchSelectorFormField<Region>(
            onSelected: (region) {
              if (region?.code == _customerAddress.subRegionByType?.code) {
                return;
              }

              setState(() {
                _customerAddress.subRegion = region;
              });
            },
            disabled: _customerAddress.regionByType.isNull,
            label: 'Phường/Xã (*)',
            hintOrValue:
                _customerAddress.subRegionByType?.name ?? 'Chọn Phường/Xã (*)',
            selected: _customerAddress.subRegionByType,
            selectorStream: _addressRepo.wardsList.stream,
            autoSize: true,
            validator: _validateWard,
            renderValue: (value, onTap) {
              final isSelected =
                  _customerAddress.subRegionByType?.code == value?.code;
              return InkWell(
                onTap: onTap,
                child: Container(
                  color: isSelected ? AppColors.background : null,
                  height: 40.0,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: RowWidget(
                    children: [
                      Expanded(
                        child: Text(
                          value?.name ??
                              AppConstant.strings.DEFAULT_EMPTY_VALUE,
                          style: AppStyles.text.medium(
                            fSize: 14.sp,
                            color: isSelected
                                ? AppColors.primary
                                : AppColors.black3,
                          ),
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check, color: AppColors.primary),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tên khách hàng không được để trống';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final normalized = value
        .trim()
        .replaceAll(' ', '')
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll(AppConstant.strings.DEFAULT_EMPTY_VALUE, '');
    final phoneRegex = RegExp(r'^(\+84|0)[0-9]{9,10}$');
    if (!phoneRegex.hasMatch(normalized)) {
      return 'Số điện thoại không hợp lệ';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) return 'Email không hợp lệ';
    return null;
  }

  String? _validateProvince(dynamic value) {
    if (value == null) {
      return _customerAddress.useNewAddress
          ? 'Vui lòng chọn Tỉnh/Thành phố'
          : 'Vui lòng chọn Tỉnh/Thành phố - Quận/Huyện';
    }
    return null;
  }

  String? _validateWard(dynamic value) =>
      value == null ? 'Vui lòng chọn Phường/Xã' : null;

  String? _validateSpecificAddress(String? value) {
    if (value?.trim().isEmpty ?? true) {
      return 'Địa chỉ cụ thể không được để trống';
    }
    return null;
  }

  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_customerAddress.validate(_mode)) {
      CustomSnackBarWidget(
        context,
        type: .error,
        message: "Thông tin không hợp lệ",
      ).show();
      return;
    }

    // Add input value
    _customerAddress
      ..customer?.name = _nameController.text.trim()
      ..customer?.phone = _phoneController.text.trim()
      ..customer?.email = _emailController.text.trim()
      ..customer?.faxCode = _faxCodeController.text.trim()
      ..customer?.specificAddress = _addressController.text.trim();

    switch (_mode) {
      case CRUDType.create:
        _customerCubit.createCustomerAddressV1(input: _customerAddress);
        break;
      case CRUDType.update:
        bool isDifferentRegion = false;
        if (_customerAddress.useNewAddress) {
          isDifferentRegion =
              (_customerAddress.regionByType?.code !=
                  _customerAddress.address?.provinceCode) ||
              (_customerAddress.subRegionByType?.code !=
                  _customerAddress.address?.wardCode);
        } else {
          isDifferentRegion =
              (_customerAddress.regionByType?.code !=
                  _customerAddress.address?.districtCode) ||
              (_customerAddress.regionByType?.province?.code !=
                  _customerAddress.address?.provinceCode) ||
              (_customerAddress.subRegionByType?.code !=
                  _customerAddress.address?.wardCode);
        }
        if (_isChanged || isDifferentRegion) {
          _customerCubit.updateCustomerAddressV1(input: _customerAddress);
        } else {
          context.navigator.pop(_customerAddress.address);
        }

        break;
      default:
        break;
    }
  }
}

class _CountrySelectorField extends StatelessWidget {
  final String selectedCountry;
  const _CountrySelectorField({required this.selectedCountry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 16.w),
      height: 40.h,
      decoration: BoxDecoration(
        color: AppColors.greyC0.withValues(alpha: 0.3),
        borderRadius: .circular(8.r),
        border: .all(color: AppColors.greyC0),
      ),
      child: RowWidget(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            selectedCountry,
            style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.grey84),
          ),
          Icon(Icons.keyboard_arrow_down, color: AppColors.greyC0, size: 18.sp),
        ],
      ),
    );
  }
}
