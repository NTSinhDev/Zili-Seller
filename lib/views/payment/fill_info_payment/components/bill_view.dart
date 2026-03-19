part of '../fill_info_payment_screen.dart';

class _BillView extends StatelessWidget {
  const _BillView();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(20.w, 30.h, 20.w, 20.h),
          child: Text(
            'THÔNG TIN SẢN PHẨM',
            style: AppStyles.text.semiBold(
              fSize: 18.sp,
              color: AppColors.primary,
            ),
          ),
        ),
        Expanded(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: StreamBuilder<Cart>(
                    stream: di<CartRepository>().cartStream,
                    builder: (context, snapshot) {
                      return Column(
                        children: [
                          Column(
                            children: [
                              if (snapshot.hasData && snapshot.data != null)
                                ..._fetchDataProducts(snapshot.data!.products)
                              else ...[
                                CustomCardWidget.cartItem(),
                                height(height: 10),
                                CustomCardWidget.cartItem(),
                              ],
                            ],
                          ),
                          height(height: 30),
                          const DiscountCode(),
                          height(height: 256),
                        ],
                      );
                    }),
              ),
              const CheckoutView(),
            ],
          ),
        ),
      ],
    );
  }

  List<Widget> _fetchDataProducts(List<ProductCart> products) {
    List<Widget> widgets = [];
    for (var i = 0; i < products.length; i++) {
      widgets.add(
        CustomCardWidget.cartItem(productCart: products[i], readOnly: true),
      );
      if (i < products.length - 1) {
        widgets.add(height(height: 10));
      }
    }
    return widgets;
  }
}
