import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zili_coffee/bloc/cart/cart_cubit.dart';
import 'package:zili_coffee/bloc/product/product_cubit.dart';
import 'package:zili_coffee/data/models/blog/blog.dart';
import 'package:zili_coffee/data/models/cart/product_cart.dart';
import 'package:zili_coffee/data/models/category.dart';
import 'package:zili_coffee/data/models/order/order_line_item.dart';
import 'package:zili_coffee/data/models/product/product.dart';
import 'package:zili_coffee/data/models/product/product_variant.dart';
import 'package:zili_coffee/data/repositories/product_repository.dart';
// import 'package:zili_coffee/data/repositories/review_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/extension/int.dart';
import 'package:zili_coffee/utils/extension/string.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:zili_coffee/views/blog/blog_detail/blog_detail_screen.dart';
import 'package:zili_coffee/views/module_common/options.dart';
import 'package:zili_coffee/views/product/product_detail/product_detail_screen.dart';
import 'package:zili_coffee/views/product/products_by_lineages/products_by_lineages_screen.dart';
part 'components/product/product.dart';
part 'components/product/product_info_modal.dart';
part 'components/product/sale_banner.dart';
part 'components/product/add_to_cart_button.dart';
part 'components/catalog.dart';
part 'components/cart/cart_item.dart';
part 'components/cart/cart_info_view.dart';
part 'components/news/layout_blog_horizontal.dart';
part 'components/news/layout_blog_vertical.dart';

class CustomCardWidget {
  static Widget product({Product? product}) => _Product(product: product);

  static Widget productPlaceholder() => Container();

  static _Catalog catalog({Category? category}) => _Catalog(category: category);

  static StatelessWidget news({
    required Blog? blog,
    required LayoutView layoutView,
    bool fullView = false,
  }) =>
      layoutView == LayoutView.horizontal
          ? _LayoutBlogHorizontal(blog: blog)
          : _LayoutBlogVertical(
              fullView: fullView,
              blog: blog,
            );

  static _CartItem cartItem({
    ProductCart? productCart,
    Function()? removeItem,
    bool? readOnly,
  }) =>
      _CartItem(
        productCart: productCart,
        removeItem: removeItem,
        readOnly: productCart != null ? true : readOnly ?? false,
      );

  static final cartView = CartView();
}

class CartView {
  Widget head({OrderLineItem? orderItem, Function()? more}) =>
      _CartInfoView(more: more, orderItem: orderItem);
  Widget miniHead({OrderLineItem? orderItem, Function()? more}) =>
      _CartInfoView(lessInfo: true, orderItem: orderItem);
}
