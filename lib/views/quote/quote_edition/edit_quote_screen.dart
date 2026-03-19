import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_editor_enhanced/html_editor.dart';

import 'package:zili_coffee/views/common/shimmer_view.dart';

import '../../../bloc/customer/customer_cubit.dart';
import '../../../bloc/order/order_cubit.dart';
import '../../../data/dto/quotation/create_quotation.dart';
import '../../../data/models/order/payment_detail/bank_info.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../services/common_service.dart';
import '../../../utils/enums/order_enum.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/helpers/order_helper.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/creation_components/export.dart';
import '../../common/creation_components/products_sections/quotation_products_section.dart';
import '../details/quotation_details_screen.dart';
import '../manage_quotations/quotations_management_screen.dart';
import '../request_quote_creation/components/quotation_type_selector.dart';

part 'components/additional_info_section.dart';
part 'components/bank_section.dart';
part 'components/bottom_action_bar.dart';

class QuotationEditionScreen extends StatefulWidget {
  final CreateQuotationInput? input;
  final String code;
  const QuotationEditionScreen({super.key, this.input, required this.code});
  static String keyName = '/edit-quotation';

  @override
  State<QuotationEditionScreen> createState() => _QuotationEditionScreenState();
}

class _QuotationEditionScreenState extends State<QuotationEditionScreen> {
  // ** State managers - controllers.
  final OrderCubit _orderCubit = di<OrderCubit>();
  final CustomerCubit _customerCubit = di<CustomerCubit>();

  // ** States
  final TextEditingController _noteController = TextEditingController();
  final FocusNode _noteFocusNode = FocusNode(canRequestFocus: false);
  bool _allowBack = true;
  // ** Fields data
  late final CreateQuotationInput _createQuotationInput;

  @override
  void initState() {
    super.initState();
    if (widget.input != null) {
      _createQuotationInput = widget.input!;
      _fetchCustomerAddress();
      _allowBack = false;
      log("widget.input: ${widget.input}");
    } else {
      _createQuotationInput = CreateQuotationInput(
        order: OrderQuotation(products: []),
        infoAdditionalQuotation: InfoAdditionalQuotation(),
      );
    }
  }

  void _fetchCustomerAddress() {
    if ((_createQuotationInput.customer?.id).isNotNull) {
      _customerCubit
          .getDefaultCustomerAddress(_createQuotationInput.customer!.id)
          .then((value) {
            if (value != null) {
              _createQuotationInput.customer!.purchaseAddress = value;
              _createQuotationInput.customer!.billingAddress = value;
            }
          });
    }
  }

  void _preventBack() => _allowBack = false;

  double _getTotalAmount(List<OrderQuotationProducts> products) {
    final totalProductPrice = calculateProductPrice(products);
    final orderDiscount = calculateOrderDiscount(
      totalProductPrice,
      _createQuotationInput.order?.discount?.toDouble() ?? 0,
      'đ',
    );
    final netAfterDiscount = (totalProductPrice - orderDiscount)
        .clamp(0, double.infinity)
        .toDouble();
    final orderVat = calculateOrderTax(
      totalProductPrice,
      _createQuotationInput.order?.vat?.toDouble() ?? 0,
      'đ',
    );
    final totalAmount =
        netAfterDiscount +
        orderVat +
        (_createQuotationInput.order?.deliveryFee?.toDouble() ?? 0);

    return totalAmount;
  }

