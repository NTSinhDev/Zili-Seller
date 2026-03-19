part of '../store_reviews_screen.dart';

class _ToolBarReview extends StatefulWidget {
  const _ToolBarReview();

  @override
  State<_ToolBarReview> createState() => _ToolBarReviewState();
}

class _ToolBarReviewState extends State<_ToolBarReview> {
  final ReviewRepository _reviewRepository = di<ReviewRepository>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Spaces.screenWidth(context),
      height: 60.h,
      child: Container(
        width: Spaces.screenWidth(context),
        color: AppColors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: _generateToolBarItems(),
              ),
            ),
            Divider(
              color: AppColors.lightGrey,
              height: 1.h,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _generateToolBarItems() {
    List<Widget> toolBarItems = [];
    for (var i = 0; i < _toolBar.length; i++) {
      toolBarItems.add(
        _ToolbarItem(
          isActive: _reviewRepository.toolbarIndex == i,
          label: _toolBar[i],
          onTap: () => _onChangeToolBarItem(i),
        ),
      );
      if (i != _toolBar.length - 1) {
        toolBarItems.add(width(width: 28));
      }
    }
    return toolBarItems;
  }

  Future<void> _onChangeToolBarItem(int index) async {
    if (_reviewRepository.toolbarIndex == index) return;
    setState(() => _reviewRepository.toolbarIndex = index);
    // await widget.onRefresh();
  }
}

class _ToolbarItem extends StatefulWidget {
  final bool isActive;
  final String label;
  final Function() onTap;
  const _ToolbarItem({
    required this.isActive,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ToolbarItem> createState() => _ToolbarItemState();
}

class _ToolbarItemState extends State<_ToolbarItem> {
  final GlobalKey _key = GlobalKey();
  double _maxWidth = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _maxWidth = _key.currentContext?.size?.width ?? 0.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: SizedBox(
        height: 40.h,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              key: _key,
              widget.label.toUpperCase(),
              style: AppStyles.text.bold(
                fSize: 15.sp,
                color: !widget.isActive ? AppColors.greyB3 : null,
              ),
            ),
            height(height: 15),
            width(width: _maxWidth + 10.w),
            AnimatedContainer(
              width: widget.isActive ? _maxWidth + 10.w : 0,
              height: 3.h,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
