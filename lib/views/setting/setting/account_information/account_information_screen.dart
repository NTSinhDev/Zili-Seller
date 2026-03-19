import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/extension/string.dart';

import '../../../../data/models/user/user.dart';
import '../../../../data/repositories/auth_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/enums/user_enum.dart';
import '../../../../utils/functions/auth_functions.dart';
import '../../../../utils/functions/customer_functions.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/status_badge.dart';
import '../../modules/user_avatar.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});
  static String keyName = '/account-information';

  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = di<AuthRepository>();
    final User? user = authRepository.currentUser;
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Chi tiết tài khoản',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: SingleChildScrollView(
        child: ColumnWidget(
          margin: .symmetric(vertical: 16.h),
          gap: 12.h,
          children: [
            RowWidget(
              padding: .symmetric(horizontal: 16.w, vertical: 16.h),
              backgroundColor: AppColors.white,
              crossAxisAlignment: .end,
              gap: 12.w,
              children: [
                UserAvatar(avatarURL: user?.avatar),
                Expanded(
                  child: ColumnWidget(
                    gap: 8.h,
                    crossAxisAlignment: .start,
                    children: [
                      RowWidget(
                        gap: 4.w,
                        mainAxisAlignment: .start,
                        children: [
                          Expanded(
                            child: Text(
                              user?.name ??
                                  AppConstant.strings.DEFAULT_EMPTY_VALUE,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: AppStyles.text.semiBold(fSize: 16.sp),
                            ),
                          ),
                          StatusBadge(
                            label: renderUserStatus(user?.status) ?? "",
                            color:
                                colorUserStatus(user?.status) ??
                                AppColors.lightF,
                          ),
                        ],
                      ),
                      RowWidget(
                        gap: 4.w,
                        mainAxisAlignment: .start,
                        children: [
                          Text(
                            "Vị trí:",
                            maxLines: 1,
                            overflow: .ellipsis,
                            style: AppStyles.text.medium(
                              fSize: 12.sp,
                              color: AppColors.grey84,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              renderUserPosition(user?.positionType) ??
                                  AppConstant.strings.DEFAULT_EMPTY_VALUE,
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: AppStyles.text.medium(fSize: 14.sp),
                            ),
                          ),
                        ],
                      ),
                      if (!(authRepository.currentAuth?.isBusinessOwner ??
                          false)) ...[
                        RowWidget(
                          gap: 4.w,
                          mainAxisAlignment: .start,
                          children: [
                            Text(
                              "Quyền hạn:",
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.grey84,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                user?.role?.roleName ??
                                    AppConstant.strings.DEFAULT_EMPTY_VALUE,
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: AppStyles.text.medium(fSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                        RowWidget(
                          gap: 4.w,
                          mainAxisAlignment: .start,
                          children: [
                            Text(
                              "Phân quyền:",
                              maxLines: 1,
                              overflow: .ellipsis,
                              style: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.grey84,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                user?.role?.name.capitalize ??
                                    AppConstant.strings.DEFAULT_EMPTY_VALUE,
                                maxLines: 1,
                                overflow: .ellipsis,
                                style: AppStyles.text.medium(fSize: 14.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                height(height: 24),
              ],
            ),
            _buildInformation(context, user),
            _buildAddressInformation(context, user),
          ],
        ),
      ),
    );
  }

  Widget _buildInformation(BuildContext context, User? user) {
    final Map<String, dynamic> informationMaps = {
      "Họ và tên của người đại diện":
          user?.company?.fullName ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
      "Tên tài khoản":
          user?.username ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
      "Số điện thoại": user?.phone ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
      "Email": user?.email ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
      "Số CMND/CCCD/Hộ Chiếu người đại diện":
          user?.positionType == PositionType.businessOwner
          ? user?.company?.cardId ?? AppConstant.strings.DEFAULT_EMPTY_VALUE
          : "************",
    };
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .only(top: 16.h),
      backgroundColor: AppColors.white,
      mainAxisSize: .min,
      children: [
        Container(
          padding: .symmetric(horizontal: 20.w),
          child: Text(
            'Thông tin tài khoản',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: informationMaps.entries.length,
          separatorBuilder: (context, index) =>
              Divider(color: AppColors.background, height: 1.h),
          itemBuilder: (context, index) {
            final data = informationMaps.entries.elementAt(index);
            return Container(
              padding: .symmetric(horizontal: 20.w, vertical: 12.h),
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  Text(
                    data.key,
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                  Text(
                    "${data.value ?? AppConstant.strings.DEFAULT_EMPTY_VALUE}",
                    style: AppStyles.text.medium(fSize: 14.sp),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAddressInformation(BuildContext context, User? user) {
    final Map<String, dynamic> informationMaps = {
      "Quốc gia": user?.country ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
      "Tỉnh / Thành phố": renderEnterpriseAddress(.province, user?.company),
      "Quận / Huyện": renderEnterpriseAddress(.district, user?.company),
      "Phường / Xã": renderEnterpriseAddress(.ward, user?.company),
      "Số nhà - Tên đường":
          user?.company?.address ?? AppConstant.strings.DEFAULT_EMPTY_VALUE,
    };
    return ColumnWidget(
      crossAxisAlignment: .start,
      padding: .only(top: 16.h),
      backgroundColor: AppColors.white,
      mainAxisSize: .min,
      children: [
        Container(
          padding: .symmetric(horizontal: 20.w),
          child: Text(
            'Thông tin địa chỉ',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: informationMaps.entries.length,
          separatorBuilder: (context, index) =>
              Divider(color: AppColors.background, height: 1.h),
          itemBuilder: (context, index) {
            final data = informationMaps.entries.elementAt(index);
            return Container(
              padding: .symmetric(horizontal: 20.w, vertical: 12.h),
              child: ColumnWidget(
                crossAxisAlignment: .start,
                gap: 4.h,
                children: [
                  Text(
                    data.key,
                    style: AppStyles.text.medium(
                      fSize: 12.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                  Text(
                    "${data.value ?? AppConstant.strings.DEFAULT_EMPTY_VALUE}",
                    style: AppStyles.text.medium(fSize: 14.sp),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
