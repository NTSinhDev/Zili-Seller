// import 'dart:async';
// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:zili_coffee/res/res.dart';
// import 'package:zili_coffee/services/location_service.dart';
// import 'package:zili_coffee/utils/widgets/widgets.dart';
// part 'components/body.dart';

// class MapScreen extends StatefulWidget {
//   const MapScreen({super.key});
//   static String keyName = '/map';

//   @override
//   State<MapScreen> createState() => MapScreenState();
// }

// class MapScreenState extends State<MapScreen> {
//   final Completer<GoogleMapController> _mapController =
//       Completer<GoogleMapController>();

//   @override
//   Future<void> dispose() async {
//     _mapController.isCompleted
//         ? _mapController.future.then((controller) => controller.dispose())
//         : ();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         toolbarHeight: 64.h,
//         elevation: 3,
//         title: Text(
//           "Bản đồ",
//           style: AppStyles.text.bold(fSize: 23.sp, color: AppColors.white),
//         ),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(52.h),
//           child: Container(
//             margin: EdgeInsets.fromLTRB(24.w, 0, 24.w, 10.h),
//             padding: EdgeInsets.symmetric(horizontal: 20.w),
//             width: Spaces.screenWidth(context) - 48.w,
//             height: 45.h,
//             decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.circular(12.r),
//               border: Border.all(color: Colors.grey.withOpacity(0.5)),
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Icon(
//                   CupertinoIcons.search,
//                   color: AppColors.primary,
//                 ),
//                 width(width: 12),
//                 Expanded(
//                   child: TextField(
//                     cursorColor: AppColors.primary,
//                     onChanged: (value) {},
//                     onSubmitted: (value) {},
//                     keyboardType: TextInputType.multiline,
//                     textInputAction: TextInputAction.search,
//                     scrollPadding: const EdgeInsets.all(0),
//                     textAlign: TextAlign.left,
//                     decoration: const InputDecoration(
//                       border: InputBorder.none,
//                       contentPadding: EdgeInsets.all(0),
//                       hintText: "Tìm kiếm",
//                     ),
//                     style: AppStyles.text.medium(fSize: 16.sp),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: FutureBuilder<Position>(
//         future: LocationService.determinePosition(),
//         builder: (_, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(
//                 color: AppColors.primary,
//                 backgroundColor: AppColors.primary.withOpacity(0.3),
//                 strokeWidth: 2,
//               ),
//             );
//           }
//           final Position? position = snapshot.data;
//           if (position == null) {
//             return Center(
//               child: Text(
//                 "Failed to load Google map!",
//                 style: AppStyles.text.semiBold(
//                   fSize: 14.sp,
//                   color: AppColors.red,
//                 ),
//               ),
//             );
//           }
//           return _Body(mapController: _mapController, position: position);
//         },
//       ),
//     );
//   }

//   // Future<void> _goToTheLake() async {
//   //   final GoogleMapController controller = await _mapController.future;
//   //   await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   // }
// }
