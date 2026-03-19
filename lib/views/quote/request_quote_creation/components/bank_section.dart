part of '../create_quote_screen.dart';

class _BankSection extends StatelessWidget {
  final BankInfo? payment;
  final Function(BankInfo) onPaymentChanged;
  const _BankSection({required this.payment, required this.onPaymentChanged});

  void _showBankingSelection(
    BuildContext context,
    PaymentRepository paymentRepository,
  ) async {
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
            stream: paymentRepository.bankingMethods.stream,
            builder: (context, snapshot) {
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
                        payment?.code == bankingMethods[index]?.code;
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
                          onPaymentChanged(bankingMethods[index]!);
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

  @override
  Widget build(BuildContext context) {
    // ** State management - data controller
    final CommonService commonService = di<CommonService>();
    final PaymentRepository paymentRepository = di<PaymentRepository>();
    List<BankInfo> bankingMethods = [];
    // Load banking methods
    if ((paymentRepository.bankingMethods.valueOrNull ?? []).isNotEmpty) {
      bankingMethods = paymentRepository.bankingMethods.valueOrNull ?? [];
      // Defer to next frame to avoid FocusScope assertion (parent setState during build)
      if (payment.isNull) {
        final defaultBankingMethod = bankingMethods.valueBy((e) => e.isDefault);
        if (defaultBankingMethod.isNotNull) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            onPaymentChanged(defaultBankingMethod!);
          });
        }
      }
    } else {
      commonService.getActiveBankingMethods().then((result) {
        bankingMethods = result;
        // Defer to next frame to avoid FocusScope assertion (parent setState during build)
        if (payment.isNull) {
          final defaultBankingMethod = bankingMethods.valueBy(
            (e) => e.isDefault,
          );
          if (defaultBankingMethod.isNotNull) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onPaymentChanged(defaultBankingMethod!);
            });
          }
        }
      });
    }
    return Container(
      padding: EdgeInsets.all(16.w),
      color: AppColors.white,
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 12.h,
        children: [
          RowWidget(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                'Phương thức thanh toán',
                style: AppStyles.text.semiBold(fSize: 16.sp),
              ),
              if (payment.isNotNull) ...[
                InkWell(
                  onTap: () =>
                      _showBankingSelection(context, paymentRepository),
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
                ),
              ],
            ],
          ),
          if (payment.isNull) ...[
            ShimmerView(type: .onlyLoadingIndicator),
            const SizedBox.shrink(),
          ] else ...[
            Divider(height: 1, color: AppColors.grayEA, thickness: 1.sp),
            // OpenBottomSheetListButton(
            //   label: 'Ngân hàng',
            //   value: payment!.displayName,
            //   placeholder: 'Chọn ngân hàng',
            //   onTap: () => _showBankingSelection(context, paymentRepository),
            // ),
            Container(
              width: .infinity,
              padding: .symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                borderRadius: .circular(8.r),
                border: .all(color: AppColors.greyC0),
              ),
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 8.h,
                children: [
                  _RowItem(
                    label: 'Chủ tài khoản',
                    value:
                        payment!.accountOwner ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  ),
                  _RowItem(
                    label: 'Số tài khoản',
                    value:
                        payment!.bankNumber ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  ),
                  _RowItem(
                    label: 'Chi nhánh',
                    value:
                        payment!.bankName ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  ),
                  _RowItem(
                    label: 'Swift code',
                    value:
                        payment!.bankIdentifier ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String label;
  final String value;
  const _RowItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return CustomRichTextWidget(
      defaultStyle: AppStyles.text.medium(
        fSize: 12.sp,
        color: AppColors.black5,
      ),
      maxLines: 1,
      texts: [
        "$label:\t\t",
        TextSpan(
          text: value,
          style: AppStyles.text.medium(fSize: 14.sp, color: AppColors.black3),
        ),
      ],
    );
  }
}
