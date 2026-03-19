import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/views/module_common/avatar.dart';
import 'package:zili_coffee/views/product/products_management/products_management_screen.dart';
part 'components/appbar.dart';

class ProductsControlPanelScreen extends StatefulWidget {
  const ProductsControlPanelScreen({super.key});

  @override
  State<ProductsControlPanelScreen> createState() =>
      _ProductsControlPanelScreenState();
}

class _ProductsControlPanelScreenState
    extends State<ProductsControlPanelScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: ThemeApp.systemLight,
      child: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: _listenScrollToLoadmore,
          child: RefreshIndicator(
            onRefresh: _onRefreshScreen,
            color: AppColors.primary,
            child: Scrollbar(
              radius: Radius.circular(4.r),
              child: const CustomScrollView(
                slivers: <Widget>[
                  _SliverAppBar(),
                  SliverToBoxAdapter(child: ProductManagementScreen()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future _onRefreshScreen() async {}

  bool _listenScrollToLoadmore(ScrollNotification scrollNotification) {
    return true;
  }
}
