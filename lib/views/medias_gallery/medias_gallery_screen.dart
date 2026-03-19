// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:video_player/video_player.dart';
// import 'package:zili_coffee/data/models/media_file.dart';
// import 'package:zili_coffee/data/models/review/review.dart';
// import 'package:zili_coffee/res/res.dart';
// import 'package:zili_coffee/utils/enums.dart';
// import 'package:zili_coffee/utils/extension/build_context.dart';
// import 'package:zili_coffee/utils/extension/date_time.dart';
// import 'package:zili_coffee/utils/extension/string.dart';
// import 'package:zili_coffee/utils/widgets/widgets.dart';
// import 'package:zili_coffee/views/module_common/avatar.dart';
// part 'components/app_bar.dart';

// class MediasGalleryScreen extends StatefulWidget {
//   final Review review;

//   const MediasGalleryScreen({super.key, required this.review});
//   static String keyName = '/photos-gallery';

//   @override
//   State<MediasGalleryScreen> createState() => _MediasGalleryScreenState();
// }

// class _MediasGalleryScreenState extends State<MediasGalleryScreen> {
//   final CarouselController _sliderController = CarouselController();
//   late final List<MediaFile> medias;
//   final Map<int, VideoPlayerController> controllers = {};
//   final Map<int, Future<void>?> controllersFuture = {};

//   @override
//   void initState() {
//     super.initState();
//     medias = [...widget.review.images, ...widget.review.videos];
//   }

//   @override
//   void dispose() {
//     controllers.values.map((controller) => controller.dispose());
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.black,
//       body: SizedBox(
//         width: Spaces.screenWidth(context),
//         height: Spaces.screenHeight(context),
//         child: Column(
//           children: [
//             const _AppBar(),
//             CarouselSlider(
//               carouselController: _sliderController,
//               options: CarouselOptions(
//                 height: Spaces.screenHeight(context) - 235.h,
//                 viewportFraction: 1,
//                 enlargeCenterPage: false,
//                 onPageChanged: (index, reason) {},
//                 enableInfiniteScroll: false,
//               ),
//               items: _items(),
//             ),
//             Container(
//               padding: EdgeInsets.all(20.w),
//               height: 154.h,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Avatar(
//                         avatar: widget.review.customer.avatar,
//                         size: 40.r,
//                       ),
//                       width(width: 15),
//                       Expanded(
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.stretch,
//                           children: [
//                             height(height: 4),
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Text(
//                                   widget.review.customer.name.anonymousName,
//                                   style: AppStyles.text.bold(
//                                     fSize: 16.sp,
//                                     color: AppColors.white,
//                                   ),
//                                 ),
//                                 width(width: 12.w),
//                                 RatingBarWidget(
//                                   value: widget.review.score,
//                                   size: 11,
//                                   spacing: 3,
//                                 ),
//                               ],
//                             ),
//                             height(height: 6),
//                             productInformation(),
//                             height(height: 4),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                   height(height: 12.h),
//                   if (widget.review.content != null)
//                     Text(
//                       widget.review.content ?? '',
//                       maxLines: 3,
//                       overflow: TextOverflow.ellipsis,
//                       style: AppStyles.text.medium(
//                         fSize: 14.sp,
//                         height: 1.39,
//                         color: AppColors.lightGrey,
//                       ),
//                     ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget productInformation() {
//     String text =
//         widget.review.postDate.dateByFormat(format: DateTimeFormat.ddMMyyyy);
//     if (widget.review.productVariant != null) {
//       text +=
//           ' | ${widget.review.productVariant!.opt2} - ${widget.review.productVariant!.opt1}, túi ${widget.review.productVariant!.opt3}';
//     }

//     return Text(
//       text,
//       style: AppStyles.text.medium(
//         fSize: 12.sp,
//         color: AppColors.lightF,
//       ),
//     );
//   }

//   List<Widget> _items() {
//     List<Widget> items = [];
//     for (var i = 0; i < medias.length; i++) {
//       late final Widget item;
//       if (medias[i].type == MediaType.image) {
//         item = Builder(
//           builder: (context) => ImageLoadingWidget(
//             url: medias[i].url,
//             width: Spaces.screenWidth(context),
//             height: Spaces.screenHeight(context),
//             borderRadius: false,
//             color: AppColors.black,
//           ),
//         );
//       } else {
//         final videoURL = medias[i].url;
//         final videoUri = Uri.parse(videoURL);
//         final videoController = VideoPlayerController.networkUrl(videoUri);
//         final videoControllerFuture = videoController.initialize();
//         controllers[i] = videoController;
//         controllersFuture[i] = videoControllerFuture;
//         item = Builder(builder: (context) {
//           return Center(
//             child: VideoPlayerWidget(
//               url: videoURL,
//               urlThumb: medias[i].urlThumb,
//               maxViewHeight: Spaces.screenHeight(context) - 235.h,
//               returnVideoData: (videoController, videoControllerFuture) {
//                 controllers[i] = videoController;
//                 controllersFuture[i] = videoControllerFuture;
//               },
//               videoController: controllers[i],
//               videoControllerFuture: controllersFuture[i],
//             ),
//           );
//         });
//       }
//       items.add(item);
//     }

//     return items;
//   }
// }
