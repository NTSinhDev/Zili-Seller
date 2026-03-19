part of '../home_screen.dart';

// class _StateConnectivity extends StatelessWidget {
//   final Widget child;
//   const _StateConnectivity({required this.child});

//   @override
//   Widget build(BuildContext context) {
//     bool showingDialog = false;
//     return StreamBuilder<bool>(
//       stream: ConnectivityService().subjectStatusConnection.stream,
//       builder: (context, snapshot) {
//         InternetConnectionChecker().hasConnection.then((isDeviceConnected) {
//           Future.delayed(Duration.zero, () {
//             if (!isDeviceConnected && !showingDialog) {
//               showingDialog = true;
//               context.navigator.popUntil((route) => route.isFirst);
//               context.showCustomDialog(
//                 barrierColor: Colors.black12,
//                 height: 350.h,
//                 canDismiss: false,
//                 canPhysicalBack: false,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(horizontal: 20.w),
//                   child: Column(
//                     children: [
//                       Lottie.asset(
//                         AppConstant.animations.lostConnection,
//                         height: 220.h,
//                         fit: BoxFit.fill,
//                       ),
//                       Text(
//                         'Không thể kết nối!',
//                         style: AppStyles.text.semiBold(
//                           fSize: 16.sp,
//                           color: AppColors.red,
//                         ),
//                         textAlign: TextAlign.center,
//                       ),
//                       height(height: 8),
//                       Text(
//                         'Không thể kết nối đến máy chủ. Vui lòng kiểm tra lại kết nối của bạn và thử lại!',
//                         style: AppStyles.text
//                             .mediumItalic(
//                               fSize: 12.5.sp,
//                               color: AppColors.primary,
//                               height: 1.38.sp,
//                             )
//                             .copyWith(wordSpacing: 0.5.w),
//                         textAlign: TextAlign.center,
//                       ),
//                       height(height: 20),
//                       CustomButtonWidget(
//                         onTap: () => exit(0),
//                         radius: 48.r,
//                         color: AppColors.white,
//                         width: 160.w,
//                         height: 36.h,
//                         boxShadows: const [],
//                         child: Center(
//                           child: Text(
//                             'Thoát ứng dụng',
//                             style: AppStyles.text.semiBold(
//                                 fSize: 14.sp, color: AppColors.primary),
//                           ),
//                         ),
//                       ),
//                       // Row(
//                       //   mainAxisAlignment: MainAxisAlignment.center,
//                       //   crossAxisAlignment: CrossAxisAlignment.center,
//                       //   mainAxisSize: MainAxisSize.min,
//                       //   children: [
//                       //     CustomButtonWidget(
//                       //       onTap: () {
//                       //         Restart.restartApp();
//                       //       },
//                       //       radius: 48.r,
//                       //       color: AppColors.white,
//                       //       width: 112.w,
//                       //       height: 36.h,
//                       //       boxShadows: const [],
//                       //       child: Center(
//                       //         child: Text(
//                       //           'Thử lại',
//                       //           style: AppStyles.text.semiBold(
//                       //               fSize: 14.sp, color: AppColors.primary),
//                       //         ),
//                       //       ),
//                       //     ),
//                       //     width(width: 20.w),
//                       //     CustomButtonWidget(
//                       //       onTap: () => exit(0),
//                       //       radius: 48.r,
//                       //       color: AppColors.white,
//                       //       width: 112.w,
//                       //       height: 36.h,
//                       //       boxShadows: const [],
//                       //       child: Center(
//                       //         child: Text(
//                       //           'Thoát',
//                       //           style: AppStyles.text.semiBold(
//                       //               fSize: 14.sp, color: AppColors.primary),
//                       //         ),
//                       //       ),
//                       //     ),
//                       //   ],
//                       // ),
//                     ],
//                   ),
//                 ),
//               );
//             } else {
//               if (showingDialog) {
//                 context.navigator.pop();
//                 showingDialog = false;
//               }
//             }
//           });
//         });

//         return child;
//       },
//     );
//   }
// }
