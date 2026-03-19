import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

enum TPAlertDialogType { info, warning, error, success }

extension TPAlertDialogTypeExt on TPAlertDialogType {
  Color get color {
    switch (this) {
      case TPAlertDialogType.error:
        return Colors.redAccent;
      case TPAlertDialogType.warning:
        return Colors.yellow[700]!;
      case TPAlertDialogType.success:
        return Colors.green;
      default:
        return Colors.black87;
    }
  }
}

class TPLoadingDialog extends StatelessWidget {
  final String? message;
  const TPLoadingDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: (message == null)
          ? _buildLoadingWidgetNoMessage()
          : _buildLoadingWidgetMessage(context),
    );
  }

  Widget _buildLoadingWidgetNoMessage() {
    return const SizedBox(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 4,
      ),
    );
  }

  Widget _buildLoadingWidgetMessage(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 28.w,
                height: 28.w,
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  backgroundColor: AppColors.primary.withOpacity(0.3),
                  strokeWidth: 2,
                ),
              ),
              width(width: 12),
              Flexible(
                child: Text(
                  message!,
                  style: AppStyles.text
                      .medium(
                        fSize: 14.sp,
                        color: AppColors.primary,
                      )
                      .copyWith(decoration: TextDecoration.none),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TPAlertDialog extends StatelessWidget {
  const TPAlertDialog({
    super.key,
    this.type = TPAlertDialogType.info,
    this.title,
    this.message,
    this.action,
    this.onAction,
  });

  final TPAlertDialogType type;
  final String? title;
  final String? message;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title != null
          ? Text(
              title!,
              style: AppStyles.text.semiBold(fSize: 14.sp, color: type.color),
            )
          : null,
      content: Text(
        message!,
        style: AppStyles.text.medium(fSize: 14.sp),
      ),
      actions: <Widget>[
        TPButton.filledButton(
          title: action,
          onPressed: () {
            onAction?.call();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
