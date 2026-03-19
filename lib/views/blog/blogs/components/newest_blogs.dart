part of '../blogs_screen.dart';

class _NewestBlog extends StatelessWidget {
  const _NewestBlog();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
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
    );
  }
}
