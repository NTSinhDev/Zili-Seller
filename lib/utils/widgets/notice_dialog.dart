import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/column_widget.dart';
import 'package:zili_coffee/utils/widgets/row_widget.dart';

enum NoticeVariant { info, success, warning, error, confirm }

class NoticeDialogAction {
  final String label;
  final VoidCallback onPressed;
  final bool isOutline; // true = outline, false = filled
  final bool isDestructive;

  const NoticeDialogAction({
    required this.label,
    required this.onPressed,
    this.isDestructive = false,
    this.isOutline = false,
  });
}

class NoticeDialog extends StatelessWidget {
  const NoticeDialog({
    super.key,
    required this.title,
    required this.message,
    this.variant = NoticeVariant.info,
    this.primaryAction,
    this.secondaryAction,
  });

  final String title;
  final String message;
  final NoticeVariant variant;
  final NoticeDialogAction? primaryAction;
  final NoticeDialogAction? secondaryAction;

  @override
  Widget build(BuildContext context) {
    final config = _variantConfig(variant);
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: .circular(12.r)),
      insetPadding: .symmetric(horizontal: 20.w, vertical: 24.h),
      contentPadding: .fromLTRB(20.w, 20.h, 20.w, 12.h),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.72.sw),
        child: ColumnWidget(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          gap: 16.h,
          children: [
            RowWidget(
              gap: 12.w,
              children: [
                _IconBadge(
                  icon: config.icon,
                  bgColor: config.bgColor,
                  iconColor: config.iconColor,
                ),
                Expanded(
                  child: Text(
                    title,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              message,
              style: AppStyles.text.medium(
                fSize: 13.sp,
                color: AppColors.black5,
                height: 1.4,
              ),
            ),
            RowWidget(
              mainAxisAlignment: .end,
              gap: 12.w,
              children: [
                if (secondaryAction != null)
                  _DialogButton.secondary(
                    label: secondaryAction!.label,
                    onPressed: secondaryAction!.onPressed,
                  ),
                if (primaryAction != null)
                  if (primaryAction!.isOutline)
                    _DialogButton.outline(
                      label: primaryAction!.label,
                      onPressed: primaryAction!.onPressed,
                      color: primaryAction!.isDestructive
                          ? SystemColors.red
                          : config.iconColor,
                    )
                  else
                    _DialogButton.primary(
                      label: primaryAction!.label,
                      onPressed: primaryAction!.onPressed,
                      color: primaryAction!.isDestructive
                          ? SystemColors.red
                          : config.iconColor,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showNoticeDialog({
  required BuildContext context,
  required String title,
  required String message,
  NoticeVariant variant = NoticeVariant.info,
  NoticeDialogAction? primaryAction,
  NoticeDialogAction? secondaryAction,
  bool? barrierDismissible,
}) {
  final dismissible =
      barrierDismissible ??
      (variant == NoticeVariant.info || variant == NoticeVariant.success);
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (_) => NoticeDialog(
      title: title,
      message: message,
      variant: variant,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
    ),
  );
}

class _IconBadge extends StatelessWidget {
  const _IconBadge({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });

  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(4.w),
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 20.sp),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton.primary({
    required this.label,
    required this.onPressed,
    required this.color,
  }) : isPrimary = true,
       textColor = AppColors.white,
       isOutline = false;

  const _DialogButton.secondary({required this.label, required this.onPressed})
    : isPrimary = false,
      color = AppColors.white,
      textColor = AppColors.black3,
      isOutline = false;

  const _DialogButton.outline({
    required this.label,
    required this.onPressed,
    required this.color,
  }) : isPrimary = false,
       textColor = color,
       isOutline = true;

  final String label;
  final VoidCallback onPressed;
  final Color color;
  final Color textColor;
  final bool isPrimary;
  final bool isOutline;
  @override
  Widget build(BuildContext context) {
    final button = isPrimary
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: textColor,
              padding: .symmetric(horizontal: 16.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
              elevation: 0,
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: AppStyles.text.medium(fSize: 14.sp, color: textColor),
            ),
          )
        : isOutline
        ? OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: color),
              padding: .symmetric(horizontal: 16.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: AppStyles.text.medium(fSize: 14.sp, color: textColor),
            ),
          )
        : OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.greyC0),
              padding: .symmetric(horizontal: 16.w, vertical: 12.h),
              shape: RoundedRectangleBorder(borderRadius: .circular(8.r)),
            ),
            onPressed: onPressed,
            child: Text(
              label,
              style: AppStyles.text.medium(fSize: 14.sp, color: textColor),
            ),
          );
    return button;
  }
}

class _NoticeConfig {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  _NoticeConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}

_NoticeConfig _variantConfig(NoticeVariant variant) {
  switch (variant) {
    case NoticeVariant.success:
      return _NoticeConfig(
        icon: Icons.check_circle_rounded,
        iconColor: Colors.green,
        bgColor: Colors.green.withValues(alpha: 0.12),
      );
    case NoticeVariant.warning:
      return _NoticeConfig(
        icon: Icons.warning_amber_rounded,
        iconColor: Colors.orange,
        bgColor: Colors.orange.withValues(alpha: 0.14),
      );
    case NoticeVariant.error:
      return _NoticeConfig(
        icon: Icons.error_rounded,
        iconColor: AppColors.red,
        bgColor: AppColors.red.withValues(alpha: 0.12),
      );
    case NoticeVariant.confirm:
      return _NoticeConfig(
        icon: Icons.help_rounded,
        iconColor: AppColors.primary,
        bgColor: AppColors.primary.withValues(alpha: 0.12),
      );
    case NoticeVariant.info:
      return _NoticeConfig(
        icon: Icons.info_rounded,
        iconColor: Colors.blue,
        bgColor: Colors.blue.withValues(alpha: 0.12),
      );
  }
}

