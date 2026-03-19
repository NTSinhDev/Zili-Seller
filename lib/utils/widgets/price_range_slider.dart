// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_xlider/flutter_xlider.dart';
// // import 'package:rxdart/rxdart.dart';
// import 'package:zili_coffee/data/repositories/category_repository.dart';
// import 'package:zili_coffee/di/dependency_injection.dart';
// import 'package:zili_coffee/res/res.dart';
// import 'package:zili_coffee/utils/extension/int.dart';

// class PriceRangeSlider extends StatefulWidget {
//   final List<double> startValues;
//   final double min;
//   final double max;
//   const PriceRangeSlider({
//     super.key,
//     this.startValues = const [100000, 1100000],
//     this.min = 0,
//     this.max = 2000000,
//   });

//   @override
//   State<PriceRangeSlider> createState() => _PriceRangeSliderState();
// }

// class _PriceRangeSliderState extends State<PriceRangeSlider> {
//   final CategoryRepository categoryRepository = di<CategoryRepository>();
//   late List<double> startValues;

//   @override
//   void initState() {
//     super.initState();
//     startValues = [...widget.startValues];
//     if (categoryRepository.behaviorMinPrice.hasValue) {
//       startValues[0] = categoryRepository.behaviorMinPrice.value.toDouble();
//     } else {
//       categoryRepository.behaviorMinPrice.sink.add(startValues.first.toInt());
//     }
//     if (categoryRepository.behaviorMaxPrice.hasValue) {
//       startValues[1] = categoryRepository.behaviorMaxPrice.value.toDouble();
//     } else {
//       categoryRepository.behaviorMaxPrice.sink.add(startValues.last.toInt());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         FlutterSlider(
//           values: startValues,
//           rangeSlider: true,
//           min: widget.min,
//           max: widget.max,
//           onDragging: (handlerIndex, lowerValue, upperValue) {
//             categoryRepository.behaviorMinPrice.sink.add(lowerValue.toInt());
//             categoryRepository.behaviorMaxPrice.sink.add(upperValue.toInt());
//           },
//           tooltip: FlutterSliderTooltip(
//             custom: (value) {
//               return Container(
//                 width: 64.w,
//                 height: 24.h,
//                 decoration: BoxDecoration(
//                     color: AppColors.lightGrey,
//                     borderRadius: BorderRadius.circular(20.r),
//                     boxShadow: <BoxShadow>[
//                       BoxShadow(
//                         color: AppColors.primary.withOpacity(0.3),
//                         offset: const Offset(1, 1),
//                         blurRadius: 4,
//                       )
//                     ]),
//                 child: Center(
//                   child: Text(
//                     (int.parse(value.round().toString())).toPrice(),
//                     style: AppStyles.text.medium(fSize: 10.sp),
//                   ),
//                 ),
//               );
//             },
//           ),
//           trackBar: FlutterSliderTrackBar(
//             activeTrackBar: const BoxDecoration(color: AppColors.black),
//             activeTrackBarHeight: 3.h,
//           ),
//           handler: sliderNode(),
//           rightHandler: sliderNode(),
//         ),
//         Container(
//           margin: EdgeInsets.symmetric(horizontal: 20.w),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               StreamBuilder<int>(
//                 stream: categoryRepository.behaviorMinPrice.stream,
//                 builder: (context, snapshot) {
//                   return Text(
//                     (snapshot.data ?? 0).toPrice(),
//                     style: AppStyles.text.semiBold(fSize: 12.sp),
//                   );
//                 },
//               ),
//               StreamBuilder<int>(
//                 stream: categoryRepository.behaviorMaxPrice.stream,
//                 builder: (context, snapshot) {
//                   return Text(
//                     (snapshot.data ?? 0).toPrice(),
//                     style: AppStyles.text.semiBold(fSize: 12.sp),
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   FlutterSliderHandler sliderNode() {
//     return FlutterSliderHandler(
//       decoration: const BoxDecoration(boxShadow: []),
//       child: Container(
//         width: 20.w,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           border: Border.all(color: AppColors.black),
//           color: AppColors.white,
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.black.withOpacity(0.3),
//               blurRadius: 3.r,
//               offset: const Offset(1, 1),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
