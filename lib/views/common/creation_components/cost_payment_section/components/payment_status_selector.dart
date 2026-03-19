part of '../cost_payment_section.dart';

class _PaymentStatusSelector extends StatefulWidget {
  final bool isPaid;
  final double totalAmount;
  final Function(bool) onChanged;
  final Function(List<Map<String, dynamic>>)? onPaymentDetailsChanged;

  const _PaymentStatusSelector({
    required this.isPaid,
    required this.totalAmount,
    required this.onChanged,
    this.onPaymentDetailsChanged,
  });

  @override
  State<_PaymentStatusSelector> createState() => _PaymentStatusSelectorState();
}

class _PaymentStatusSelectorState extends State<_PaymentStatusSelector> {
  final List<Map<String, dynamic>> _paymentDetails = [];

  void _notifyPaymentDetailsChanged() {
    widget.onPaymentDetailsChanged?.call(_paymentDetails);
  }

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      crossAxisAlignment: CrossAxisAlignment.start,
      gap: 8.h,
      children: [
        CommonRadioButtonItem(
          label: 'Thanh toán sau',
          isSelected: !widget.isPaid,
          onSelect: () {
            widget.onChanged(false);
            setState(() {
              _paymentDetails.clear();
              _notifyPaymentDetailsChanged();
            });
          },
        ),
        CommonRadioButtonItem(
          label: 'Đã thanh toán',
          isSelected: widget.isPaid,
          onSelect: () => widget.onChanged(true),
        ),
        if (widget.isPaid) ...[
          InkWell(
            onTap: () {
              final currentTotalAmount =
                  widget.totalAmount -
                  _paymentDetails.fold(
                    0.0,
                    (sum, paymentDetail) =>
                        sum +
                        ((paymentDetail['customerPaid'] as num?)?.toDouble() ??
                            0.0),
                  );
              context.navigator
                  .push(
                    MaterialPageRoute(
                      builder: (context) => PaymentScreen(
                        totalAmount: currentTotalAmount,
                        currentSelectedPayments: _paymentDetails
                            .map(
                              (paymentDetail) =>
                                  paymentDetail['paymentMethod']
                                      as SellerPaymentMethod?,
                            )
                            .whereType<SellerPaymentMethod>()
                            .toList(),
                      ),
                    ),
                  )
                  .then((result) {
                    if (result != null && result is Map<String, dynamic>) {
                      setState(() {
                        _paymentDetails.add(result);
                        _notifyPaymentDetailsChanged();
                      });
                    }
                  });
            },
            child: Container(
              margin: EdgeInsets.only(left: 16.w),
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.add, color: AppColors.primary, size: 20.sp),
                  SizedBox(width: 12.w),
                  Text(
                    'Thêm phương thức thanh toán',
                    style: AppStyles.text.medium(fSize: 14.sp),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.grey84,
                    size: 24.sp,
                  ),
                ],
              ),
            ),
          ),
          // Hiển thị thông tin payment method đã chọn
          if (_paymentDetails.isNotEmpty) ...[
            SizedBox(height: 8.h),
            ..._paymentDetails.asMap().entries.map((entry) {
              final index = entry.key;
              final paymentDetail = entry.value;
              return Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.greyC0),
                ),
                child: RowWidget(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ColumnWidget(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      gap: 4.h,
                      children: [
                        Text(
                          'Phương thức:',
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.grey84,
                          ),
                        ),
                        Text(
                          'Tiền khách đưa:',
                          style: AppStyles.text.medium(
                            fSize: 12.sp,
                            color: AppColors.grey84,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: ColumnWidget(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        gap: 4.h,
                        children: [
                          Text(
                            paymentDetail['paymentMethodName'] as String? ?? '',
                            style: AppStyles.text.semiBold(fSize: 12.sp),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            ((paymentDetail['customerPaid'] as num?)
                                        ?.toDouble() ??
                                    0.0)
                                .toUSD,
                            style: AppStyles.text.semiBold(fSize: 12.sp),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 8.w),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _paymentDetails.removeAt(index);
                          _notifyPaymentDetailsChanged();
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppColors.scarlet.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16.sp,
                          color: AppColors.scarlet,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ],
    );
  }
}

class PaymentScreen extends StatefulWidget {
  final double totalAmount;
  final List<SellerPaymentMethod> currentSelectedPayments;

  const PaymentScreen({
    super.key,
    required this.totalAmount,
    required this.currentSelectedPayments,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

/// Widget để hiển thị icon payment method (hỗ trợ cả SVG và PNG)
class _PaymentMethodIcon extends StatelessWidget {
  final String iconUrl;

  const _PaymentMethodIcon({required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    final iconWidth = 28.sp;
    final iconHeight = 28.sp;

    if (iconUrl.isNull || iconUrl.trim().isEmpty) {
      return Icon(Icons.payment_outlined, size: 24.sp);
    }

    // Kiểm tra extension để quyết định dùng SVG hay Image
    final isSvg = iconUrl.toLowerCase().endsWith('.svg');

    if (isSvg) {
      return FutureBuilder<StringOrBytes?>(
        future: smartSvgOrImageParser(iconUrl),
        builder: (context, snapshot) {
          final data = snapshot.data;

          if (data is StringValue) {
            return SvgPicture.network(
              iconUrl,
              width: 28.sp,
              height: 28.sp,
              fit: BoxFit.contain,
            );
          }

          if (data is BytesValue) {
            return Image.memory(
              data.value,
              width: 28.sp,
              height: 28.sp,
              fit: BoxFit.contain,
            );
          }

          return Icon(Icons.payment_outlined, size: 24.sp);
        },
      );
    }
    return ImageUrlWidget(url: iconUrl, width: iconWidth, height: iconHeight);
  }
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _amountFieldKey = GlobalKey<FormFieldState>();
  late final PaymentCubit _paymentCubit;
  late final PaymentRepository _paymentRepo;
  SellerPaymentMethod? _selectedPaymentMethod;
  final _amountStreamController = StreamController<double>.broadcast();

  @override
  void initState() {
    super.initState();
    _paymentCubit = di<PaymentCubit>();
    _paymentRepo = di<PaymentRepository>();
    _loadPaymentMethods();
    _amountController.addListener(() {
      final amount = (NumExt.tryParseComma(_amountController.text) ?? 0.0)
          .toDouble();
      if (!_amountStreamController.isClosed) {
        _amountStreamController.add(amount);
      }
    });
  }

  Future<void> _loadPaymentMethods() async {
    List<SellerPaymentMethod> paymentMethods = _paymentRepo.paymentMethodsValue;
    if (paymentMethods.isEmpty) {
      await _paymentCubit.getPaymentMethods(
        isActive: true,
        notMethods: ['PAYMENT_ON_DELIVERY'],
      );
    }

    // Mặc định chọn payment method đầu tiên nếu có
    if (mounted) {
      paymentMethods = _paymentRepo.paymentMethodsValue;
      if (paymentMethods.isNotEmpty) {
        final availableMethod = paymentMethods.firstWhere(
          (method) => !widget.currentSelectedPayments.any(
            (payment) => payment.compareWith(method),
          ),
          orElse: () => paymentMethods.first,
        );
        setState(() {
          _selectedPaymentMethod = availableMethod;
        });
      }
    }
  }

  @override
  void dispose() {
    _amountStreamController.close();
    _amountController.dispose();
    super.dispose();
  }

  void _showPaymentMethodSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      builder: (context) => StreamBuilder<List<SellerPaymentMethod>>(
        stream: _paymentRepo.paymentMethods.stream,
        initialData: _paymentRepo.paymentMethodsValue,
        builder: (context, snapshot) {
          final paymentMethods = snapshot.data ?? [];

          return ColumnWidget(
            mainAxisSize: .min,
            children: [
              BottomSheetHeader(
                title: 'Hình thức thanh toán',
                onClose: () => Navigator.pop(context),
              ),
              SizedBox(height: 16.h),
              if (snapshot.connectionState == ConnectionState.waiting)
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: const CircularProgressIndicator(),
                )
              else if (paymentMethods.isEmpty)
                Padding(
                  padding: EdgeInsets.all(20.w),
                  child: Text(
                    'Không có phương thức thanh toán',
                    style: AppStyles.text.medium(fSize: 14.sp),
                  ),
                )
              else
                Flexible(
                  child: SingleChildScrollView(
                    child: ColumnWidget(
                      children: [
                        ...paymentMethods
                            .where(
                              (method) => !widget.currentSelectedPayments.any(
                                (payment) => payment.compareWith(method),
                              ),
                            )
                            .map((method) {
                              return BottomSheetListItem(
                                onTap: () {
                                  setState(() {
                                    _selectedPaymentMethod = method;
                                  });
                                  Navigator.pop(context);
                                },
                                isSelected:
                                    _selectedPaymentMethod?.compareWith(
                                      method,
                                    ) ??
                                    false,
                                leading: _PaymentMethodIcon(
                                  iconUrl: method.icon ?? "",
                                ),
                                title: method.displayPaymentName,
                              );
                            }),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 20.h),
            ],
          );
        },
      ),
    );
  }

  void _onComplete() {
    if (!_formKey.currentState!.validate()) return;
    final customerPaid = (NumExt.tryParseComma(_amountController.text) ?? 0.0)
        .toDouble();

    Navigator.pop(context, {
      'paymentMethodName': _selectedPaymentMethod?.displayPaymentName,
      'paymentMethodId': _selectedPaymentMethod?.id,
      'bankCode': _selectedPaymentMethod?.bankCode,
      'paymentMethodEnum': _selectedPaymentMethod?.method,
      'paymentMethod': _selectedPaymentMethod,
      'customerPaid': customerPaid,
      'remainingAmount': widget.totalAmount - customerPaid,
    });
  }

  TextStyle get labelStyle =>
      AppStyles.text.medium(fSize: 14.sp, color: AppColors.black3);
  TextStyle get hintStyle =>
      AppStyles.text.medium(fSize: 12.sp, color: AppColors.grey84);

  InputBorder get focusedBorder => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: const BorderSide(color: AppColors.primary),
  );

  InputBorder get border => OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.r),
    borderSide: const BorderSide(color: AppColors.greyC0),
  );

  EdgeInsets get contentPadding =>
      EdgeInsets.symmetric(horizontal: 16.w, vertical: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        elevation: 1,
        shadowColor: AppColors.black.withOpacity(0.5),
        label: 'Thanh toán',
      ),
      backgroundColor: AppColors.background,
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: context.focus.unfocus,
          child: ColumnWidget(
            gap: 24.h,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            children: [
              ColumnWidget(
                gap: 8.h,
                children: [
                  Text(
                    'Khách cần trả',
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                  Text(
                    widget.totalAmount.toPrice(),
                    style: AppStyles.text.bold(
                      fSize: 40.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  color: AppColors.white,
                  child: ColumnWidget(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    gap: 12.h,
                    children: [
                      Text(
                        'Khách thanh toán',
                        style: AppStyles.text.semiBold(fSize: 16.sp),
                      ),
                      OpenBottomSheetListButton(
                        label: 'Hình thức thanh toán',
                        value: _selectedPaymentMethod?.displayPaymentName,
                        placeholder: 'Chọn hình thức',
                        onTap: _showPaymentMethodSelector,
                      ),
                      InputFormField(
                        controller: _amountController,
                        formFieldKey: _amountFieldKey,
                        label: 'Tiền khách đưa',
                        hint: 'Nhập số tiền',
                        textInputAction: .done,
                        type: decimalInputType(),
                        inputFormatters: decimalInputFormatter(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Vui lòng nhập số tiền';
                          }
                          final amount = NumExt.tryParseComma(value);
                          if (amount == null || amount == 0) {
                            return 'Số tiền không hợp lệ';
                          }
                          if (amount < 0) {
                            return 'Số tiền không được âm';
                          }
                          if (amount > widget.totalAmount) {
                            return 'Số tiền khách đưa không được lớn hơn số tiền cần thanh toán';
                          }
                          return null;
                        },
                        suffix: Padding(
                          padding: .symmetric(horizontal: 8.w),
                          child: Text(
                            'đ',
                            style: AppStyles.text.semiBold(fSize: 14.sp),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ColumnWidget(
          mainAxisSize: MainAxisSize.min,
          gap: 12.h,
          children: [
            // Khách còn phải trả
            StreamBuilder<double>(
              stream: _amountStreamController.stream,
              initialData: (NumExt.tryParseComma(_amountController.text) ?? 0.0)
                  .toDouble(),
              builder: (context, snapshot) {
                final customerPaid = snapshot.data ?? 0.0;
                final remainingAmount = widget.totalAmount - customerPaid;
                return RowWidget(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Khách còn phải trả',
                      style: AppStyles.text.medium(fSize: 14.sp),
                    ),
                    Text(
                      remainingAmount.toPrice(),
                      style: AppStyles.text.semiBold(
                        fSize: 16.sp,
                        color: remainingAmount > 0
                            ? AppColors.scarlet
                            : AppColors.black3,
                      ),
                    ),
                  ],
                );
              },
            ),
            // Button Hoàn tất
            CustomButtonWidget(
              label: 'Hoàn tất',
              onTap: _onComplete,
              color: AppColors.primary,
            ),
          ],
        ),
      ),
    );
  }
}