Future<void> showRejectDialog({
  required BuildContext context,
  required String title,
  required String message,
  required List<RejectReason> reasons,
  bool hasOtherReason = false,
  NoticeVariant variant = NoticeVariant.warning,
  RejectDialogAction? primaryAction,
  NoticeDialogAction? secondaryAction,
}) {
  return showDialog(
    context: context,
    builder: (context) => RejectDialog(
      title: title,
      message: message,
      variant: variant,
      reasons: reasons,
      hasOtherReason: hasOtherReason,
      primaryAction: primaryAction,
      secondaryAction: secondaryAction,
    ),
  );
}

class RejectDialogAction extends NoticeDialogAction {
  final Function(int? reasonId, String? note) onReject;
  RejectDialogAction({
    required super.label,
    required this.onReject,
    super.isDestructive = false,
    super.isOutline = false,
  }) : super(onPressed: () {});
}

class RejectReason {
  final int id;
  final String content;
  const RejectReason({required this.id, required this.content});
}

class RejectDialog extends StatefulWidget {
  const RejectDialog({
    super.key,
    required this.title,
    required this.message,
    this.variant = NoticeVariant.info,
    this.primaryAction,
    this.secondaryAction,
    this.reasons = const [],
    this.hasOtherReason = false,
  });

  final String title;
  final String message;
  final NoticeVariant variant;
  final RejectDialogAction? primaryAction;
  final NoticeDialogAction? secondaryAction;
  final List<RejectReason> reasons;
  final bool hasOtherReason;

  @override
  State<RejectDialog> createState() => _RejectDialogState();
}

class _RejectDialogState extends State<RejectDialog> {
  RejectReason? _selectedReason;
  late final TextEditingController _noteController;
  final _otherReason = const RejectReason(id: -1, content: 'Lý do khác...');

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _onConfirm(BuildContext context) {
    if (widget.primaryAction?.onReject == null) {
      Navigator.of(context).pop();
      return;
    }

    if (_selectedReason == null) {
      return;
    }

    final note = _selectedReason == _otherReason ? _noteController.text : null;
    widget.primaryAction?.onReject(_selectedReason?.id, note);
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final config = _variantConfig(widget.variant);
    final allReasons = [
      ...widget.reasons,
      if (widget.hasOtherReason) _otherReason,
    ];

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: .circular(12.r)),
      insetPadding: .symmetric(horizontal: 20.w, vertical: 24.h),
      contentPadding: .fromLTRB(20.w, 20.h, 20.w, 12.h),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 0.72.sw),
        child: ColumnWidget(
          mainAxisSize: .min,
          crossAxisAlignment: .start,
          gap: 16.h,
          children: [
            RowWidget(
              gap: 12.w,
              children: [
                _IconBadge(
                  icon: config.icon,
                  bgColor: config.bgColor,
                  iconColor: config.iconColor,
                ),
                Expanded(
                  child: Text(
                    widget.title,
                    style: AppStyles.text.semiBold(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              widget.message,
              style: AppStyles.text.medium(
                fSize: 13.sp,
                color: AppColors.black5,
                height: 1.4,
              ),
            ),

            // Reason Selector (only for reject dialog)
            DropdownButtonFormField<RejectReason>(
              isExpanded: true,
              hint: Text(
                'Chọn lý do',
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black5,
                ),
              ),
              initialValue: _selectedReason,
              dropdownColor: Colors.white,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 10.h,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.greyC0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.greyC0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
              items: allReasons.map((reason) {
                return DropdownMenuItem(
                  value: reason,
                  child: Text(
                    reason.content,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.black3,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value == _selectedReason) return;
                if (value != _otherReason) {
                  _noteController.clear();
                }
                setState(() {
                  _selectedReason = value;
                });
              },
            ),

            // Note Input (if "Other" selected)
            AbsorbPointer(
              absorbing: _selectedReason != _otherReason,
              child: TextFormField(
                controller: _noteController,
                maxLines: 3,
                enabled: _selectedReason == _otherReason,
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.black3,
                ),
                decoration: InputDecoration(
                  hintText: 'Nhập lý do chi tiết...',
                  hintStyle: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: _selectedReason == _otherReason
                        ? AppColors.grey84
                        : AppColors.greyC0,
                  ),
                  contentPadding: EdgeInsets.all(12.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.greyC0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.grey84),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
            ),

            // Actions
            RowWidget(
              mainAxisAlignment: .end,
              gap: 12.w,
              children: [
                if (widget.secondaryAction != null)
                  _DialogButton.secondary(
                    label: widget.secondaryAction!.label,
                    onPressed: widget.secondaryAction!.onPressed,
                  ),
                if (widget.primaryAction != null)
                  if (widget.primaryAction!.isOutline)
                    _DialogButton.outline(
                      label: widget.primaryAction!.label,
                      onPressed: () => _onConfirm(context),
                      color: widget.primaryAction!.isDestructive
                          ? SystemColors.red
                          : config.iconColor,
                    )
                  else
                    _DialogButton.primary(
                      label: widget.primaryAction!.label,
                      onPressed: () => _onConfirm(context),
                      color: widget.primaryAction!.isDestructive
                          ? SystemColors.red
                          : config.iconColor,
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
