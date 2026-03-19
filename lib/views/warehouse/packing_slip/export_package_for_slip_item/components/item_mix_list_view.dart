part of '../export_package_for_slip_item_screen.dart';

class _ItemMixListView extends StatefulWidget {
  final List<PackingSlipItemMix> itemMixes;
  const _ItemMixListView(this.itemMixes);

  @override
  State<_ItemMixListView> createState() => _ItemMixListViewState();
}

class _ItemMixListViewState extends State<_ItemMixListView> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      gap: 4.h,
      children: [
        RowWidget(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              'Nguyên liệu đã xuất',
              style: AppStyles.text.semiBold(fSize: 16.sp),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                borderRadius: .circular(8.r),
                child: Padding(
                  padding: .symmetric(horizontal: 16.w, vertical: 8.h),
                  child: AnimatedRotation(
                    turns: _isExpanded ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 20.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(
          width: .infinity,
          child: AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? ColumnWidget(
                    gap: 8.h,
                    crossAxisAlignment: .start,
                    children: [
                      Divider(
                        height: 2.h,
                        color: AppColors.greyC0,
                        thickness: 1.sp,
                      ),
                      ...widget.itemMixes.map((item) => _ItemMixCard(item)),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ],
    );
  }
}
