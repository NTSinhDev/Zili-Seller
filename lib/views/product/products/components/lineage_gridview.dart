part of '../products_screen.dart';

class _LineageGridview extends StatelessWidget {
  final List<Product> products;
  final String? title;
  final int? limited;
  const _LineageGridview({
    required this.products,
    this.title,
    this.limited,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (title != null) ...[
          height(height: 20),
          _TitleView(
            title: title!,
            more: () {
              if (products.isNotEmpty && limited != null) {
                context.navigator.pushNamed(
                  ProductsByLineageScreen.keyName,
                  arguments: {0: products, 1: title},
                );
              }
            },
          )
        ],
        SizedBox(
          height: products.isEmpty ? 600.h : calcHeight(products),
          child: GridView.builder(
            padding: EdgeInsets.all(20.w),
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 20.w,
              mainAxisSpacing: 20.w,
              childAspectRatio: 0.59,
            ),
            itemCount: products.isEmpty ? 4 : getCount(products),
            clipBehavior: Clip.none,
            itemBuilder: (BuildContext context, int index) =>
                CustomCardWidget.product(
              product: products.isEmpty ? null : products[index],
            ),
          ),
        ),
        height(height: 10),
      ],
    );
  }

  double calcHeight(List<Product> products) {
    if (limited == null) {
      return (products.length ~/ 2 + (products.length % 2)) * 300.h;
    }
    return getCount(products) < 3 ? 300.h : 600.h;
  }

  int getCount(List<Product> products) {
    if (limited == null) return products.length;
    if (products.length > limited!) return limited!;
    return products.length;
  }
}
