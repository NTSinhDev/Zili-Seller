part of '../roasting_slip_detail_screen.dart';

class _NotFoundView extends StatelessWidget {
  const _NotFoundView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ColumnWidget(
        gap: 16.h,
        crossAxisAlignment: .center,
        mainAxisAlignment: .center,
        children: [
          Image.asset(AssetImages.emptyBoxPng, width: 80, fit: BoxFit.fitWidth),
          Text(
            'Không tìm thấy phiếu rang!',
            style: AppStyles.text.medium(
              fSize: 14.sp,
              color: SystemColors.secondaryPurple10,
            ),
          ),
        ],
      ),
    );
  }
}
