import 'package:flutter/material.dart';
import 'package:zili_coffee/views/product/company_product_details/variants_view.dart';

import '../../../res/res.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/list_screen_template.dart';
import 'information_view.dart';
// import 'inventory_view.dart';

class CompanyProductsDetailsScreen extends StatefulWidget {
  const CompanyProductsDetailsScreen({super.key, required this.productId});
  final String productId;
  static const String routeName = '/company-product/details';

  @override
  State<CompanyProductsDetailsScreen> createState() =>
      _CompanyProductsDetailsScreenState();
}

class _CompanyProductsDetailsScreenState
    extends State<CompanyProductsDetailsScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Chi tiết sản phẩm',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        bottom: BaseFilterTabs(
          tabs: <TabConfig>[
            .new(label: 'Thông tin', value: 0),
            .new(label: 'Phiên bản', value: 1),
            // .new(label: 'Tồn kho', value: 2),
            // .new(label: 'Lịch sử kho', value: 3),
          ],
          selectedTab: _selectedTab,
          onTabChanged: (index, value) {
            if (index < 3 && index != _selectedTab) {
              setState(() {
                _selectedTab = index;
              });
            }
          },
          showFilterButton: false,
        ),
      ),
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: Stack(
        fit: .expand,
        children: [
          InformationView(tabIndex: _selectedTab),
          VariantsView(tabIndex: _selectedTab),
          // if (widget.productId.isNotEmpty)
          //   InventoryView(tabIndex: _selectedTab, productId: widget.productId),
        ],
      ),
    );
  }
}
