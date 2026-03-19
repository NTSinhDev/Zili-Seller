import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/entity/address/address_entity.dart';
import '../../../../data/models/address/address.dart';
import '../../../../res/res.dart';
import '../../../../utils/widgets/widgets.dart';

class AddressItem extends StatelessWidget {
  final Address address;
  const AddressItem({super.key, required this.address});

  String get _addressName => address.displayName;

  String get _addressType {
    final type = address.type;
    if (type == null) return '--';
    switch (type) {
      case AddressType.home:
        return 'Nhà riêng';
      case AddressType.office:
        return 'Văn phòng';
    }
  }

  String get _fullAddress => address.fullAddress;

  String get _phone => address.phone ?? '--';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      color: AppColors.white,
      child: ColumnWidget(
        crossAxisAlignment: CrossAxisAlignment.start,
        gap: 8.h,
        children: [
          Row(
            children: [
              Expanded(
                child: ColumnWidget(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  gap: 4.h,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            _addressName,
                            style: AppStyles.text.semiBold(
                              fSize: 16.sp,
                              color: AppColors.black3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (address.isDefault) ...[
                          SizedBox(width: 8.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              'Mặc định',
                              style: AppStyles.text.medium(
                                fSize: 11.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (address.type != null)
                      Text(
                        _addressType,
                        style: AppStyles.text.medium(
                          fSize: 13.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.sp,
                color: AppColors.grey84,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  _fullAddress,
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (address.phone != null && address.phone!.isNotEmpty) ...[
            Row(
              children: [
                Icon(
                  Icons.phone_outlined,
                  size: 14.sp,
                  color: AppColors.grey84,
                ),
                SizedBox(width: 6.w),
                Text(
                  _phone,
                  style: AppStyles.text.medium(
                    fSize: 13.sp,
                    color: AppColors.grey84,
                  ),
                ),
              ],
            ),
          ],
          if (address.note != null && address.note!.isNotEmpty) ...[
            Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.note_outlined,
                    size: 14.sp,
                    color: AppColors.grey84,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      address.note!,
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.black3,
                      ),
                    ),
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
