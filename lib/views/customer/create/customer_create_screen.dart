import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/dto/customer/create_customer_input.dart';
import 'package:zili_coffee/data/repositories/payment_repository.dart';

import '../../../bloc/address/address_cubit.dart';
import '../../../bloc/customer/customer_cubit.dart';
import '../../../data/models/address/region.dart';
import '../../../data/models/order/payment_detail/seller_payment_method.dart';
import '../../../data/models/user/customer_group.dart';
import '../../../data/models/user/staff.dart';
import '../../../data/models/payment/collaborator.dart';
import '../../../data/repositories/address_repository.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../data/repositories/collaborator_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/formatters/export.dart';
import '../../../utils/widgets/widgets.dart';
import '../../../views/common/input_form_field.dart';
import '../../common/bottom_scaffold_button.dart';
import '../../common/date_selector_field.dart';
import '../../common/radio_button.dart';
import '../../common/selector_form_field.dart';

part 'components/additional_information_section.dart';
part 'components/advanced_settings_section.dart';
part 'components/information_section.dart';
part 'components/log_section.dart';

class CustomerCreateScreen extends StatefulWidget {
  const CustomerCreateScreen({super.key});
  static String keyName = '/customer-create';
  @override
  State<CustomerCreateScreen> createState() => _CustomerCreateScreenState();
}

class _CustomerCreateScreenState extends State<CustomerCreateScreen> {
  final CustomerCubit _customerCubit = di<CustomerCubit>();
  final _formKey = GlobalKey<FormState>();

  // Controllers for information section
  final _nameController = TextEditingController();
  final _codeController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _invoiceAddressController = TextEditingController();
  final _noteController = TextEditingController();
  final _taxCodeController = TextEditingController();
  final _faxCodeController = TextEditingController();
  final _discountController = TextEditingController();
  final _websiteController = TextEditingController();
  final _currentDebtController = TextEditingController();
  final _totalSpendingController = TextEditingController();

  // Form field keys for information section
  final _nameFieldKey = GlobalKey<FormFieldState>();
  final _codeFieldKey = GlobalKey<FormFieldState>();
  final _phoneFieldKey = GlobalKey<FormFieldState>();
  final _emailFieldKey = GlobalKey<FormFieldState>();
  final _addressFieldKey = GlobalKey<FormFieldState>();
  final _descriptionFieldKey = GlobalKey<FormFieldState>();
  final _discountFieldKey = GlobalKey<FormFieldState>();
  final _deliveryAddressFieldKey = GlobalKey<FormFieldState>();
  final _invoiceAddressFieldKey = GlobalKey<FormFieldState>();
  final _noteFieldKey = GlobalKey<FormFieldState>();
  final _taxCodeFieldKey = GlobalKey<FormFieldState>();
  final _faxCodeFieldKey = GlobalKey<FormFieldState>();
  final _websiteFieldKey = GlobalKey<FormFieldState>();
  final _currentDebtFieldKey = GlobalKey<FormFieldState>();
  final _totalSpendingFieldKey = GlobalKey<FormFieldState>();

  // Selector
  CustomerGroup? _selectedCustomerGroup;
  Region? _selectedProvince;
  Region? _selectedWard;
  Staff? _selectedStaff;
  Collaborator? _selectedCollaborator;
  SellerPaymentMethod? _selectedPaymentMethod;

  // Additional information
  DateTime? _birthday;
  Gender? _gender;
  String? _discountType;
  String? _defaultPriceType;

  bool _canAddAdditionalInformation = false;
  bool _showManagerInformation = false;
  bool _showAdvancedSettings = false;

  @override
  void dispose() {
    _nameController.dispose();
    _codeController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _deliveryAddressController.dispose();
    _invoiceAddressController.dispose();
    _noteController.dispose();
    _taxCodeController.dispose();
    _faxCodeController.dispose();
    _discountController.dispose();
    _websiteController.dispose();
    _currentDebtController.dispose();
    _totalSpendingController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final CreateCustomerInput input = CreateCustomerInput(
      fullName: _nameController.text,
      code: _codeController.text,
      phone: _phoneController.text,
      email: _emailController.text,
      address: _selectedProvince?.code != null && _selectedWard?.code != null
          ? CreateCustomerAddressInput(
              isDefault: true,
              address: _addressController.text,
              provinceCode: _selectedProvince?.code,
              wardCode: _selectedWard?.code,
            )
          : null,
    );
    // TODO: Thêm các trường còn lại vào input
    _customerCubit.createCustomer(input: input);
  }

  void _onCustomerGroupSelected(CustomerGroup? group) {
    setState(() {
      _selectedCustomerGroup = group;
    });
  }

