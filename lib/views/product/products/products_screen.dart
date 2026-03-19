import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/bloc/category/category_cubit.dart';
import 'package:zili_coffee/bloc/product/product_cubit.dart' as product;
import 'package:zili_coffee/data/models/category.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/repositories/category_repository.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/list.dart';
import 'package:zili_coffee/utils/widgets/slider_widget.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/product/products_by_lineages/products_by_lineages_screen.dart';
part 'components/lineages_coffee.dart';
part 'components/tool_bar.dart';
part 'components/app_bar.dart';
part 'components/filter_view.dart';
part 'components/title_view.dart';
part 'components/lineage_gridview.dart';
part 'components/custom_scaffold.dart';
part 'components/lineage_grid_base_view.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});
  static String keyName = '/products';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showLoading = false;
  bool isFilter = false;

  final product.ProductCubit productCubit = di<product.ProductCubit>();
  final CategoryCubit categoryCubit = di<CategoryCubit>();

  final ProductRepository productRepository = di<ProductRepository>();

  @override
  void initState() {
    super.initState();
    if (!productRepository.productsScreenStreamData.hasValue) {
      productCubit.getProductsScreenData();
    }
  }

  @override
  void dispose() {
    di<CategoryRepository>()
      ..behaviorSelected.sink.add([])
      ..behaviorMinPrice.sink.add(100000)
      ..behaviorMaxPrice.sink.add(1100000);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _CustomScaffold(
      scaffoldKey: _scaffoldKey,
      onEndScroll: _onEndScroll,
      onRefresh: () async {
        if (isFilter) {
          productRepository.behaviorFilterTotalRecord.sink.add(0);
          productRepository.behaviorFilterProducts.sink.add([]);
          await di<CategoryCubit>().getProducts();
        } else {
          productRepository.productsScreenStreamData.sink.add({});
          await productCubit.getProductsScreenData();
        }
      },
      afterFilter: () => setState(() => isFilter = true),
      body: [
        const _LineagesCoffee(),
        height(height: 16),
        StreamBuilder<int>(
          stream: productRepository.behaviorFilterTotalRecord,
          builder: (context, snapshot) {
            return _Toolbar(
              scaffoldKey: _scaffoldKey,
              lengthFromSourceFilter: isFilter,
            );
          },
        ),
        if (isFilter)
          StreamBuilder<List<Product>>(
            stream: productRepository.behaviorFilterProducts,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return _LineageGridview(products: snapshot.data!);
              }
              return const _LineageGridBaseView();
            },
          )
        else
          const _LineageGridBaseView(),
        height(height: 10),
        loadingWidget(),
        height(height: 40),
      ],
    );
  }

  Future<void> _onEndScroll(ScrollMetrics metrics) async {
    if (metrics.pixels == metrics.maxScrollExtent) {
      if (!productRepository.behaviorFilterTotalRecord.hasValue) return;
      if (productRepository.behaviorFilterTotalRecord.value >
          productRepository.behaviorFilterProducts.value.length) {
        if (showLoading) return;
        setState(() => showLoading = true);
        await Future.delayed(const Duration(seconds: 2));
        categoryCubit.getProducts(loadMore: true).then((value) {
          setState(() => showLoading = false);
        });
      }
    }
  }

  Widget loadingWidget() {
    return Visibility(
      visible: showLoading,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 20.w,
            height: 20.w,
            child: const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2.0,
              backgroundColor: AppColors.grayEA,
            ),
          ),
          width(width: 7),
          Text(
            'Loading...',
            style: AppStyles.text.semiBold(
              fSize: 13.sp,
              color: AppColors.primary,
            ),
          )
        ],
      ),
    );
  }
}
