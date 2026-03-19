part of '../product_detail_screen.dart';

class _ProductMedias extends StatefulWidget {
  const _ProductMedias();
  @override
  State<_ProductMedias> createState() => _ProductMediasState();
}

class _ProductMediasState extends State<_ProductMedias> {
  int currentIndex = 0;
  // final carousel.CarouselController sliderController = carousel.CarouselController();
  VideoPlayerController? videoController;
  Future<void>? videoControllerFuture;

  final ProductRepository productRepository = di<ProductRepository>();

  @override
  void dispose() {
    if (videoController != null) {
      videoController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product?>(
      stream: productRepository.productDetailStreamData.stream,
      builder: (context, snapshot) {
        Product? product;
        if (snapshot.hasData) {
          product = snapshot.data!;
        }
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product?.detail?.medias != null)
              Container()
            // carousel.CarouselSlider(
            //   carouselController: sliderController,
            //   options: carousel.CarouselOptions(
            //     height: Spaces.screenWidth(context),
            //     viewportFraction: 1,
            //     enlargeCenterPage: true,
            //     onPageChanged: (index, reason) {
            //       setState(() {
            //         currentIndex = index;
            //       });
            //       if (currentIndex ==
            //           (product?.detail == null
            //               ? product!.detail!.medias.length - 1
            //               : 0)) {
            //         return false; // Chặn sự kiện changePage.
            //       }
            //     },
            //     enableInfiniteScroll: false,
            //   ),
            //   items: product?.detail?.medias.map((mediaFile) {
            //     return Builder(
            //       builder: (BuildContext context) {
            //         if (mediaFile.type == MediaType.image) {
            //           return ImageLoadingWidget(
            //             url: mediaFile.urlThumb,
            //             width: Spaces.screenWidth(context),
            //             height: Spaces.screenWidth(context),
            //           );
            //         } else {
            //           return VideoPlayerWidget(
            //             url: mediaFile.url,
            //             urlThumb: mediaFile.urlThumb,
            //             returnVideoData:
            //                 (videoController, videoControllerFuture) {
            //               this.videoController = videoController;
            //               this.videoControllerFuture = videoControllerFuture;
            //             },
            //             videoController: videoController,
            //             videoControllerFuture: videoControllerFuture,
            //           );
            //         }
            //       },
            //     );
            //   }).toList(),
            // )
            else
              ImageLoadingWidget(
                url: '',
                width: Spaces.screenWidth(context),
                height: Spaces.screenWidth(context),
              ),
            // _ImageIndicators(
            //   currentIndex: currentIndex,
            //   medias: product?.detail?.medias,
            //   changeImage: (index) {
            //     if (index == currentIndex) return;
            //     sliderController.animateToPage(index);
            //     if (product?.detail?.medias != null) {
            //       if (product?.detail?.medias[index].type == MediaType.video &&
            //           videoController != null) {
            //         videoController!.pause();
            //       }
            //     }
            //     setState(() {
            //       currentIndex = index;
            //     });
            //   },
            // ),
          ],
        );
      },
    );
  }
}

class _ImageIndicators extends StatelessWidget {
  final List<MediaFile>? medias;
  final int currentIndex;
  final Function(int) changeImage;
  const _ImageIndicators({
    required this.medias,
    required this.currentIndex,
    required this.changeImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 4.h),
          scrollDirection: Axis.horizontal,
          clipBehavior: Clip.none,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: medias != null
                ? medias!.map((mediaFile) {
                    final index = medias!.indexOf(mediaFile);
                    return InkWell(
                      onTap: () => changeImage(index),
                      child: Container(
                        width: 75.w,
                        height: 75.w,
                        margin: EdgeInsets.symmetric(horizontal: 6.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.r),
                          border: Border.all(
                            color: currentIndex == index
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          boxShadow: [
                            if (currentIndex != index)
                              BoxShadow(
                                color: AppColors.black.withOpacity(0.15),
                                offset: const Offset(0.0, 0.0),
                                blurRadius: 3.r,
                              ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5.r),
                              child: ImageLoadingWidget(
                                url: mediaFile.urlThumb,
                                width: 75.w,
                                height: 75.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (mediaFile.type == MediaType.video)
                              Center(
                                child: Container(
                                  padding: EdgeInsets.all(2.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.black.withOpacity(0.4),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.play_arrow_rounded,
                                    color: AppColors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }).toList()
                : [
                    ImageLoadingWidget(url: '', width: 75.w, height: 75.w),
                    width(width: 12.w),
                    ImageLoadingWidget(url: '', width: 75.w, height: 75.w),
                    width(width: 12.w),
                    ImageLoadingWidget(url: '', width: 75.w, height: 75.w),
                    width(width: 12.w),
                    ImageLoadingWidget(url: '', width: 75.w, height: 75.w),
                  ],
          ),
        ),
      ),
    );
  }
}