  void _onProvinceSelected(Region? province) {
    setState(() {
      _selectedProvince = province;
    });
    di<AddressCubit>().getWardsByType(
      districtCode: province?.code ?? '',
      type: .postMerger,
    );
  }

  void _onWardSelected(Region? ward) {
    setState(() {
      _selectedWard = ward;
    });
  }

  void _onStaffSelected(Staff? staff) {
    setState(() {
      _selectedStaff = staff;
    });
  }

  void _onCollaboratorSelected(Collaborator? collaborator) {
    setState(() {
      _selectedCollaborator = collaborator;
    });
  }

  void _onPaymentMethodSelected(SellerPaymentMethod? paymentMethod) {
    setState(() {
      _selectedPaymentMethod = paymentMethod;
    });
  }

  void _onDefaultPriceTypeChanged(String type) {
    setState(() {
      _defaultPriceType = type;
    });
  }

  void _onDiscountTypeChanged(String type) {
    setState(() {
      _discountType = type;
    });
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
            ..navigator.pop();
        } else if (state is FailedCustomerState) {
          context.hideLoading();
          CustomSnackBarWidget(
            context,
            type: CustomSnackBarType.error,
            message: "Tạo khách hàng thất bại",
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Tạo khách hàng',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
          onBack: () {
            final messenger = ScaffoldMessenger.of(context);
            messenger.clearSnackBars();
            context.navigator.pop();
          },
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: ColumnWidget(
              padding: .symmetric(vertical: 16.h),
              gap: 20.h,
              children: [
                _InformationSection(
                  nameController: _nameController,
                  nameFieldKey: _nameFieldKey,
                  codeController: _codeController,
                  codeFieldKey: _codeFieldKey,
                  phoneController: _phoneController,
                  phoneFieldKey: _phoneFieldKey,
                  emailController: _emailController,
                  emailFieldKey: _emailFieldKey,
                  addressController: _addressController,
                  addressFieldKey: _addressFieldKey,
                  selectedCustomerGroup: _selectedCustomerGroup,
                  onCustomerGroupSelected: _onCustomerGroupSelected,
                  selectedProvince: _selectedProvince,
                  onProvinceSelected: _onProvinceSelected,
                  selectedWard: _selectedWard,
                  onWardSelected: _onWardSelected,
                ),
                _AdditionalInformationSection(
                  show: _canAddAdditionalInformation,
                  onAdd: () => setState(
                    () => _canAddAdditionalInformation =
                        !_canAddAdditionalInformation,
                  ),
                  deliveryAddressController: _deliveryAddressController,
                  deliveryAddressFieldKey: _deliveryAddressFieldKey,
                  invoiceAddressController: _invoiceAddressController,
                  invoiceAddressFieldKey: _invoiceAddressFieldKey,
                  noteController: _noteController,
                  noteFieldKey: _noteFieldKey,
                  taxCodeController: _taxCodeController,
                  taxCodeFieldKey: _taxCodeFieldKey,
                  faxCodeController: _faxCodeController,
                  faxCodeFieldKey: _faxCodeFieldKey,
                  birthday: _birthday,
                  websiteController: _websiteController,
                  websiteFieldKey: _websiteFieldKey,
                  currentDebtController: _currentDebtController,
                  currentDebtFieldKey: _currentDebtFieldKey,
                  totalSpendingController: _totalSpendingController,
                  totalSpendingFieldKey: _totalSpendingFieldKey,
                  onBirthdayChanged: (date) => setState(() => _birthday = date),
                  gender: _gender,
                  onGenderChanged: (gender) => setState(() => _gender = gender),
                ),
                _ManagerInformationSection(
                  show: _showManagerInformation,
                  onAdd: () => setState(
                    () => _showManagerInformation = !_showManagerInformation,
                  ),
                  selectedStaff: _selectedStaff,
                  onStaffSelected: _onStaffSelected,
                  selectedCollaborator: _selectedCollaborator,
                  onCollaboratorSelected: _onCollaboratorSelected,
                  descriptionController: _descriptionController,
                  descriptionFieldKey: _descriptionFieldKey,
                ),
                _AdvancedSettingsSection(
                  show: _showAdvancedSettings,
                  onAdd: () => setState(
                    () => _showAdvancedSettings = !_showAdvancedSettings,
                  ),
                  discountType: _discountType,
                  onDiscountTypeChanged: _onDiscountTypeChanged,
                  selectedPaymentMethod: _selectedPaymentMethod,
                  onPaymentMethodSelected: _onPaymentMethodSelected,
                  defaultPriceType: _defaultPriceType,
                  onDefaultPriceTypeChanged: _onDefaultPriceTypeChanged,
                  discountController: _discountController,
                  discountFieldKey: _discountFieldKey,
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomScaffoldButton(onTap: _onSave, label: 'Lưu'),
      ),
    );
  }
}
