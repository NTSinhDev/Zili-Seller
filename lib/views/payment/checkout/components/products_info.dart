part of '../checkout_screen.dart';

class _ProductsInfo extends StatelessWidget {
  const _ProductsInfo();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(20.w),
          child: Text(
            'THÔNG TIN SẢN PHẨM',
            style: AppStyles.text.semiBold(
              fSize: 18.sp,
              color: AppColors.primary,
            ),
          ),
        ),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: StreamBuilder<Cart>(
              stream: di<CartRepository>().cartStream,
              builder: (context, snapshot) {
                return Column(
                  children: [
                    if (snapshot.hasData && snapshot.data != null)
                      ..._fetchDataProducts(snapshot.data!.products)
                    else ...[
                      CustomCardWidget.cartItem(),
                      height(height: 10),
                      CustomCardWidget.cartItem(),
                    ],
                    height(height: 30),
                    const DiscountCode(),
                    height(height: 256),
                  ],
                );
              }),
        ),
      ],
    );
  }

  List<Widget> _fetchDataProducts(List<ProductCart> products) {
    List<Widget> widgets = [];
    for (var i = 0; i < products.length; i++) {
      widgets.add(CustomCardWidget.cartItem(
        productCart: products[i],
        readOnly: true,
      ));
      if (i < products.length - 1) {
        widgets.add(height(height: 10));
      }
    }
    return widgets;
  }
}
