import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../../bloc/order/order_cubit.dart';
import '../../../data/models/order/payment_detail/bank_info.dart';
import '../../../data/models/quotation/quotation.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/repositories/payment_repository.dart';
import '../../../data/repositories/setting_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../services/common_service.dart';
import '../../../utils/enums.dart';
import '../../../utils/enums/order_enum.dart';
import '../../../utils/functions/order_function.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/expandable_customer_info.dart';
import '../../common/order_line_item_card.dart';
import '../../common/section_card.dart';
import '../../common/status_badge.dart';

import 'components/bottom_action_view.dart';
import 'components/payment_list.dart';
import 'components/price_summary.dart';
import 'components/top_action_view.dart';

class QuotationDetailsScreen extends StatefulWidget {
  final String code;
  final String? statusString;
  final String? currentKeyword;
  const QuotationDetailsScreen({
    super.key,
    required this.code,
    this.currentKeyword,
    this.statusString,
  });
  static const routeName = "/quotation-details";

  @override
  State<QuotationDetailsScreen> createState() => _QuotationDetailsScreenState();
}

class _QuotationDetailsScreenState extends State<QuotationDetailsScreen> {
  final OrderCubit _cubit = di<OrderCubit>();
  final CommonService _commonService = di<CommonService>();
  final PaymentRepository _paymentRepository = di<PaymentRepository>();
  final SettingRepository _settingRepository = di<SettingRepository>();
  final AuthRepository _authRepository = di<AuthRepository>();
  Quotation? _quotation;

