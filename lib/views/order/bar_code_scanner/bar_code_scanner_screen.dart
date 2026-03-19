// import 'dart:developer';

// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:zili_coffee/res/res.dart';
// import 'package:zili_coffee/utils/extension/build_context.dart';
// import 'package:zili_coffee/utils/widgets/widgets.dart';

// class BarCodeScannerScreen extends StatefulWidget {
//   const BarCodeScannerScreen({Key? key}) : super(key: key);
//   static const String keyName = "/bar-code-scanner";
//   @override
//   State<StatefulWidget> createState() => _BarCodeScannerScreenState();
// }

// class _BarCodeScannerScreenState extends State<BarCodeScannerScreen> {
//   final MobileScannerController _controller = MobileScannerController(
//     detectionSpeed: DetectionSpeed.noDuplicates,
//     facing: CameraFacing.back,
//     useNewCameraSelector: true,
//   );
//   final Color _foregroundBGColor = Colors.black45;
//   final Color _foregroundColor = Colors.white;

//   bool isTurnOnFlash = false;
//   bool isFrontCamera = false;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//       value: ThemeApp.systemLight.copyWith(
//         statusBarIconBrightness: Brightness.light,
//         systemNavigationBarColor: AppColors.primary,
//       ),
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         body: SizedBox(
//           width: MediaQuery.sizeOf(context).width,
//           height: MediaQuery.sizeOf(context).height,
//           child: Stack(
//             children: [
//               SizedBox(
//                 width: MediaQuery.sizeOf(context).width,
//                 height: MediaQuery.sizeOf(context).height,
//                 child: _buildScanView(context),
//               ),
//               Container(
//                 width: MediaQuery.sizeOf(context).width,
//                 height: MediaQuery.sizeOf(context).height,
//                 padding: .symmetric(vertical: 40.h, horizontal: 20.w),
//                 child: Column(
//                   children: [
//                     _topScreenComp(context),
//                     height(height: 0.16.sh),
//                     Text(
//                       "Hướng camera của bạn về phía mã vạch",
//                       style: AppStyles.text.medium(
//                         fSize: 14.sp,
//                         color: _foregroundColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _topScreenComp(BuildContext context) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         InkWell(
//           onTap: () => context.navigator.pop(),
//           child: Container(
//             width: 40.w,
//             height: 40.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: _foregroundBGColor,
//             ),
//             child: Icon(
//               CupertinoIcons.xmark,
//               color: _foregroundColor,
//               size: 24.sp,
//             ),
//           ),
//         ),
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(24.r),
//             color: _foregroundBGColor,
//           ),
//           child: Text(
//             "Quét mã vạch",
//             style: AppStyles.text.bold(fSize: 16.sp, color: _foregroundColor),
//           ),
//         ),
//         InkWell(
//           onTap: () => context.showBottomSheet(child: _extensionView()),
//           child: Container(
//             width: 40.w,
//             height: 40.w,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: _foregroundBGColor,
//             ),
//             child: Icon(
//               CupertinoIcons.ellipsis,
//               color: _foregroundColor,
//               size: 24.sp,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _extensionView() {
//     return LayoutModalBottomSheet.basic(
//       height: 150.h,
//       children: [
//         ListTile(
//           onTap: () async {
//             await _controller.toggleTorch();
//             setState(() {
//               isTurnOnFlash = !isTurnOnFlash;
//             });
//             if (mounted) {
//               context.navigator.pop();
//             }
//           },
//           leading: Icon(
//             isTurnOnFlash ? Icons.flash_off : Icons.flash_on,
//             color: isTurnOnFlash ? null : AppColors.yellow,
//           ),
//           title: Text(
//             isTurnOnFlash ? "Tắt flash" : "Bật flash",
//             style: AppStyles.text.medium(fSize: 15.sp),
//           ),
//           subtitle: isTurnOnFlash
//               ? null
//               : Text(
//                   "Bật flash để quét trong điều kiện thiếu sáng",
//                   style: AppStyles.text.mediumItalic(
//                     fSize: 12.sp,
//                     color: AppColors.grey84,
//                   ),
//                 ),
//           visualDensity: const VisualDensity(horizontal: 0.0, vertical: 0.0),
//           contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
//           titleAlignment: ListTileTitleAlignment.center,
//         ),
//         ListTile(
//           onTap: () async {
//             await _controller.switchCamera();
//             setState(() {
//               isFrontCamera = !isFrontCamera;
//             });
//             if (mounted) {
//               context.navigator.pop();
//             }
//           },
//           leading: const Icon(Icons.cameraswitch, color: AppColors.primary),
//           title: Text(
//             "Xoay camera",
//             style: AppStyles.text.medium(fSize: 15.sp),
//           ),
//           subtitle: Text(
//             isFrontCamera
//                 ? "Xoay camera về phía sau"
//                 : "Xoay camera về phía trước",
//             style: AppStyles.text.mediumItalic(
//               fSize: 12.sp,
//               color: AppColors.grey84,
//             ),
//           ),
//           visualDensity: const VisualDensity(horizontal: 0.0, vertical: 0.0),
//           contentPadding: EdgeInsets.symmetric(horizontal: 24.w),
//           titleAlignment: ListTileTitleAlignment.center,
//         ),
//       ],
//     );
//   }

//   Widget _buildScanView(BuildContext context) {
//     return Stack(
//       children: [
//         MobileScanner(
//           controller: _controller,
//           onDetect: _onScannerQRCodeHasResult,
//         ),
//         // Custom overlay
//         // Custom overlay với phần ngoài có màu, phần trong transparent
//         CustomPaint(
//           painter: QrScannerOverlay(
//             borderColor: AppColors.primary,
//             borderRadius: 10.r,
//             borderLength: 56.w,
//             borderWidth: 3.w,
//             cutOutSize: 300.w,
//           ),
//           child: Container(),
//         ),
//       ],
//     );
//   }

//   void _onScannerQRCodeHasResult(BarcodeCapture barcodeCapture) async {
//     if (!mounted) return;

//     final List<Barcode> barcodes = barcodeCapture.barcodes;
//     if (barcodes.isEmpty) return;

//     final Barcode barcode = barcodes.first;
//     final String? orderID = barcode.rawValue;

//     await _controller.stop();

//     if (orderID != null && orderID.isNotEmpty) {
//       log('Barcode scanned: $orderID');
//       if (mounted) {
//         context.navigator.pop();
//       }
//     } else {
//       if (mounted) {
//         context.showCustomDialog(
//           height: 164.h,
//           barrierColor: Colors.black38,
//           canDismiss: false,
//           backgroundColor: AppColors.white,
//           child: UINotificationProvider.common(
//             context,
//             title: 'Lỗi mã vạch',
//             content:
//                 "Dường như bạn đã quét mã vạch không đúng, vui lòng kiểm tra lại. Xin cảm ơn!",
//             leftButton: 'Hủy',
//             rightButton: 'Đã hiểu',
//             onTap: () async {
//               await _controller.start();
//               if (mounted) {
//                 context.navigator.pop();
//               }
//             },
//           ),
//         );
//       }
//     }
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
// }

// // Custom overlay painter
// class QrScannerOverlay extends CustomPainter {
//   final Color borderColor;
//   final double borderRadius;
//   final double borderLength;
//   final double borderWidth;
//   final double cutOutSize;

//   QrScannerOverlay({
//     required this.borderColor,
//     required this.borderRadius,
//     required this.borderLength,
//     required this.borderWidth,
//     required this.cutOutSize,
//   });

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.black.withValues(alpha: 0.0)
//       ..style = PaintingStyle.fill;

//     // Draw overlay
//     canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

//     // Calculate cutout position (center)
//     final cutOutLeft = (size.width - cutOutSize) / 2;
//     final cutOutTop = (size.height - cutOutSize) / 2;
//     final cutOutRect = Rect.fromLTWH(
//       cutOutLeft,
//       cutOutTop,
//       cutOutSize,
//       cutOutSize,
//     );

//     // Clear cutout area
//     final cutOutPaint = Paint()
//       ..blendMode = BlendMode.color
//       ..color = Colors.black.withValues(alpha: 0.5);

//     canvas.drawRRect(
//       RRect.fromRectAndRadius(cutOutRect, Radius.circular(borderRadius)),
//       cutOutPaint,
//     );

//     // Draw border
//     final borderPaint = Paint()
//       ..color = borderColor
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = borderWidth;

//     // Top left corner
//     canvas.drawLine(
//       Offset(cutOutLeft, cutOutTop + borderRadius),
//       Offset(cutOutLeft, cutOutTop + borderLength),
//       borderPaint,
//     );
//     canvas.drawLine(
//       Offset(cutOutLeft + borderRadius, cutOutTop),
//       Offset(cutOutLeft + borderLength, cutOutTop),
//       borderPaint,
//     );

//     // Top right corner
//     canvas.drawLine(
//       Offset(cutOutLeft + cutOutSize - borderLength, cutOutTop),
//       Offset(cutOutLeft + cutOutSize - borderRadius, cutOutTop),
//       borderPaint,
//     );
//     canvas.drawLine(
//       Offset(cutOutLeft + cutOutSize, cutOutTop + borderRadius),
//       Offset(cutOutLeft + cutOutSize, cutOutTop + borderLength),
//       borderPaint,
//     );

//     // Bottom left corner
//     canvas.drawLine(
//       Offset(cutOutLeft, cutOutTop + cutOutSize - borderLength),
//       Offset(cutOutLeft, cutOutTop + cutOutSize - borderRadius),
//       borderPaint,
//     );
//     canvas.drawLine(
//       Offset(cutOutLeft + borderRadius, cutOutTop + cutOutSize),
//       Offset(cutOutLeft + borderLength, cutOutTop + cutOutSize),
//       borderPaint,
//     );

//     // Bottom right corner
//     canvas.drawLine(
//       Offset(cutOutLeft + cutOutSize - borderLength, cutOutTop + cutOutSize),
//       Offset(cutOutLeft + cutOutSize - borderRadius, cutOutTop + cutOutSize),
//       borderPaint,
//     );
//     canvas.drawLine(
//       Offset(cutOutLeft + cutOutSize, cutOutTop + cutOutSize - borderLength),
//       Offset(cutOutLeft + cutOutSize, cutOutTop + cutOutSize - borderRadius),
//       borderPaint,
//     );
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }
