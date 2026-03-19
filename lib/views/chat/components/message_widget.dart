import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/res/res.dart';

final _radius3 = 3.r;
final _radius15 = 15.r;

class MessageWidget extends StatelessWidget {
  final MessageType type;
  final String message;
  const MessageWidget({super.key, required this.type, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: type == MessageType.admin
          ? MainAxisAlignment.start
          : MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        Container(
          padding: EdgeInsets.fromLTRB(
            type == MessageType.admin ? 15.w : 10.w,
            10.w,
            type == MessageType.user ? 15.w : 10.w,
            10.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: type == MessageType.admin
                  ? Radius.circular(_radius15)
                  : Radius.circular(_radius3),
              bottomLeft: type == MessageType.admin
                  ? const Radius.circular(0)
                  : Radius.circular(_radius3),
              topRight: type == MessageType.admin
                  ? Radius.circular(_radius3)
                  : Radius.circular(_radius15),
              bottomRight: type == MessageType.admin
                  ? Radius.circular(_radius3)
                  : const Radius.circular(0),
            ),
            color: type == MessageType.user
                ? AppColors.primary
                : AppColors.lightGrey,
          ),
          child: SizedBox(
            width: 236.w,
            child: Text(
              message,
              style: AppStyles.text.medium(
                fSize: 14.sp,
                color: type == MessageType.user ? AppColors.white : null,
                height: 1.12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