  @override
  initState() {
    super.initState();
    if (_settingRepository.reasonsValue.isEmpty) {
      _commonService.getRejectedQuoteReasons();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cubit.getDetailsQuotation(widget.code);
    });
  }

  bool get _isAccountant => _authRepository.currentAuth?.isAccountant ?? false;

  bool get _isQuoteOwner =>
      _authRepository.currentAuth?.customer?.id ==
      _quotation?.quotationCreatedBy?.id;

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _cubit,
      listener: (context, state) {
        switch (state) {
          case LoadingOrderState():
            context.showLoading();
            break;
          case LoadedOrderState<Quotation>():
            context.hideLoading();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (state.data != null && mounted) {
                setState(() {
                  _quotation = state.data;
                });
              }
            });
            break;
          case LoadedOrderState<String>():
            _cubit.getDetailsQuotation(widget.code);
            _cubit.getQuotations(
              keyword: widget.currentKeyword,
              status: widget.statusString,
            );
            CustomSnackBarWidget(
              context,
              message: state.data ?? "Thao tác thành công!",
              type: .success,
            ).show();
            context.hideLoading();
            break;
          case ErrorOrderState<String>():
            context.hideLoading();
            if (state.detail == AppConstant.strings.notFound) {
              CustomSnackBarWidget(
                context,
                message: "Không tìm thấy thông tin phiếu!",
                type: .error,
              ).show();
              context.navigator.pop();
            } else {
              CustomSnackBarWidget(
                context,
                message: state.detail ?? "Thao tác thất bại!",
                type: .error,
              ).show();
            }
            break;
          default:
            context.hideLoading();
        }
      },
      child: Scaffold(
        appBar: AppBarWidget.lightAppBar(
          context,
          label: widget.code,
          elevation: 1,
          shadowColor: AppColors.black.withValues(alpha: 0.5),
          actions: [
            TopActionView(
              isAccountant: _isAccountant,
              isQuoteOwner: _isQuoteOwner,
              quotation: _quotation,
            ),
          ],
        ),
        backgroundColor: AppColors.background,
        body: CommonLoadMoreRefreshWrapper.refresh(
          context,
          onRefresh: () async {
            await _cubit.getDetailsQuotation(widget.code);
          },
          child: SingleChildScrollView(
            padding: .only(bottom: 24.h),
            child: _buildQuotationDetails(context),
          ),
        ),
        bottomNavigationBar: BottomActionView(
          isAccountant: _isAccountant,
          isQuoteOwner: _isQuoteOwner,
          quotation: _quotation,
          cubit: _cubit,
        ),
      ),
    );
  }

  Widget _buildQuotationDetails(BuildContext context) {
    return ColumnWidget(
      margin: .symmetric(vertical: 16.h),
      crossAxisAlignment: .start,
      gap: 12.h,
      children: [
        SectionCard(
          title: 'Thông tin báo giá',
          trailingOfTitle: _quotation?.status == QuoteStatus.rejected.toConstant
              ? Tooltip(
                  richMessage: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Lý do từ chối:\n',
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          height: 20 / 12,
                          color: AppColors.cancel,
                        ),
                      ),
                      TextSpan(
                        text:
                            _quotation?.rejectedNote ??
                            _quotation?.rejectedReason?.valueVi ??
                            _quotation?.rejectedReason?.valueEn ??
                            "Chưa có lý do từ chối",
                        style: AppStyles.text.medium(
                          fSize: 12.sp,
                          height: 14 / 12,
                          color: AppColors.black3,
                        ),
                      ),
                    ],
                  ),
                  triggerMode: .tap,
                  padding: .all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: .circular(8.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.black.withValues(alpha: 0.12),
                        blurRadius: 4.r,
                        offset: .new(0, 2),
                      ),
                    ],
                  ),
                  textStyle: AppStyles.text.medium(
                    fSize: 12.sp,
                    color: AppColors.cancel,
                  ),
                  enableTapToDismiss: true,
                  showDuration: const Duration(seconds: 180),
                  constraints: BoxConstraints(maxWidth: 160),
                  verticalOffset: 12,
                  margin: .only(right: 12),
                  child: StatusBadge(
                    label:
                        renderQuoteStatus(_quotation?.quoteStatus) ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    color:
                        quoteStatusColor(_quotation?.quoteStatus) ??
                        AppColors.grey84,
                    decorateIcon: Icons.arrow_drop_down,
                  ),
                )
              : StatusBadge(
                  label:
                      renderQuoteStatus(_quotation?.quoteStatus) ??
                      AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  color:
                      quoteStatusColor(_quotation?.quoteStatus) ??
                      AppColors.grey84,
                ),
          child: ColumnWidget(
            crossAxisAlignment: .start,
            gap: 12.h,
            children: [
              RowWidget(
                gap: 4.w,
                children: [
                  Text(
                    'Bán tại:',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black5,
                    ),
                  ),
                  Text(
                    _quotation?.warehouse?.name ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
              RowWidget(
                gap: 4.w,
                children: [
                  Text(
                    'Nhân viên bán hàng:',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black5,
                    ),
                  ),
                  Text(
                    _quotation?.quotationCreatedBy?.fullName ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
              RowWidget(
                gap: 4.w,
                children: [
                  Text(
                    'Ngày tạo:',
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.black5,
                    ),
                  ),
                  Text(
                    _quotation?.quotationCreatedAt?.csToString(
                          TimeFormat.hhmmddMMyyyy.value,
                        ) ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
              Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
              ...(_quotation?.orderLineItems ?? []).map(
                (e) =>
                    (_quotation?.templateCode ==
                        QuoteMailType.quantityQuote.toConstant)
                    ? QuantityQuoteLineItemCard(
                        data: e,
                        quantityOpts: _quotation?.headerQuantities ?? [],
                      )
                    : OrderLineItemCard(data: e),
              ),
              if (_quotation?.templateCode !=
                  QuoteMailType.quantityQuote.toConstant) ...[
                Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
                if (_quotation != null) PriceSummary(quotation: _quotation!),
              ],
            ],
          ),
        ),
        SectionCard(
          title: 'Khách hàng',
          child: Column(
            crossAxisAlignment: .start,
            children: [
              if (_quotation?.customer != null)
                ExpandableCustomerInfo(
                  customer: _quotation!.customer!,
                  viewMode: (true, true, false),
                ),
            ],
          ),
        ),
        SectionCard(
          title: 'Phương thức thanh toán',
          trailingOfTitle: _quotation?.quotationPayment != null && _isAccountant
              ? InkWell(
                  onTap: () => _showBankingSelection(context),
                  child: RowWidget(
                    gap: 4.w,
                    children: [
                      Icon(
                        Icons.mode_edit_outline_rounded,
                        size: 16.sp,
                        color: AppColors.primary,
                      ),
                      Text(
                        'Thay đổi',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                )
              : null,
          child: PaymentSections(payment: _quotation?.quotationPayment),
        ),
        SectionCard(
          title: 'Ghi chú báo giá',
          child: Container(
            padding: .symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: .circular(8.r),
            ),
            child: Html(
              data: _quotation?.note ?? "Chưa có ghi chú",
              style: {"*": Style(fontSize: FontSize(12), textAlign: .start)},
            ),
          ),
        ),
      ],
    );
  }

  void _showBankingSelection(BuildContext context) async {
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
            title: 'Chọn ngân hàng',
            onClose: context.navigator.pop,
          ),
          StreamBuilder<List<BankInfo>>(
            stream: _paymentRepository.bankingMethods.stream,
            builder: (modalContext, snapshot) {
              final List<BankInfo?> bankingMethods = snapshot.data ?? [];
              return Container(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: .symmetric(vertical: 16.h),
                  itemCount: bankingMethods.length,
                  clipBehavior: .hardEdge,
                  itemBuilder: (context, index) {
                    final isSelected =
                        _quotation?.quotationPayment?.code ==
                        bankingMethods[index]?.code;
                    return BottomSheetListItem(
                      leading: Text(
                        bankingMethods[index]?.bankCode ?? '',
                        style: AppStyles.text.semiBold(
                          fSize: 12.sp,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.grey84,
                        ),
                      ),
                      title: (bankingMethods[index]?.displayName ?? ''),
                      isSelected: isSelected,
                      onTap: () {
                        if (bankingMethods[index] != null) {
                          _cubit
                              .updateQuotationPayment(
                                widget.code,
                                bankingMethods[index]!,
                              )
                              .then((value) {
                                if (value) {
                                  setState(() {
                                    _quotation!.quotationPayment =
                                        bankingMethods[index]!;
                                  });
                                  if (modalContext.mounted) {
                                    modalContext.navigator.maybePop();
                                  }
                                }
                              });
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
  }
}
