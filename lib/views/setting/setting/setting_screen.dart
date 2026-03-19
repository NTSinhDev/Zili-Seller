import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/bloc/setting/setting_cubit.dart';
import 'package:zili_coffee/views/common/status_badge.dart';
import 'package:zili_coffee/views/setting/setting/printer/printers_bottom_sheet.dart';

import '../../../app/app_wireframe.dart';
import '../../../bloc/app/app_cubit.dart';
import '../../../bloc/auth/auth_cubit.dart';
import '../../../data/models/user/user.dart';
import '../../../data/repositories/order_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../services/common_service.dart';
import '../../../utils/extension/build_context.dart';
import '../../../utils/extension/string.dart';
import '../../../utils/functions/customer_functions.dart';
import '../../../utils/widgets/widgets.dart';
import '../../../views/order/orders_management/orders_management_screen.dart';
import '../../../views/setting/change_password/change_password_screen.dart';
import '../../../views/setting/modules/user_avatar.dart';
import 'account_information/account_information_screen.dart';

part 'components/order_manager.dart';
part 'components/setting_features.dart';
part 'components/user_summary.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final CommonService _commonService = di<CommonService>();
  final AppCubit _appCubit = di<AppCubit>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: BlocBuilder<AppCubit, AppState>(
              bloc: _appCubit,
              builder: (context, state) {
                final user = state is AppReadyWithAuthenticationState
                    ? state.user
                    : null;
                return ColumnWidget(
                  children: [
                    _UserSummary(user: user),
                    // const _OrderManager(),
                    _SettingFeatures(user: user, cubit: _appCubit),
                    FutureBuilder(
                      future: _commonService.getAppVersion(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == .waiting ||
                            snapshot.data == null) {
                          return SizedBox.shrink();
                        }
                        final appVersion =
                            snapshot.data?.$1 ??
                            AppConstant.strings.DEFAULT_EMPTY_VALUE;
                        final buildNumber =
                            snapshot.data?.$2 ??
                            AppConstant.strings.DEFAULT_EMPTY_VALUE;

                        return RowWidget(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                          ).copyWith(top: 20.h),
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              "Version: $appVersion+$buildNumber",
                              style: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: AppColors.grey84,
                              ),
                              textAlign: .center,
                            ),
                          ],
                        );
                      },
                    ),
                    height(height: 50),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _background() {
    return Positioned(
      bottom: 0,
      left: 0,
      child: Container(
        color: Colors.white,
        child: SvgPicture.asset(AssetIcons.bgAccountScreenSvg),
      ),
    );
  }
}
