// import 'package:carousel_slider/carousel_slider.dart' as carousel;
// import 'package:flutter/material.dart';

// class SliderWidget extends StatelessWidget {
//   final carousel.CarouselController? sliderController;
//   final double height;
//   final bool enableInfiniteScroll;
//   final List<Widget>? items;
//   const SliderWidget({
//     super.key,
//     this.sliderController,
//     required this.height,
//     this.enableInfiniteScroll = true,
//     this.items,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return carousel.CarouselSlider(
//       carouselController: sliderController,
//       options: carousel.CarouselOptions(
//         height: height,
//         viewportFraction: 1.0,
//         enableInfiniteScroll: enableInfiniteScroll,
//       ),
//       items: items?.map((item) => item).toList() ?? [],
//     );
//   }
// }