  @override
  dispose() {
    _noteController.dispose();
    _noteFocusNode.dispose();
    super.dispose();
  }

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
            label: 'Chỉnh sửa báo giá: ${widget.code}',
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
                  branch: _createQuotationInput.salesBranch,
                  onChange: (br) {
                    _createQuotationInput.setSalesBranch(br);
                    setState(() {});
                  },
                ),
                QuotationTypeSection(
                  type: _createQuotationInput.mailType,
                  onMailTypeChanged: (mailType, quantityOpts, notes) {
                    if (mailType == _createQuotationInput.mailType) {
                      _createQuotationInput.notes = notes;
                      setState(() {});
                    } else {
                      if (quantityOpts != _createQuotationInput.quantityOpts) {
                        _createQuotationInput.replaceProductsByQuantityOpts(
                          quantityOpts,
                        );
                      }
                      setState(() {
                        _createQuotationInput.mailType = mailType;
                        _createQuotationInput.quantityOpts = quantityOpts;
                        _createQuotationInput.notes = notes;
                      });
                    }
                  },
                ),
                CustomerSection(
                  customer: _createQuotationInput.customer,
                  ignoreChangeCustomer: true,
                  showOptions: (true, true, false),
                  updateCustomer: (customer) {
                    _preventBack();
                    _createQuotationInput.setCustomer(customer);
                    setState(() {});
                  },
                ),
                if (_createQuotationInput.mailType == .quantityQuote)
                  QuotationProductVariantsSection(
                    branchId: _createQuotationInput.salesBranch?.id,
                    initPriceType: _createQuotationInput
                        .infoAdditionalQuotation
                        ?.salesType,
                    manageByQuantity:
                        _createQuotationInput.mailType == .quantityQuote,
                    quantityOpts: _createQuotationInput.quantityOpts ?? [],
                    productVariants:
                        _createQuotationInput.order?.products ?? [],
                    onAddProductVariants: (productVariants) {
                      _preventBack();
                      _createQuotationInput.addProducts(productVariants);
                      setState(() {});
                    },
                    onUpdateProductVariant: (productVariant) {
                      _createQuotationInput.updateProduct(productVariant);
                      setState(() {});
                    },
                    onRemoveProductVariant: (productVariant) {
                      _createQuotationInput.removeProduct(
                        productVariant.toOrderQuotationProducts(),
                      );
                      setState(() {});
                    },
                    onChangePriceType: (priceType) {
                      if (_createQuotationInput
                              .infoAdditionalQuotation
                              ?.salesType ==
                          priceType) {
                        return;
                      }
                      _createQuotationInput.infoAdditionalQuotation?.salesType =
                          priceType;
                      _createQuotationInput.order?.products.forEach((product) {
                        final priceBySalesType = priceType == .wholesalePrice
                            ? product.productVariant?.wholesalePrice ?? 0
                            : product.productVariant?.price ?? 0;
                        product.price = priceBySalesType;
                        if (product.discountUnit == '%') {
                          product.discount =
                              product.price *
                              (product.discountPercent ?? 0) /
                              100;
                        }
                        product.priceList = List.generate(
                          product.priceList?.length ?? 0,
                          (_) => priceBySalesType,
                        );
                      });
                      setState(() {});
                    },
                  )
                else
                  ProductVariantsSection(
                    branchId: _createQuotationInput.salesBranch?.id,
                    initPriceType: _createQuotationInput
                        .infoAdditionalQuotation
                        ?.salesType,
                    productVariants:
                        _createQuotationInput.order?.products ?? [],
                    onAddProductVariants: (productVariants) {
                      _preventBack();
                      _createQuotationInput.addProducts(productVariants);
                      setState(() {});
                    },
                    onUpdateProductVariant: (productVariant, {index}) {
                      if (index != null) {
                        _createQuotationInput.updateServiceProduct(
                          index,
                          productVariant.toOrderQuotationProducts(),
                        );
                      } else {
                        _createQuotationInput.updateProduct(
                          productVariant.toOrderQuotationProducts(),
                        );
                      }
                      setState(() {});
                    },
                    onRemoveProductVariant: (productVariant, {index}) {
                      if (index != null) {
                        _createQuotationInput.removeServiceProduct(index);
                      } else {
                        _createQuotationInput.removeProduct(
                          productVariant.toOrderQuotationProducts(),
                        );
                      }
                      setState(() {});
                    },
                    onChangePriceType: (priceType) {
                      if (_createQuotationInput
                              .infoAdditionalQuotation
                              ?.salesType ==
                          priceType) {
                        return;
                      }
                      _createQuotationInput.infoAdditionalQuotation?.salesType =
                          priceType;
                      _createQuotationInput.order?.products.forEach((product) {
                        product.price = priceType == .wholesalePrice
                            ? product.productVariant?.wholesalePrice ?? 0
                            : product.productVariant?.price ?? 0;
                        if (product.discountUnit == '%') {
                          product.discount =
                              product.price *
                              (product.discountPercent ?? 0) /
                              100;
                        }
                      });
                      setState(() {});
                    },
                  ),
                ExpandableWidget(
                  initiallyExpanded:
                      _createQuotationInput.mailType != .quantityQuote,
                  expandedChildren: [
                    CostPaymentSection(
                      props: CostPaymentProps(
                        totalProductPrice: calculateProductPrice(
                          _createQuotationInput.order?.products ?? [],
                        ),
                        totalQuantity:
                            (_createQuotationInput.order?.products ?? [])
                                .fold<num>(
                                  0,
                                  (sum, variant) => sum + variant.qty,
                                ),
                        discount:
                            _createQuotationInput.order?.discount?.toDouble() ??
                            0,
                        discountPercent:
                            _createQuotationInput.order?.discountPercent,
                        discountUnit:
                            _createQuotationInput.order?.discountUnit ?? 'đ',
                        vat: _createQuotationInput.order?.vat?.toDouble() ?? 0,
                        vatPercent: _createQuotationInput.order?.vatPercent,
                        vatUnit: _createQuotationInput.order?.vatUnit ?? 'đ',
                        shippingFee:
                            _createQuotationInput.order?.deliveryFee
                                ?.toDouble() ??
                            0,
                      ),
                      onDiscountChanged:
                          (value, valuePercent, discountUnit, discountReason) {
                            setState(() {
                              _createQuotationInput.setQuotationDiscount(
                                value,
                                valuePercent,
                                discountUnit,
                                discountReason,
                              );
                            });
                          },
                      onTaxChanged: (value, valuePercent, taxUnit) {
                        setState(() {
                          _createQuotationInput.setQuotationVat(
                            value,
                            valuePercent,
                            taxUnit,
                          );
                        });
                      },
                      onShippingFeeChanged: (value) {
                        setState(() {
                          _createQuotationInput.setQuotationDeliveryFee(value);
                        });
                      },
                    ),
                  ],
                ),
                _BankSection(
                  payment: _createQuotationInput.payment,
                  onPaymentChanged: (value) {
                    setState(() {
                      _createQuotationInput.payment = value;
                    });
                  },
                ),
                _AdditionalSection(
                  notes: _createQuotationInput.notes,
                  // mailType: _createQuotationInput.mailType,
                  onNotesChanged: (value) {
                    setState(() {
                      _createQuotationInput.notes = value;
                    });
                  },
                  // onMailTypeChanged: (value, opts) {
                  //   if (value == _createQuotationInput.mailType) return;
                  //   setState(() {
                  //     _createQuotationInput.mailType = value;
                  //     _createQuotationInput.quantityOpts = opts;
                  //   });
                  //   if (opts != _createQuotationInput.quantityOpts) {
                  //     _createQuotationInput.replaceProductsByQuantityOpts(opts);
                  //   }
                  // },
                ),
                SizedBox(height: 120.h), // Space for bottom bar
              ],
            ),
          ),
          extendBody: true,
          bottomNavigationBar: _BottomActionBar(
            totalAmount: _getTotalAmount(
              _createQuotationInput.order?.products ?? [],
            ),
            onConfirm: () {
              final result = _createQuotationInput.validate();
              if (result != null) {
                CustomSnackBarWidget(
                  context,
                  message: result,
                  type: .error,
                ).show();
              } else {
                _orderCubit.editQuotation(widget.code, _createQuotationInput);
              }
            },
            onExit: () {
              _popInvoked(context, _allowBack);
            },
            quotationType: _createQuotationInput.mailType,
          ),
        ),
      ),
    );
  }

  void _listener(BuildContext context, OrderState state) {
    if (state is LoadingOrderState) {
      context.showLoading();
    } else if (state is LoadedOrderState<String?>) {
      context.hideLoading();
      CustomSnackBarWidget(
        context,
        message: "Chỉnh sửa báo giá thành công!",
        type: .success,
      ).show();
      if (state.data != null) {
        context.navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => QuotationDetailsScreen(code: state.data!),
          ),
          (route) =>
              route.isFirst ||
              route.settings.name == QuotationsManagementScreen.keyName,
        );
      } else {
        context.navigator.pop();
      }
    } else if (state is ErrorOrderState) {
      context.hideLoading();
      CustomSnackBarWidget(
        context,
        message: state.error ?? "Chỉnh sửa phiếu báo giá thất bại!",
        type: .error,
      ).show();
    }
  }

  void _popInvoked(BuildContext context, bool didPop) {
    if (!didPop) {
      showNoticeDialog(
        context: context,
        title: 'Rời trang?',
        message: 'Thông tin báo giá sản phẩm sẽ mất, xác nhận để rời trang.',
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
}
