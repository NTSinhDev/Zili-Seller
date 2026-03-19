part of '../products_screen.dart';

class _LineageGridBaseView extends StatefulWidget {
  const _LineageGridBaseView();

  @override
  State<_LineageGridBaseView> createState() => _LineageGridBaseViewState();
}

class _LineageGridBaseViewState extends State<_LineageGridBaseView> {
  @override
  Widget build(BuildContext context) {
    final ProductRepository productRepository = di<ProductRepository>();

    return StreamBuilder<Map<String, dynamic>>(
      stream: productRepository.productsScreenStreamData.stream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> widgets = [];
          Map<int, List<Product>> productsData =
              snapshot.data?["productsByCategoryIndex"] ?? {};
          List<Category> categories = snapshot.data?["categories"] ?? [];
          for (var i = 0; i < categories.length; i++) {
            widgets.add(
              _LineageGridview(
                title: categories[i].nameDisplay,
                products: productsData[i]!,
                limited: 4,
              ),
            );
          }
          return Column(children: widgets);
        }
        return const Column(
          children: [
            _LineageGridview(
              products: [],
              limited: 4,
            ),
            _LineageGridview(
              products: [],
              limited: 4,
            ),
          ],
        );
      },
    );
  }
}
