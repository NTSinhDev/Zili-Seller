import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/date_time.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/data/models/notification.dart';
import 'package:zili_coffee/views/module_common/avatar.dart';

part 'components/notification_item.dart';
part 'components/separator.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static String keyName = '/notification';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget.lightAppBar(context, label: "Thông báo"),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(seconds: 1));
        },
        color: AppColors.primary,
        child: Scrollbar(
          radius: Radius.circular(4.r),
          child: SizedBox(
            width: Spaces.screenWidth(context),
            height: Spaces.screenHeight(context),
            child: ListView.separated(
              itemBuilder: (context, index) {
                return _NotificationItem(
                  notification: NotificationModel.data[index],
                );
              },
              separatorBuilder: (context, index) => const _Separator(),
              itemCount: NotificationModel.data.length,
            ),
          ),
        ),
      ),
    );
  }
}


// loading
// return SizedBox(
//           width: Spaces.screenWidth(context),
//           height: Spaces.screenHeight(context),
//           child: ListView.separated(
//             itemBuilder: (context, index) {
//               return const _NotificationItem();
//             },
//             separatorBuilder: (context, index) => const _Separator(),
//             itemCount: 3,
//           ),
//         );