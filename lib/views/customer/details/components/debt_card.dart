import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/enums.dart';

import '../../../../data/models/user/debt.dart';
import '../../../../res/res.dart';
import '../../../../utils/enums/customer_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/functions/customer_functions.dart';
import '../../../../utils/widgets/widgets.dart';

class DebtCard extends StatelessWidget {
  final Debt debt;
  const DebtCard({super.key, required this.debt});

  String? get _debtCode {
    final List<String> codeByList = <DebtAction>[
      .createPayment,
      .cancelPayment,
      .createReceipt,
      .cancelReceipt,
    ].map((i) => i.toConstant).toList();
    if (codeByList.contains(debt.action)) {
      return debt.code;
    } else if (debt.originalDocumentCode != null) {
      return debt.originalDocumentCode;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.white,
      child: ColumnWidget(
        crossAxisAlignment: .start,
        gap: 8.h,
        children: [
          RowWidget(
            gap: 4.h,
            children: [
              Expanded(
                child: Text(
                  _debtCode ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
                  style: AppStyles.text.semiBold(
                    fSize: 16.sp,
                    color: AppColors.black3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                "(tạo bởi ${debt.createdBy?["fullName"] ?? AppConstant.strings.DEFAULT_EMPTY_VALUE})",
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.grey84,
                ),
              ),
            ],
          ),
          Divider(height: 4.h, color: AppColors.greyC0, thickness: 1.sp),
          RowWidget(
            mainAxisAlignment: .spaceBetween,
            children: [
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  "Giá trị thay đổi:\t\t",
                  TextSpan(
                    text: renderVoucherValueDirect(
                      debt.amount,
                      operator: debt.operator,
                    ),
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  "Công nợ:\t\t",
                  TextSpan(
                    text: debt.currentDebt?.toUSD ?? '0',
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
            ],
          ),
          RowWidget(
            mainAxisAlignment: .spaceBetween,
            children: [
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  "Tạo:\t\t",
                  TextSpan(
                    text:
                        debt.createdAt?.csToString('HH:mm dd/MM/yyyy') ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
              CustomRichTextWidget(
                defaultStyle: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black5,
                ),
                texts: [
                  "Ghi nhận:\t\t",
                  TextSpan(
                    text:
                        debt.recordedDate?.csToString('HH:mm dd/MM/yyyy') ??
                        AppConstant.strings.DEFAULT_EMPTY_VALUE,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ],
              ),
            ],
          ),
          CustomRichTextWidget(
            defaultStyle: AppStyles.text.medium(
              fSize: 14.sp,
              color: AppColors.black5,
            ),
            texts: [
              "Chi nhánh:\t\t",
              TextSpan(
                text:
                    debt.branch?["name"] ??
                    AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.semiBold(
                  fSize: 14.sp,
                  color: AppColors.black3,
                ),
              ),
            ],
          ),
          CustomRichTextWidget(
            defaultStyle: AppStyles.text.medium(
              fSize: 14.sp,
              color: AppColors.black5,
            ),
            texts: [
              "Ghi chú:\t\t",
              TextSpan(
                text:
                    debtActionLabel(
                      DebtAction.values.valueBy(
                        (i) => i.toConstant == debt.action,
                      ),
                    ) ??
                    AppConstant.strings.DEFAULT_EMPTY_VALUE,
                style: AppStyles.text.semiBold(
                  fSize: 14.sp,
                  color: AppColors.black3,
                ),
              ),
            ],
          ),
          if (debt.note != null && debt.note!.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Text(
                debt.note!,
                style: AppStyles.text.medium(
                  fSize: 12.sp,
                  color: AppColors.black3,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
