import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../app/app_wireframe.dart';
import '../../../bloc/collaborator/collaborator_cubit.dart';
import '../../../bloc/customer/customer_cubit.dart';
import '../../../bloc/order/order_cubit.dart';
import '../../../bloc/setting/setting_cubit.dart';
import '../../../data/dto/order/create_order.dart';
import '../../../data/models/payment/collaborator.dart';
import '../../../data/models/user/staff.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/collaborator_repository.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../data/repositories/setting_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/helpers/order_helper.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/creation_components/export.dart';
import '../../common/input_form_field.dart';

part 'components/additional_info_section.dart';
part 'components/bottom_action_bar.dart';
part 'components/delivery_methods.dart';

class CreateOrderScreen extends StatefulWidget {
  final CreateOrderDTO? input;
  const CreateOrderScreen({super.key, this.input});
  static String keyName = '/create-order';

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> {
  // ** State managers - controllers.
  final OrderCubit _orderCubit = di<OrderCubit>();
  final CustomerCubit _customerCubit = di<CustomerCubit>();

  // ** Data stores
  final AuthRepository _authRepository = di<AuthRepository>();
  final CustomerRepository _customerRepository = di<CustomerRepository>();
  final SettingRepository _settingRepository = di<SettingRepository>();
  // ** States
  TextEditingController noteController = TextEditingController();
  final FocusNode noteFocusNode = FocusNode(canRequestFocus: false);
  final GlobalKey<FormFieldState> noteFieldKey = GlobalKey<FormFieldState>();
  bool _allowBack = true;
  // ** Fields data
  CreateOrderDTO _createOrderDTO = CreateOrderDTO("");

  @override
  void initState() {
    super.initState();
    final companyOfUser = _authRepository.currentUser?.company;
    if (companyOfUser.isNull) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          CustomSnackBarWidget(
            context,
            type: .error,
            message: 'Thông tin người dùng không hợp lệ!',
          ).show();
          context.navigator.pop();
        }
      });
      _createOrderDTO = CreateOrderDTO("");
    } else if (widget.input.isNotNull) {
      _createOrderDTO = widget.input!;
      _createOrderDTO.order.companyId = companyOfUser!.id;
      _fetchCustomerAddress();
      _allowBack = false;
    } else {
      _createOrderDTO = CreateOrderDTO(companyOfUser!.id);
    }

    _loadInitialData();
  }

  void _fetchCustomerAddress() {
    if ((_createOrderDTO.customer?.id).isNotNull) {
      _customerCubit
          .getDefaultCustomerAddress(_createOrderDTO.customer!.id)
          .then((value) {
            if (value != null) {
              _createOrderDTO.customer!.purchaseAddress = value;
              _createOrderDTO.customer!.billingAddress = value;
            }
          });
    }
  }

  void _loadInitialData() {
    _customerCubit.getActiveStaffs(aboutMe: true).then((value) {
      final activeStaffs = _customerRepository.activeStaffs.valueOrNull ?? [];
      if (activeStaffs.isNotEmpty) {
        final me = _authRepository.currentUser;
        final staff = activeStaffs.firstWhere(
          (st) => st.id == me?.id,
          orElse: () => activeStaffs.first,
        );
        if (staff.isNotNull) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _createOrderDTO.setStaff(staff);
            setState(() {});
          });
        }
      }
    });

    di<SettingCubit>().getSaleChannels().then((value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_settingRepository.saleChannelsValue.isNotEmpty) {
          _createOrderDTO.setSaleChannel(
            _settingRepository.saleChannelsValue.first,
          );
          setState(() {});
        }
      });
    });

    di<CollaboratorCubit>().fetchCollaborators();
  }

  double _getTotalAmount(List<CreateOrderInfoProd> products) {
    final totalProductPrice = calculateProductPrice(products);
    final orderDiscount = calculateOrderDiscount(
      totalProductPrice,
      _createOrderDTO.order.discount?.toDouble() ?? 0,
      'đ',
    );
    final netAfterDiscount = (totalProductPrice - orderDiscount)
        .clamp(0, double.infinity)
        .toDouble();
    final orderVat = calculateOrderTax(
      totalProductPrice,
      _createOrderDTO.order.vat?.toDouble() ?? 0,
      'đ',
    );
    final totalAmount =
        netAfterDiscount +
        orderVat +
        (_createOrderDTO.order.deliveryFee?.toDouble() ?? 0);

    // Trừ đi tổng số tiền đã thanh toán từ các phương thức thanh toán
    final totalPaidAmount = _createOrderDTO.paymentDetails
        .where((item) {
          final label = item['paymentMethodEnum'] as String?;
          final value = (item['customerPaid'] as num?)?.toDouble() ?? 0.0;
          return label != null && label.isNotEmpty && value > 0;
        })
        .fold<double>(
          0.0,
          (sum, item) =>
              sum + ((item['customerPaid'] as num?)?.toDouble() ?? 0.0),
        );

    // Số tiền còn lại = Tổng tiền - Tổng số tiền đã thanh toán (không được âm)
    return (totalAmount - totalPaidAmount).clamp(0, double.infinity);
  }

  @override
  dispose() {
    noteController.dispose();
    noteFocusNode.dispose();
    super.dispose();
  }

  void _preventBack() => _allowBack = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _allowBack,
      onPopInvokedWithResult: (didPop, _) => _popInvoked(context, didPop),
      child: BlocListener<OrderCubit, OrderState>(
        bloc: _orderCubit,
        listener: _listener,
        child: Scaffold(
          appBar: AppBarWidget.lightAppBar(
            context,
            label: 'Tạo đơn hàng',
            elevation: 1,
            shadowColor: AppColors.black.withValues(alpha: 0.5),
          ),
          backgroundColor: AppColors.background,
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: ColumnWidget(
              padding: .symmetric(vertical: 8.h),
              gap: 8.h,
              children: [
                BranchSection(
                  branch: _createOrderDTO.infoAdditional.branch,
                  onChange: (br) {
                    _createOrderDTO.infoAdditional.branch = br;
                    setState(() {});
                  },
                ),
                CustomerSection(
                  customer: _createOrderDTO.customer,
                  updateCustomer: (customer) {
                    _preventBack();
                    _createOrderDTO.customer = customer;
                    setState(() {});
                  },
                ),
                ProductVariantsSection(
                  branchId: _createOrderDTO.infoAdditional.branch?.id,
                  initPriceType: _createOrderDTO.infoAdditional.salesType,
                  productVariants: _createOrderDTO.order.products,
                  onAddProductVariants: (productVariants) {
                    _preventBack();
                    _createOrderDTO.addProducts(productVariants);
                    setState(() {});
                  },
                  onUpdateProductVariant: (productVariant, {index}) {
                    if (index != null) {
                      _createOrderDTO.updateServiceProduct(
                        index,
                        productVariant,
                      );
                    } else {
                      _createOrderDTO.updateProduct(productVariant);
                    }
                    setState(() {});
                  },
                  onRemoveProductVariant: (productVariant, {index}) {
                    if (index != null) {
                      _createOrderDTO.removeServiceProduct(index);
                    } else {
                      _createOrderDTO.removeProduct(productVariant);
                    }
                    setState(() {});
                  },
                  onChangePriceType: (priceType) {
                    if (_createOrderDTO.infoAdditional.salesType == priceType) {
                      return;
                    }
                    _createOrderDTO.infoAdditional.salesType = priceType;
                    for (var product in _createOrderDTO.order.products) {
                      product.price = priceType == .wholesalePrice
                          ? product.productVariant?.wholesalePrice ?? 0
                          : product.productVariant?.price ?? 0;
                      if (product.discountUnit == '%') {
                        product.discount =
                            product.price *
                            (product.discountPercent ?? 0) /
                            100;
                      }
                    }
                    setState(() {});
                  },
                ),
                CostPaymentSection(
                  props: CostPaymentProps(
                    totalProductPrice: calculateProductPrice(
                      _createOrderDTO.order.products,
                    ),
                    totalQuantity: _createOrderDTO.order.products.fold<num>(
                      0,
                      (sum, variant) => sum + variant.qty,
                    ),
                    discount: _createOrderDTO.order.discount?.toDouble() ?? 0,
                    discountPercent: _createOrderDTO.order.discountPercent,
                    discountUnit: _createOrderDTO.order.discountUnit ?? 'đ',
                    vat: _createOrderDTO.order.vat?.toDouble() ?? 0,
                    vatPercent: _createOrderDTO.order.vatPercent,
                    vatUnit: _createOrderDTO.order.vatUnit ?? 'đ',
                    shippingFee:
                        _createOrderDTO.order.deliveryFee?.toDouble() ?? 0,
                    isPaid: _createOrderDTO.isPaid,
                  ),
                  onDiscountChanged:
                      (value, valuePercent, discountUnit, discountReason) {
                        _createOrderDTO.setDiscount(
                          value,
                          valuePercent,
                          discountUnit,
                          discountReason,
                        );
                        setState(() {});
                      },
                  onTaxChanged: (value, valuePercent, taxUnit) {
                    _createOrderDTO.setVat(value, valuePercent, taxUnit);
                    setState(() {});
                  },
                  onShippingFeeChanged: (value) {
                    _createOrderDTO.order.deliveryFee = value;
                    setState(() {});
                  },
                  onPaymentStatusChanged: (value) {
                    _createOrderDTO.isPaid = value;
                    setState(() {});
                  },
                  onPaymentDetailsChanged: (details) {
                    _createOrderDTO.paymentDetails = details;
                    setState(() {});
                  },
                ),
                _AdditionalInfoSection(
                  noteController: noteController,
                  noteFocusNode: noteFocusNode,
                  noteFieldKey: noteFieldKey,
                  selectedStaff: _createOrderDTO.staff,
                  selectedCollaborator: _createOrderDTO.collaborator,
                  selectedSource: _createOrderDTO.infoAdditional.saleChannel,
                  deliveryDate:
                      _createOrderDTO.infoAdditional.scheduledDeliveryAt,
                  soldDate: _createOrderDTO.infoAdditional.saleDate,
                  onSourceChanged: (value) {
                    _createOrderDTO.setSaleChannel(value);
                    setState(() {});
                  },
                  onStaffChanged: (value) {
                    _createOrderDTO.setStaff(value);
                    setState(() {});
                  },
                  onCollaboratorChanged: (value) {
                    _createOrderDTO.setCollaborator(value);
                    setState(() {});
                  },
                  onDeliveryDateChanged: (value) {
                    _createOrderDTO.infoAdditional.scheduledDeliveryAt = value;
                    setState(() {});
                  },
                  onSoldDateChanged: (value) {
                    _createOrderDTO.infoAdditional.saleDate = value;
                    setState(() {});
                  },
                ),
                SizedBox(height: 120.h), // Space for bottom bar
              ],
            ),
          ),
          extendBody: true,
          bottomNavigationBar: _BottomActionBar(
            totalAmount: _getTotalAmount(_createOrderDTO.order.products),
            onCreateOrder: () {
              final result = _createOrderDTO.validate();
              if (result != null) {
                CustomSnackBarWidget(
                  context,
                  message: result,
                  type: .error,
                ).show();
              } else {
                _orderCubit.sellerCreateOrder(_createOrderDTO);
              }
            },
          ),
        ),
      ),
    );
  }

  void _popInvoked(BuildContext context, bool didPop) {
    if (!didPop) {
      showNoticeDialog(
        context: context,
        title: 'Rời trang?',
        message: 'Thông tin tạo đơn hàng sẽ mất, xác nhận để rời trang.',
        variant: .confirm,
        secondaryAction: NoticeDialogAction(
          label: 'Hủy',
          onPressed: context.navigator.pop,
        ),
        primaryAction: NoticeDialogAction(
          label: 'Xác nhận',
          onPressed: () {
            setState(() => _allowBack = true);
            context.navigator.maybePop(); // close dialog
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.navigator.pop(); // pop create order screen
            });
          },
          // isDestructive: true,
        ),
      );
    }
  }

  void _listener(BuildContext context, OrderState state) {
    switch (state) {
      case LoadingOrderState():
        context.showLoading();
        break;
      case LoadedOrderState<String?>():
        context.hideLoading();
        if (state.data != null) {
          AppWireFrame.navigateToOrderDetails(
            context,
            code: state.data!,
            replaceCurrentRoute: true,
          );
        } else {
          context.navigator.pop();
        }
        break;
      case ErrorOrderState():
        context.hideLoading();
        CustomSnackBarWidget(
          context,
          message: "Không thể tạo đơn hàng!",
          type: .error,
        ).show();
        break;
    }
  }
}
