import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/voucher/components/voucher.dart';

class DetailVoucherScreen extends StatelessWidget {
  const DetailVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBarWidget.lightAppBar(context, label: 'CHI TIẾT ƯU ĐÃI'),
      body: SizedBox(
        width: Spaces.screenWidth(context),
        height: Spaces.screenHeight(context),
        child: Column(
          children: [
            Voucher(code: 1234567, expiry: DateTime.now()),
            Container(
              width: Spaces.screenWidth(context),
              color: AppColors.lightGrey,
              height: 15,
            ),
            Expanded(
              child: Container(
                color: AppColors.white,
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nội dung ưu đãi',
                      style: AppStyles.text.semiBold(fSize: 16.sp),
                    ),
                    height(height: 15),
                    _itemContent(
                      content: 'Giảm 20.00đ cho hóa đơn từ 199.900đ',
                    ),
                    height(height: 10),
                    _itemContent(
                      content: 'Áp dụng tất cả sản phẩm cà phê cho quán',
                    ),
                    height(height: 10),
                    _itemContent(content: 'HSD: 02/06/2023'),
                    height(height: 10),
                    _itemContent(
                      content:
                          'Không áp dụng song song với các chương trình khuyến mãi khác',
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _itemContent({required String content}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        width(width: 16),
        Container(
          width: 5.w,
          height: 5.h,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.black,
          ),
        ),
        width(width: 11),
        Expanded(
          child: Text(
            content,
            style: AppStyles.text.medium(fSize: 14.sp),
          ),
        ),
      ],
    );
  }
}
