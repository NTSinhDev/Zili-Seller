import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/extension.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

/// A widget that displays an image from a URL with caching capabilities.
///
/// This widget uses the `cached_network_image` package to efficiently
/// load and display images from the network. It also provides default
/// placeholder and error widgets.
///
/// Example:
/// ```dart
/// ImageUrlWidget(
///   url: 'https://example.com/image.png',
///   width: 100,
///   height: 100,
/// )
/// ```
class ImageUrlWidget extends StatelessWidget {
  final double? width;
  final double? height;
  final String? url;
  final Color? color;
  final BoxFit? fit;
  final BoxConstraints? constraints;
  final Widget Function(BuildContext, String)? placeholder;
  final Widget Function(BuildContext, String, dynamic)? errorWidget;
  const ImageUrlWidget({
    super.key,
    this.width,
    this.height,
    this.url,
    this.color,
    this.fit,
    this.constraints,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: constraints,
      child: CachedNetworkImage(
        imageUrl: url ?? "",
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        color: color,
        memCacheWidth: width != null ? (width! * 3).toInt() : null,
        memCacheHeight: height != null ? (height! * 3).toInt() : null,
        filterQuality: FilterQuality.high,
        fadeInDuration: const Duration(milliseconds: 200),
        fadeOutDuration: const Duration(milliseconds: 200),
        // errorListener: _errorListener,
        placeholder: placeholder ?? _placeholderBuilder,
        errorWidget: errorWidget ?? _errorWidgetBuilder,
      ),
    );
  }

  void _errorListener(Object data) {
    assert(data.isNotNull, data.toString());
  }

  Widget _placeholderBuilder(BuildContext context, String url) {
    return SizedBox(
      width: width ?? 40.w,
      height: height ?? 40.w,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(AppConstant.svgs.minimalistLogoApp),
              fit: BoxFit.scaleDown,
              scale: 2.2,
              colorFilter: const ColorFilter.mode(AppColors.black24, BlendMode.srcIn)),
        ),
      ),
    );
  }

  Widget _errorWidgetBuilder(BuildContext context, String url, dynamic error) {
    return Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        // borderRadius: PlaceholderWidget.borderRadius10,
        color: AppColors.lightGrey,
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: (width ?? height ?? 20.w) /
              ((width.isNotNull || height.isNotNull) ? 3 : 1),
          color: AppColors.black5,
        ),
      ),
    );
  }
}

class ImageLoadingWidget extends StatelessWidget {
  final double width;
  final double height;
  final String url;
  final bool borderRadius;
  final Color? color;
  final Color? highlightColor;
  final BoxFit? fit;
  final bool hasPlaceHolder;
  final bool resize;
  const ImageLoadingWidget({
    super.key,
    required this.url,
    required this.width,
    required this.height,
    this.color,
    this.highlightColor,
    this.borderRadius = true,
    this.fit,
    this.hasPlaceHolder = true,
    this.resize = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: PlaceholderWidget(
              width: width,
              height: resize ? (height - 10.h) : height,
              borderRadius: borderRadius,
              color: color,
              highlightColor: highlightColor,
            ),
          ),
          Container(
            color: url.isEmpty ? null : color ?? AppColors.lightGrey,
            child: Stack(
              children: [
                if (hasPlaceHolder)
                  SizedBox(
                    width: width,
                    height: height,
                    child: Center(
                      child: SvgPicture.asset(
                        AssetIcons.logoMinimalistSvg,
                        width: (width / 2.5).sp,
                        colorFilter: const ColorFilter.mode(
                          AppColors.greyB3,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                if (url.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: url,
                    width: width,
                    height: height,
                    fit: fit ?? BoxFit.cover,
                    fadeInDuration: const Duration(seconds: 0),
                    fadeOutDuration: const Duration(seconds: 0),
                    errorWidget: (context, url, error) => Container(
                      width: width,
                      height: height,
                      color: AppColors.lightGrey,
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          size: (width / 3).sp,
                          color: AppColors.gray7,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
