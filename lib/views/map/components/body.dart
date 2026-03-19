// part of '../map_screen.dart';

// class _Body extends StatefulWidget {
//   final Position position;
//   final Completer<GoogleMapController> mapController;
//   const _Body({required this.position, required this.mapController});

//   @override
//   State<_Body> createState() => _BodyState();
// }

// class _BodyState extends State<_Body> {
//   Set<Marker> _markers = {};

//   final double radius = 8.r;
//   final double size = 40.w;
//   static const double opacity = 0.3;
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       children: [
//         GoogleMap(
//           myLocationEnabled: true,
//           myLocationButtonEnabled: false,
//           zoomControlsEnabled: false,
//           mapType: MapType.terrain,
//           markers: {..._markers},
//           initialCameraPosition: CameraPosition(
//             target: LatLng(widget.position.latitude, widget.position.longitude),
//             zoom: 12,
//           ),
//           onMapCreated: (controller) {
//             if (widget.mapController.isCompleted) return;
//             widget.mapController.complete(controller);
//           },
//           cloudMapId: "f39ea7ce6bc2b3b8",
//           compassEnabled: true,
//           onTap: (LatLng latLng) {
//             _markers.add(
//               Marker(
//                 markerId: MarkerId(
//                   latLng.latitude.toString() + latLng.latitude.toString(),
//                 ),
//                 position: latLng,
//               ),
//             );
//             setState(() {
              
//             });
//             log(
//               "message: ${latLng.latitude} - ${latLng.longitude}",
//               name: "Sinh",
//             );
//           },
//         ),
//         Align(
//           alignment: Alignment.bottomRight,
//           child: Container(
//             margin: EdgeInsets.only(right: 10.w, bottom: 10.w),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 InkWell(
//                   onTap: () async {
//                     final GoogleMapController controller =
//                         await widget.mapController.future;
//                     try {
//                       await controller.animateCamera(
//                         CameraUpdate.newCameraPosition(
//                           CameraPosition(
//                             target: LatLng(
//                               widget.position.latitude,
//                               widget.position.longitude,
//                             ),
//                             zoom: 14,
//                           ),
//                         ),
//                       );
//                       // ignore: empty_catches
//                     } catch (e) {}
//                   },
//                   child: Container(
//                     width: size,
//                     height: size,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(radius),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(opacity),
//                           offset: const Offset(-1, 1),
//                           blurRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Icon(
//                       size: 20.sp,
//                       CupertinoIcons.location_solid,
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),
//                 height(height: 7),
//                 InkWell(
//                   onTap: () async {
//                     try {
//                       final GoogleMapController controller =
//                           await widget.mapController.future;

//                       final zoomLevel = await controller.getZoomLevel();
//                       await controller.animateCamera(
//                         CameraUpdate.newCameraPosition(
//                           CameraPosition(
//                             target: LatLng(
//                               widget.position.latitude,
//                               widget.position.longitude,
//                             ),
//                             zoom: zoomLevel + 1,
//                           ),
//                         ),
//                       );
//                       // ignore: empty_catches
//                     } catch (e) {}
//                   },
//                   child: Container(
//                     width: size,
//                     height: size,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.vertical(
//                         top: Radius.circular(radius),
//                       ),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(opacity),
//                           offset: const Offset(-1, 1),
//                           blurRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: CustomIconStyle(
//                       icon: CupertinoIcons.add,
//                       style: AppStyles.text.bold(fSize: 20.sp),
//                       color: Colors.black54,
//                     ),
//                   ),
//                 ),
//                 height(height: 1.5),
//                 InkWell(
//                   onTap: () async {
//                     try {
//                       final GoogleMapController controller =
//                           await widget.mapController.future;
//                       final zoomLevel = await controller.getZoomLevel();
//                       await controller.animateCamera(
//                         CameraUpdate.newCameraPosition(
//                           CameraPosition(
//                             target: LatLng(
//                               widget.position.latitude,
//                               widget.position.longitude,
//                             ),
//                             zoom: zoomLevel - 1,
//                           ),
//                         ),
//                       );
//                       // ignore: empty_catches
//                     } catch (e) {}
//                   },
//                   child: Container(
//                     width: size,
//                     height: size,
//                     alignment: Alignment.center,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.vertical(
//                         bottom: Radius.circular(radius),
//                       ),
//                       color: Colors.white,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(opacity),
//                           offset: const Offset(-1, 1),
//                           blurRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: CustomIconStyle(
//                       icon: CupertinoIcons.minus,
//                       style: AppStyles.text.bold(fSize: 20.sp),
//                       color: Colors.black54,
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         )
//       ],
//     );
//   }
// }
