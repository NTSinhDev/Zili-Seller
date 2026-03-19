import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/dto/customer_group/create_customer_group_input.dart';
import 'package:zili_coffee/data/repositories/payment_repository.dart';
import 'package:zili_coffee/utils/enums/customer_enum.dart';
import 'package:zili_coffee/utils/formatters/input_field.dart';

import '../../../bloc/address/address_cubit.dart';
import '../../../bloc/customer/customer_cubit.dart';
import '../../../data/models/address/region.dart';
import '../../../data/models/order/payment_detail/seller_payment_method.dart';
import '../../../data/models/user/customer_group.dart';
import '../../../data/models/user/staff.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums.dart';
import '../../../utils/extension/extension.dart';
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

class CustomerGroupCreateScreen extends StatefulWidget {
  final CustomerGroupType type;
  const CustomerGroupCreateScreen({super.key, required this.type});
  static String keyName = '/customer-group-create';
  @override
  State<CustomerGroupCreateScreen> createState() =>
      _CustomerGroupCreateScreenState();
}

class _CustomerGroupCreateScreenState extends State<CustomerGroupCreateScreen> {
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
  final _discountController = TextEditingController();

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

  // Selector
  CustomerGroup? _selectedCustomerGroup;
  Region? _selectedProvince;
  Region? _selectedWard;
  Staff? _selectedStaff;
  SellerPaymentMethod? _selectedPaymentMethod;

  // Additional information
  DateTime? _birthday;
  Gender? _gender;
  String? _discountType;
  String? _defaultPriceType;

  final bool _canAddAdditionalInformation = false;
  final bool _showManagerInformation = false;
  final bool _showAdvancedSettings = false;
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
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Map defaultPriceType from UI values to API values
    String? defaultPrice;
    if (_defaultPriceType == 'RETAIL') {
      defaultPrice = 'RETAIL_PRICE';
    } else if (_defaultPriceType == 'WHOLESALE') {
      defaultPrice = 'WHOLESALE_PRICE';
    } else if (_defaultPriceType == 'INPUT') {
      defaultPrice = 'INPUT';
    }

    // Map CustomerGroupType to API string
    final typeString = widget.type == CustomerGroupType.fixed
        ? 'FIXED'
        : 'AUTOMATIC';

    // Parse discount from controller
    final discountValue = int.tryParse(_discountController.text.trim()) ?? 0;

    // Get payment method enum or name
    final paymentMethodValue =
        _selectedPaymentMethod?.method ?? _selectedPaymentMethod?.nameVi;

    final CreateCustomerGroupInput input = CreateCustomerGroupInput(
      defaultPrice: defaultPrice,
      nameVi: _nameController.text.trim(),
      code: _codeController.text.trim().isNotEmpty
          ? _codeController.text.trim()
          : null,
      descriptionVi: _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : null,
      discount: discountValue > 0 ? discountValue : null,
      paymentMethod: paymentMethodValue,
      type: typeString,
    );

    _customerCubit.createCustomerGroup(input: input);
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
        } else if (state is MessageCustomerState) {
          context
            ..hideLoading()
            ..navigator.pop();
          CustomSnackBarWidget(
            context,
            type: CustomSnackBarType.success,
            message: state.message,
          ).show();
        } else if (state is FailedCustomerState) {
          context.hideLoading();
          CustomSnackBarWidget(
            context,
            type: CustomSnackBarType.error,
            message: "Tạo nhóm khách hàng thất bại",
          ).show();
        }
      },
      child: Scaffold(
        appBar: AppBarWidget.lightAppBar(
          context,
          label: 'Tạo nhóm khách hàng',
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
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
                  descriptionController: _descriptionController,
                  descriptionFieldKey: _descriptionFieldKey,
                ),
                _AdvancedSettingsSection(
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
