import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/models/order/order_info.dart';
import 'package:zili_coffee/data/models/user/company.dart';
import 'package:zili_coffee/data/models/user/staff.dart';
import 'package:zili_coffee/data/models/warehouse/warehouse.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';

import '../../../../data/models/user/base_person.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/functions/order_function.dart';

class AdditionalSection extends StatelessWidget {
  final OrderInfo? orderInfo;
  final Warehouse? warehouse;
  final Staff? staff;
  final BasePerson? personCreated;
  final Company? company;
  final String? saleChannel;
  const AdditionalSection({
    super.key,
    this.orderInfo,
    this.warehouse,
    this.staff,
    this.personCreated,
    this.company,
    this.saleChannel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        _row(
          'Chính sách giá',
          renderPriceType(orderInfo?.infoAdditional?.salesType) ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _row(
          'Bán tại',
          warehouse?.name ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        // _row(
        //   'Cộng tác viên',
        //   staff?.name ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
        // ),
        _row(
          'Nhân viên kinh doanh',
          staff?.name ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _row(
          'Người tạo',
          personCreated?.fullName ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _row(
          'Nguồn đơn',
          saleChannel ??
              orderInfo?.infoAdditional?.saleChannel ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
       
        _row(
          'Thanh toán dự kiến',
          orderInfo?.infoAdditional?.expectedPayment ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _row(
          'Ngày bán',
          orderInfo?.infoAdditional?.saleDate?.csToString(
                TimeFormat.ddMMyyyyHHmm.value,
              ) ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
        _row(
          'Ngày hẹn giao',
          orderInfo?.infoAdditional?.scheduledDeliveryAt?.csToString(
                TimeFormat.ddMMyyyyHHmm.value,
              ) ??
              AppConstant.strings.DEFAULT_EMPTY_VALUE,
        ),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Text(
            label,
            style: AppStyles.text.medium(fSize: 13.sp, color: AppColors.grey84),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppStyles.text.medium(
                fSize: 13.sp,
                color: AppColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
