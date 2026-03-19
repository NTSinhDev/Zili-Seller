import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:zili_coffee/data/models/blog/blog.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;
  const BlogDetailScreen({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    final content = HtmlWidget(
      blog.description,
      onErrorBuilder: (context, element, error) =>
          Text('$element error: $error'),
      onLoadingBuilder: (context, element, loadingProgress) =>
          const CircularProgressIndicator(),
      textStyle: AppStyles.text.medium(fSize: 14.sp),
    );
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Chi tiết bài viết',
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5.r),
                    child: ImageLoadingWidget(
                      url: blog.thumbnail,
                      width: Spaces.screenWidth(context),
                      height: 182.h,
                      fit: BoxFit.cover,
                    ),
                  ),
                  height(height: 20),
                  Text(
                    blog.title,
                    style: AppStyles.text.semiBold(fSize: 16.sp, height: 1.3),
                  ),
                  height(height: 15),
                  content,
                ],
              ),
            ),
            Container(
              color: AppColors.lightGrey,
              height: 25.h,
            ),
            height(height: 30),
            Container(
              margin: EdgeInsets.only(left: 20.w),
              child: Text(
                'Câu chuyện mới nhất',
                style: AppStyles.text.semiBold(fSize: 16.sp),
              ),
            ),
            SingleChildScrollView(
              clipBehavior: Clip.none,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: List.generate(
                  4,
                  (index) => Container(
                    margin: EdgeInsets.only(top: 20.w),
                    child: CustomCardWidget.news(
                      blog: Blog.blogConstant,
                      layoutView: LayoutView.horizontal,
                    ),
                  ),
                ),
              ),
            ),
            height(height: 166),
          ],
        ),
      ),
    );
  }
}
