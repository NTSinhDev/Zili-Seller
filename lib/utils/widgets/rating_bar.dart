import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/res/res.dart';

class RatingBarWidget extends StatefulWidget {
  final double value;
  final bool buildActionBar;
  final double? size;
  final double? spacing;
  final Function(int rating)? ratingValue;
  const RatingBarWidget({
    super.key,
    required this.value,
    this.buildActionBar = false,
    this.size,
    this.spacing,
    this.ratingValue,
  });

  @override
  State<RatingBarWidget> createState() => _RatingBarWidgetState();
}

class _RatingBarWidgetState extends State<RatingBarWidget> {
  int currentIndex = 0;
  late final double size;

  @override
  void initState() {
    super.initState();
    size = widget.size ?? 18.2;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.buildActionBar) return buildActionBar();
    return buildWidget();
  }

  Widget buildWidget() {
    final int star = widget.value.floor();
    final int halfStar = widget.value - star > 0 ? 1 : 0;
    final int noneStar = 5 - star - halfStar;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        ...buildStar(count: star, type: 1),
        ...buildStar(count: halfStar, type: -1),
        ...buildStar(count: noneStar, type: 0),
      ],
    );
  }

  Widget buildActionBar() {
    return Row(
      children: [
        for (int i = 1; i < 6; i++) ...[
          i > currentIndex ? noneStarWidget(index: i) : starWidget(index: i),
          width(width: widget.spacing ?? 9.78)
        ],
      ],
    );
  }

  /// type: 1 -> star, 0 -> none start, else half start
  List<Widget> buildStar({required int count, required int type}) {
    List<Widget> build = [];
    Widget starType = halfStarWidget();
    switch (type) {
      case 1:
        starType = starWidget();
        break;
      case 0:
        starType = noneStarWidget();
        break;
      default:
        starType = halfStarWidget();
    }

    for (var i = 0; i < count; i++) {
      build.add(starType);
      build.add(width(width: widget.spacing ?? 9.78));
    }
    return build;
  }

  Widget starWidget({int? index}) {
    return InkWell(
      onTap: index != null
          ? () {
              if (currentIndex == index) return;
              setState(() {
                currentIndex = index;
              });
              if (widget.ratingValue != null) {
                widget.ratingValue!(currentIndex);
              }
            }
          : null,
      child: SvgPicture.asset(
        AppConstant.svgs.icStar,
        width: size.w,
        height: size.w,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget halfStarWidget() {
    return Stack(
      children: [
        noneStarWidget(),
        SvgPicture.asset(
          AppConstant.svgs.icStarHalf,
          width: size.w / 2,
          height: size.w,
          fit: BoxFit.fitWidth,
        )
      ],
    );
  }

  Widget noneStarWidget({int? index}) {
    return InkWell(
      onTap: index != null
          ? () {
              if (currentIndex == index) return;
              setState(() {
                currentIndex = index;
              });
              if (widget.ratingValue != null) {
                widget.ratingValue!(currentIndex);
              }
            }
          : null,
      child: SvgPicture.asset(
        AppConstant.svgs.icStarNone,
        width: size.w,
        height: size.w,
        fit: BoxFit.fill,
      ),
    );
  }
}
