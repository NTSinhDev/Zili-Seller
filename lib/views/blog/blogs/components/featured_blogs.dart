part of '../blogs_screen.dart';

class _FeaturedBlogs extends StatelessWidget {
  const _FeaturedBlogs();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Row(
        children: [
          width(width: 20),
          CustomCardWidget.news(
            blog: Blog.blogConstant,
            fullView: true,
            layoutView: LayoutView.vertical,
          ),
          width(width: 20),
          CustomCardWidget.news(
            blog: Blog.blogConstant,
            fullView: true,
            layoutView: LayoutView.vertical,
          ),
          width(width: 20),
          CustomCardWidget.news(
            blog: Blog.blogConstant,
            fullView: true,
            layoutView: LayoutView.vertical,
          ),
          width(width: 20),
          CustomCardWidget.news(
            blog: Blog.blogConstant,
            fullView: true,
            layoutView: LayoutView.vertical,
          ),
          width(width: 20),
          CustomCardWidget.news(
            blog: Blog.blogConstant,
            fullView: true,
            layoutView: LayoutView.vertical,
          ),
          width(width: 20),
          CustomCardWidget.news(
            blog: Blog.blogConstant,
            fullView: true,
            layoutView: LayoutView.vertical,
          ),
          width(width: 20),
        ],
      ),
    );
  }
}
