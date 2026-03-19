import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:zili_coffee/res/res.dart';

class PickerWidget extends StatelessWidget {
  final Function(List<Media>) sendFiles;
  const PickerWidget({super.key, required this.sendFiles});

  @override
  Widget build(BuildContext context) {
    return MediaPicker(
      mediaList: const [],
      onPicked: (selectedList) => onSubmitAfterPicked(selectedList, context),
      onCancel: () => Navigator.pop(context),
      mediaCount: MediaCount.multiple,
      mediaType: MediaType.all,
      decoration: PickerDecoration(
        actionBarPosition: ActionBarPosition.top,
        blurStrength: 2,
        completeText: 'Gửi',
        loadingWidget: Container(
          width: double.infinity,
          height: double.infinity,
          color: AppColors.lightGrey,
        ),
        cancelIcon: SvgPicture.asset(
          AppConstant.svgs.icXmarkXl,
          colorFilter: const ColorFilter.mode(
            AppColors.primary,
            BlendMode.srcIn,
          ),
        ),
        albumTextStyle: AppStyles.text.semiBold(fSize: 14.sp),
        albumTitleStyle: AppStyles.text.bold(
          fSize: 14.sp,
          color: AppColors.primary,
        ),
        completeButtonStyle: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) => AppColors.primary,
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          textStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (Set<WidgetState> states) => AppStyles.text.medium(
              fSize: 14.sp,
              color: AppColors.white,
            ),
          ),
        ),
        counterBuilder: (context, index) => Positioned(
          right: 6.w,
          top: 8.w,
          child: Container(
            alignment: Alignment.topRight,
            width: 16.w,
            height: 16.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Center(
              child: Text(
                index.toString(),
                style: AppStyles.text.semiBold(
                  fSize: 10.sp,
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      // headerBuilder: (context, albumSelector, completeSelection, onBack) {
      //   return Container(
      //     padding: EdgeInsets.all(16),
      //     color: Colors.grey[200],
      //     child: Row(
      //       children: [
      //         IconButton(
      //           icon: Icon(Icons.arrow_back),
      //           onPressed: onBack,
      //         ),
      //         Expanded(
      //           child: Text(
      //             'Chọn tệp media',
      //             style: TextStyle(
      //               fontWeight: FontWeight.bold,
      //               fontSize: 18,
      //             ),
      //             textAlign: TextAlign.center,
      //           ),
      //         ),
      //         TextButton(
      //           child: Text(
      //             'Hoàn thành',
      //             style: TextStyle(
      //               color: Colors.blue,
      //               fontSize: 16,
      //             ),
      //           ),
      //           onPressed: completeSelection,
      //         ),
      //       ],
      //     ),
      //   );
      // },
    );
  }

  void onSubmitAfterPicked(List<Media> selectedList, context) {
    // widget.onPicked();
    sendFiles(selectedList);

    Navigator.pop(context);
  }
}
