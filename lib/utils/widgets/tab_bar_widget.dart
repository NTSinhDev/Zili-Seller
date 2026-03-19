import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

class TabBarWidget extends StatefulWidget {
  final List<String> tabs;
  final Function() onChanged;
  final double? height;
  final Color? themeColor;
  const TabBarWidget({
    super.key,
    required this.tabs,
    required this.onChanged,
    this.height,
    this.themeColor,
  });

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget> {
  int tabBarIndex = 0;
  late List<String> tabs;
  late final double defaultHeight;
  final double spaceH = 8.h;

  @override
  void initState() {
    super.initState();
    tabs = widget.tabs;
    defaultHeight = (widget.height ?? 48.h) - spaceH;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Spaces.screenWidth(context),
      height: widget.height ?? (defaultHeight + 28.h),
      child: Container(
        width: Spaces.screenWidth(context),
        color: widget.themeColor ?? AppColors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.fromLTRB(20.w, spaceH, 20.w, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: _generateToolBarItems(),
          ),
        ),
      ),
    );
  }

  List<Widget> _generateToolBarItems() {
    List<Widget> toolBarItems = [];
    for (var i = 0; i < tabs.length; i++) {
      toolBarItems.add(
        _ToolbarItem(
          isActive: tabBarIndex == i,
          label: tabs[i],
          height: defaultHeight,
          onTap: () => _onChangeToolBarItem(i),
        ),
      );
      if (i != tabs.length - 1) {
        toolBarItems.add(width(width: 28));
      }
    }
    return toolBarItems;
  }

  Future<void> _onChangeToolBarItem(int index) async {
    if (tabBarIndex == index) return;
    setState(() => tabBarIndex = index);
    // await widget.onRefresh();
  }
}

class _ToolbarItem extends StatefulWidget {
  final bool isActive;
  final String label;
  final Function() onTap;
  final double height;
  const _ToolbarItem({
    required this.isActive,
    required this.label,
    required this.onTap,
    required this.height,
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
        height: widget.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              key: _key,
              widget.label.toUpperCase(),
              style: AppStyles.text.bold(
                fSize: 15.sp,
                color: widget.isActive
                    ? AppColors.beige
                    : AppColors.lightGrey.withOpacity(0.5),
              ),
            ),
            width(width: _maxWidth + 10.w),
            AnimatedContainer(
              width: widget.isActive ? _maxWidth + 10.w : 0,
              height: 3.h,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: AppColors.beige,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
