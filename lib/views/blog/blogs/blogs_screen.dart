import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/blog/blog_cubit.dart';
import 'package:zili_coffee/data/models/blog/blog.dart';
import 'package:zili_coffee/data/models/blog/blog_category.dart';
import 'package:zili_coffee/data/repositories/blog_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
part 'components/app_bar.dart';
part 'components/featured_blogs.dart';
part 'components/category_tag.dart';
part 'components/newest_blogs.dart';
part 'components/layout.dart';

class BlogsScreen extends StatelessWidget {
  const BlogsScreen({super.key});
    static String keyName = '/blogs';

  @override
  Widget build(BuildContext context) {
    final BlogRepository blogRepository = di<BlogRepository>();
    di<BlogCubit>().getBlogCategories();
    return _Layout(
      onRefresh: () async {},
      body: [
        Container(
          margin: EdgeInsets.only(left: 20.w, top: 20.h, bottom: 15.h),
          child: Text(
            'Bài viết nổi bật',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
        ),
        const _FeaturedBlogs(),
        height(height: 30),
        Container(
          width: Spaces.screenWidth(context),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          color: AppColors.lightF,
          child: StreamBuilder<List<BlogCategory>>(
              stream: blogRepository.blogCategoryStreamData.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Wrap(
                      runSpacing: 15.w,
                      spacing: 12.h,
                      children: List.generate(
                        6,
                        (index) => const _CategoryTag(category: ''),
                      ));
                }
                if ((snapshot.data ?? []).isEmpty) {
                  return Wrap(
                    runSpacing: 15.w,
                    spacing: 12.h,
                    children: BlogCategory.blogCategoryList
                        .map(
                            (category) => _CategoryTag(category: category.name))
                        .toList(),
                  );
                }
                return Wrap(
                  runSpacing: 15.w,
                  spacing: 12.h,
                  children: snapshot.data!
                      .map((category) => _CategoryTag(category: category.name))
                      .toList(),
                );
              }),
        ),
        height(height: 30),
        Container(
          margin: EdgeInsets.only(left: 20.w),
          child: Text(
            'Câu chuyện mới nhất',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
        ),
        const _NewestBlog(),
        Container(height: 180.h)
      ],
    );
  }
}
