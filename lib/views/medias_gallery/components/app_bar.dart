// part of '../medias_gallery_screen.dart';

// class _AppBar extends StatelessWidget {
//   const _AppBar();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: Spaces.screenWidth(context),
//       height: 80.h,
//       padding: EdgeInsets.fromLTRB(20.w, 20.w, 20.w, 0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           InkWell(
//             onTap: () => context.navigator.pop(),
//             child: Container(
//               padding: EdgeInsets.all(4.w),
//               child: const Icon(
//                 CupertinoIcons.chevron_back,
//                 color: AppColors.white,
//               ),
//             ),
//           ),
//           Text(
//             "Chi tiết đánh giá",
//             style: AppStyles.text.semiBold(
//               fSize: 16.sp,
//               color: AppColors.white,
//             ),
//           ),
//           Container(),
//         ],
//       ),
//     );
//   }
// }
